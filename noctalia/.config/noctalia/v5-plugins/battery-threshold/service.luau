--!nonstrict
-- Battery Threshold service for Noctalia v5.
-- Discovers system batteries, uses UPower for ordinary toggles, and delegates
-- privileged mutations to a fixed, root-owned helper.

local IFACE = "org.freedesktop.UPower.Device"
local HELPER = "/usr/libexec/noctalia-battery-threshold-helper"

local devices = {}
local selected = nil
local busy = false
local enumerating = false
local refreshGeneration = 0
local pendingPrivilegedCallback = nil
local helperAvailable = false
local lastError = ""

local function trim(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function shellQuote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function publish(key, value)
    noctalia.state.set("battery_threshold_" .. key, value)
end

local function selectedDevice()
    if selected == nil then
        return nil
    end
    return devices[selected]
end

local function helperInstalled()
    return noctalia.commandExists("pkexec") and helperAvailable
end

local function parseBool(stdout)
    local value = trim(stdout)
    if value:match("^b%s+true") then return true end
    if value:match("^b%s+false") then return false end
    return nil
end

local function parseUInt(stdout)
    local value = trim(stdout)
    local n = value:match("^u%s+(%d+)") or value:match("^(%d+)$")
    return n and tonumber(n) or nil
end

local function splitTabs(line)
    local fields = {}
    local startAt = 1
    while true do
        local tabAt = line:find("\t", startAt, true)
        if tabAt == nil then
            table.insert(fields, line:sub(startAt))
            break
        end
        table.insert(fields, line:sub(startAt, tabAt - 1))
        startAt = tabAt + 1
    end
    return fields
end

local function serializeDevices()
    local rows = {}
    for _, device in ipairs(devices) do
        table.insert(rows, table.concat({
            device.native,
            device.object,
            device.model,
            device.thresholdSupported and "1" or "0",
            device.thresholdFiles and "1" or "0",
            device.forceSupported and "1" or "0",
        }, "\t"))
    end
    return table.concat(rows, "\n")
end

local function publishBaseState()
    local device = selectedDevice()
    publish("devices", serializeDevices())
    publish("device", device and device.native or "")
    publish("object_path", device and device.object or "")
    publish("model", device and device.model or "")
    publish("supported", device and device.thresholdSupported or false)
    publish("threshold_files", device and device.thresholdFiles or false)
    publish("force_supported", device and device.forceSupported or false)
    publish("helper_installed", helperInstalled())
    publish("busy", busy)
    publish("error", lastError)
end

local function getPropFor(device, prop, cb)
    if device == nil then
        cb({ exitCode = 1, stdout = "", stderr = "No battery selected" })
        return
    end
    local cmd = "busctl get-property org.freedesktop.UPower " .. shellQuote(device.object)
        .. " " .. IFACE .. " " .. prop
    if not noctalia.runAsync(cmd, cb, 5000) then
        cb({ exitCode = 127, stdout = "", stderr = "Failed to spawn busctl" })
    end
end

local function getProp(prop, cb)
    getPropFor(selectedDevice(), prop, cb)
end

local function stillSelected(device)
    local current = selectedDevice()
    return current ~= nil and device ~= nil and current.native == device.native and current.object == device.object
end

local function refreshRuntimeState()
    refreshGeneration = refreshGeneration + 1
    local generation = refreshGeneration
    local device = selectedDevice()
    if device == nil then
        publish("enabled", false)
        publish("start", 0)
        publish("end", 0)
        publish("discharging", false)
        publish("charge_behaviour", "")
        publishBaseState()
        return
    end

    local function current()
        return generation == refreshGeneration and stillSelected(device)
    end

    publishBaseState()
    getPropFor(device, "ChargeThresholdEnabled", function(enabledResult)
        if not current() then return end
        publish("enabled", parseBool(enabledResult.stdout) == true)
        getPropFor(device, "ChargeStartThreshold", function(startResult)
            if not current() then return end
            publish("start", parseUInt(startResult.stdout) or 0)
            getPropFor(device, "ChargeEndThreshold", function(endResult)
                if not current() then return end
                publish("end", parseUInt(endResult.stdout) or 0)
                local cmd = "cat /sys/class/power_supply/" .. device.native
                    .. "/charge_behaviour 2>/dev/null || true; "
                    .. "systemctl is-active --quiet noctalia-battery-threshold-discharge@"
                    .. device.native .. ".service && printf '\\n__ACTIVE__' || true"
                noctalia.runAsync(cmd, function(result)
                    if not current() then return end
                    local text = tostring(result.stdout or "")
                    local active = text:find("__ACTIVE__", 1, true) ~= nil
                    local behaviour = trim(text:gsub("__ACTIVE__", ""))
                    publish("charge_behaviour", behaviour)
                    publish("discharging", active or behaviour:find("%[force%-discharge%]") ~= nil)
                    publishBaseState()
                end, 3000)
            end)
        end)
    end)
end

local function chooseDevice()
    if selected ~= nil and devices[selected] ~= nil then
        return
    end
    selected = nil
    for index, device in ipairs(devices) do
        if device.thresholdSupported then
            selected = index
            return
        end
    end
    if #devices > 0 then selected = 1 end
end

local function enumerateDevices()
    if enumerating then return end
    enumerating = true
    local cmd = [=[
[ -x /usr/libexec/noctalia-battery-threshold-helper ] && printf '__HELPER__1\n' || printf '__HELPER__0\n'
upower -e 2>/dev/null | while IFS= read -r obj; do
    native=$(upower -i "$obj" 2>/dev/null | sed -n 's/^[[:space:]]*native-path:[[:space:]]*//p' | head -n1)
    case "$native" in (*[!A-Za-z0-9_-]*|'') continue;; esac
    base="/sys/class/power_supply/$native"
    [ -r "$base/type" ] || continue
    [ "$(cat "$base/type")" = Battery ] || continue
    model=$(cat "$base/model_name" 2>/dev/null | tr '\t\n' '  ')
    [ -n "$model" ] || model="$native"
    supported=0
    [ "$(busctl get-property org.freedesktop.UPower "$obj" org.freedesktop.UPower.Device ChargeThresholdSupported 2>/dev/null)" = "b true" ] && supported=1
    files=0
    [ -e "$base/charge_control_start_threshold" ] && [ -e "$base/charge_control_end_threshold" ] && files=1
    force=0
    grep -q 'force-discharge' "$base/charge_behaviour" 2>/dev/null && force=1
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$native" "$obj" "$model" "$supported" "$files" "$force"
done
]=]
    local ok = noctalia.runAsync(cmd, function(result)
        enumerating = false
        local previousNative = selectedDevice() and selectedDevice().native or nil
        devices = {}
        selected = nil
        if result.exitCode == 0 then
            for line in tostring(result.stdout or ""):gmatch("[^\n]+") do
                if line == "__HELPER__1" then
                    helperAvailable = true
                elseif line == "__HELPER__0" then
                    helperAvailable = false
                else
                    local fields = splitTabs(line)
                    if #fields == 6 and fields[1] ~= "" and fields[2] ~= "" then
                        local native, object, model = fields[1], fields[2], fields[3]
                        table.insert(devices, {
                            native = native,
                            object = object,
                            model = model ~= "" and model or native,
                            thresholdSupported = fields[4] == "1",
                            thresholdFiles = fields[5] == "1",
                            forceSupported = fields[6] == "1",
                        })
                        if native == previousNative then selected = #devices end
                    end
                end
            end
            chooseDevice()
            if #devices == 0 then
                local raw = trim(result.stdout)
                lastError = "No battery parsed (exit " .. tostring(result.exitCode) .. "): " .. (raw ~= "" and raw or "empty output")
            else
                lastError = ""
            end
        else
            lastError = trim(result.stderr) ~= "" and trim(result.stderr) or "Battery discovery failed"
        end
        refreshRuntimeState()
    end, 10000)
    if not ok then
        enumerating = false
        lastError = "Failed to start battery discovery"
        publishBaseState()
    end
end

local function setEnabledFor(device, value, notify, allowBusy)
    if device == nil or not device.thresholdSupported or (busy and not allowBusy) then return end
    busy = true
    publishBaseState()
    local command = "busctl call org.freedesktop.UPower " .. shellQuote(device.object)
        .. " " .. IFACE .. " EnableChargeThreshold b " .. (value and "true" or "false")
    local ok = noctalia.runAsync(command, function(result)
        busy = false
        if result.exitCode ~= 0 then
            lastError = trim(result.stderr) ~= "" and trim(result.stderr) or "Failed to change threshold state"
            noctalia.notify("Battery Threshold", lastError)
        else
            lastError = ""
            if notify ~= false then
                noctalia.notify("Battery Threshold", value and "Charging limit enabled" or "Charging limit disabled")
            end
        end
        refreshRuntimeState()
    end, 10000)
    if not ok then
        busy = false
        lastError = "Failed to spawn busctl"
        publishBaseState()
    end
end

local function setEnabled(value, notify)
    setEnabledFor(selectedDevice(), value, notify, false)
end

local function validateThresholds(startValue, endValue)
    local startN, endN = tonumber(startValue), tonumber(endValue)
    if startN == nil or endN == nil or startN ~= math.floor(startN) or endN ~= math.floor(endN) then
        return nil, nil, "Thresholds must be whole numbers"
    end
    if startN < 0 or startN > 99 or endN < 1 or endN > 100 or startN >= endN then
        return nil, nil, "Use 0–99 for start, 1–100 for end, with start lower than end"
    end
    return startN, endN, nil
end

local function runPrivileged(args, cb, timeout)
    local command = "pkexec " .. HELPER
    for _, arg in ipairs(args) do command = command .. " " .. shellQuote(arg) end
    local ok = noctalia.runAsync(command, function(result)
        local stderr = trim(result.stderr)
        local needsTerminal = result.exitCode ~= 0 and (
            stderr:find("textual authentication agent", 1, true) ~= nil
            or stderr:find("controlling terminal", 1, true) ~= nil
        )
        if needsTerminal then
            noctalia.notify("Battery Threshold", "No graphical PolicyKit agent found. Complete authentication in the terminal.")
            pendingPrivilegedCallback = cb
            local completion = "; rc=$?; noctalia msg plugin dominik/battery-threshold:service all privileged-result \"$rc\""
            noctalia.runInTerminal(command .. completion)
        else
            cb(result)
        end
    end, timeout or 30000)
    if not ok then
        cb({ exitCode = 127, stdout = "", stderr = "Failed to spawn privileged helper" })
    end
end

local function requireHelperAndDevice(requireForce)
    local device = selectedDevice()
    if device == nil then return nil, "No battery selected" end
    if not device.thresholdSupported then return nil, "Selected battery does not support UPower thresholds" end
    if not device.thresholdFiles then return nil, "Selected battery has no kernel threshold files" end
    if not helperInstalled() then return nil, "Install the privileged helper first" end
    if requireForce and not device.forceSupported then return nil, "Selected battery does not support force-discharge" end
    return device, nil
end

local function applyThresholds(startValue, endValue)
    if busy then return end
    local device, capabilityError = requireHelperAndDevice(false)
    local startN, endN, validationError = validateThresholds(startValue, endValue)
    local failure = capabilityError or validationError
    if failure ~= nil then
        lastError = failure
        publishBaseState()
        noctalia.notify("Battery Threshold", failure)
        return
    end
    busy = true
    publishBaseState()
    runPrivileged({ "apply", device.native, tostring(startN), tostring(endN) }, function(result)
        busy = false
        if result.exitCode ~= 0 then
            lastError = trim(result.stderr) ~= "" and trim(result.stderr) or "Failed to apply thresholds"
            noctalia.notify("Battery Threshold", lastError)
        else
            lastError = ""
            noctalia.notify("Battery Threshold", "Charging limit set to " .. startN .. "–" .. endN .. "%")
            setEnabledFor(device, true, false, true)
        end
        refreshRuntimeState()
    end, 30000)
end

local function restoreDefaults()
    if busy then return end
    local device, capabilityError = requireHelperAndDevice(false)
    if capabilityError ~= nil then
        lastError = capabilityError
        publishBaseState()
        noctalia.notify("Battery Threshold", capabilityError)
        return
    end
    busy = true
    publishBaseState()
    runPrivileged({ "reset", device.native }, function(result)
        busy = false
        if result.exitCode ~= 0 then
            lastError = trim(result.stderr) ~= "" and trim(result.stderr) or "Failed to restore system defaults"
            noctalia.notify("Battery Threshold", lastError)
        else
            lastError = ""
            noctalia.notify("Battery Threshold", "System threshold defaults restored")
        end
        enumerateDevices()
    end, 30000)
end

local function setDischarge(start)
    if busy then return end
    local device, capabilityError = requireHelperAndDevice(true)
    if capabilityError ~= nil then
        lastError = capabilityError
        publishBaseState()
        noctalia.notify("Battery Threshold", capabilityError)
        return
    end
    busy = true
    publishBaseState()
    local args = start and { "discharge-start", device.native, tostring(device.endThreshold or 80) }
        or { "discharge-stop", device.native }
    if start then
        getProp("ChargeEndThreshold", function(result)
            args[3] = tostring(parseUInt(result.stdout) or 80)
            runPrivileged(args, function(privilegedResult)
                busy = false
                if privilegedResult.exitCode ~= 0 then
                    lastError = trim(privilegedResult.stderr) ~= "" and trim(privilegedResult.stderr) or "Failed to change discharge state"
                    noctalia.notify("Battery Threshold", lastError)
                else
                    lastError = ""
                    noctalia.notify("Battery Threshold", "Force-discharge started")
                end
                refreshRuntimeState()
            end, 15000)
        end)
    else
        runPrivileged(args, function(result)
            busy = false
            if result.exitCode ~= 0 then
                lastError = trim(result.stderr) ~= "" and trim(result.stderr) or "Failed to stop force-discharge"
                noctalia.notify("Battery Threshold", lastError)
            else
                lastError = ""
                noctalia.notify("Battery Threshold", "Force-discharge stopped")
            end
            refreshRuntimeState()
        end, 15000)
    end
end

function refresh()
    enumerateDevices()
end

function onIpc(event, payload)
    if event == "refresh" then
        enumerateDevices()
    elseif event == "select" then
        if busy then return end
        for index, device in ipairs(devices) do
            if device.native == tostring(payload) then selected = index; break end
        end
        refreshRuntimeState()
    elseif event == "enable" then
        setEnabled(true)
    elseif event == "disable" then
        setEnabled(false)
    elseif event == "set" then
        setEnabled(tostring(payload) == "true" or tostring(payload) == "1" or tostring(payload) == "on")
    elseif event == "toggle" then
        local device = selectedDevice()
        getPropFor(device, "ChargeThresholdEnabled", function(result)
            local current = parseBool(result.stdout)
            if current == nil then
                lastError = trim(result.stderr) ~= "" and trim(result.stderr) or "Cannot read charging-limit state"
                publishBaseState()
                return
            end
            setEnabledFor(device, not current, true, false)
        end)
    elseif event == "apply" then
        local startValue, endValue = trim(payload):match("^(%d+)%s*,%s*(%d+)$")
        applyThresholds(startValue, endValue)
    elseif event == "preset-longevity" then
        applyThresholds(40, 60)
    elseif event == "preset-daily" then
        applyThresholds(70, 80)
    elseif event == "preset-travel" then
        applyThresholds(90, 100)
    elseif event == "reset" then
        restoreDefaults()
    elseif event == "discharge" then
        setDischarge(true)
    elseif event == "stop-discharge" then
        setDischarge(false)
    elseif event == "privileged-result" then
        local callback = pendingPrivilegedCallback
        pendingPrivilegedCallback = nil
        if callback ~= nil then
            local exitCode = tonumber(payload) or 1
            callback({
                exitCode = exitCode,
                stdout = "",
                stderr = exitCode == 0 and "" or "Privileged command failed in terminal",
                terminalFallback = true,
            })
        end
    end
end

function update()
    enumerateDevices()
end

local interval = tonumber(noctalia.getConfig("poll_interval_ms")) or 5000
noctalia.setUpdateInterval(math.max(1000, interval))
enumerateDevices()
