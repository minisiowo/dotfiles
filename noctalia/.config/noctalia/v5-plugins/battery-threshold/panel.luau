--!nonstrict
-- Battery Threshold panel.

local SERVICE_ID = "dominik/battery-threshold:service"

local devices = {}
local selectedDevice = ""
local selectedModel = ""
local objectPath = ""
local supported = false
local thresholdFiles = false
local forceSupported = false
local helperInstalled = false
local enabled = false
local busy = false
local discharging = false
local chargeBehaviour = ""
local startThreshold = 0
local endThreshold = 0
local err = ""
local desiredStart = ""
local desiredEnd = ""
local inputRev = 0
local resetArmed = false
local env = getfenv()

local function shellQuote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function serviceCmd(event, payload)
    local cmd = "noctalia msg plugin " .. SERVICE_ID .. " all " .. event
    if payload ~= nil then cmd = cmd .. " " .. shellQuote(payload) end
    noctalia.runAsync(cmd .. " >/dev/null 2>&1")
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

local function parseDevices(serialized)
    local parsed = {}
    for line in tostring(serialized or ""):gmatch("[^\n]+") do
        local fields = splitTabs(line)
        if #fields == 6 and fields[1] ~= "" and fields[2] ~= "" then
            table.insert(parsed, {
                native = fields[1],
                object = fields[2],
                model = fields[3],
                threshold = fields[4] == "1",
                files = fields[5] == "1",
                force = fields[6] == "1",
            })
        end
    end
    return parsed
end

local function statusText()
    if selectedDevice == "" then return "No battery discovered" end
    if not supported then return "Thresholds not supported" end
    if busy then return "Changing…" end
    return enabled and "Enabled" or "Disabled"
end

local function mutationReason(requireForce)
    if selectedDevice == "" then return "No system battery is selected" end
    if not supported then return "UPower does not expose charge thresholds for this battery" end
    if not thresholdFiles then return "The kernel does not expose charge threshold files" end
    if not helperInstalled then return "Install the privileged helper with sudo ./install-system-helper.sh" end
    if requireForce and not forceSupported then return "This battery does not support force-discharge" end
    return ""
end

local function canMutate(requireForce)
    return not busy and mutationReason(requireForce) == ""
end

local function batteryButtons()
    local rows = {}
    for index, device in ipairs(devices) do
        local callback = "onSelectBattery_" .. index
        env[callback] = function() serviceCmd("select", device.native) end
        local suffix = device.threshold and " · thresholds" or " · unsupported"
        table.insert(rows, ui.button({
            text = device.native .. " — " .. device.model .. suffix,
            variant = device.native == selectedDevice and "primary" or "secondary",
            enabled = not busy,
            onClick = callback,
        }))
    end
    if #rows == 0 then
        table.insert(rows, ui.label({ text = err ~= "" and err or "No internal system battery was discovered by UPower.", color = "error" }))
    end
    return rows
end

local function inputValue(value, fallback)
    if value == nil or tostring(value) == "" then return tostring(fallback or "") end
    return tostring(value)
end

local function render()
    local helperReason = mutationReason(false)
    local dischargeReason = mutationReason(true)
    local body = ui.column({ gap = 14, align = "stretch" }, {
        ui.column({ gap = 7 }, {
            ui.label({ text = "Battery", fontWeight = "bold" }),
            ui.column({ gap = 6 }, batteryButtons()),
            ui.label({
                text = selectedDevice ~= "" and ("Selected: " .. selectedDevice .. " · " .. selectedModel) or "",
                color = "on_surface_variant",
            }),
        }),

        ui.row({ align = "center", justify = "space_between" }, {
            ui.column({ gap = 4, flexGrow = 1 }, {
                ui.label({ text = "Charging limit", fontWeight = "bold" }),
                ui.label({ text = statusText(), color = enabled and "primary" or "on_surface_variant" }),
            }),
            ui.toggle({ checked = enabled, enabled = supported and not busy, onChange = "onToggle" }),
        }),

        ui.column({ gap = 5 }, {
            ui.label({ text = "Capabilities", fontWeight = "bold" }),
            ui.label({ text = "UPower thresholds: " .. (supported and "yes" or "no") }),
            ui.label({ text = "Kernel threshold files: " .. (thresholdFiles and "yes" or "no") }),
            ui.label({ text = "Force-discharge: " .. (forceSupported and "yes" or "no") }),
            ui.label({ text = "Privileged helper: " .. (helperInstalled and "installed" or "not installed"), color = helperInstalled and "on_surface" or "error" }),
        }),

        ui.column({ gap = 6 }, {
            ui.label({ text = "Configured threshold", fontWeight = "bold" }),
            ui.label({ text = supported and (tostring(startThreshold) .. "–" .. tostring(endThreshold) .. "%") or "Unavailable" }),
        }),

        ui.column({ gap = 8 }, {
            ui.label({ text = "Presets", fontWeight = "bold" }),
            ui.row({ gap = 6, align = "stretch" }, {
                ui.button({ text = "Longevity\n  40–60  ", variant = "secondary", enabled = canMutate(false), onClick = "onPresetLongevity", flexGrow = 1 }),
                ui.button({ text = "Daily\n70–80", variant = "secondary", enabled = canMutate(false), onClick = "onPresetDaily", flexGrow = 1 }),
                ui.button({ text = "Travel\n90–100", variant = "secondary", enabled = canMutate(false), onClick = "onPresetTravel", flexGrow = 1 }),
            }),
        }),

        ui.column({ gap = 8 }, {
            ui.label({ text = "Custom threshold", fontWeight = "bold" }),
            ui.row({ gap = 8, align = "center" }, {
                ui.input({ key = "start-" .. inputRev, value = inputValue(desiredStart, startThreshold), placeholder = "Start", onChange = "onStartChanged", flexGrow = 1 }),
                ui.label({ text = "→" }),
                ui.input({ key = "end-" .. inputRev, value = inputValue(desiredEnd, endThreshold), placeholder = "End", onChange = "onEndChanged", onSubmit = "onApplyClicked", flexGrow = 1 }),
            }),
            ui.button({ text = "Apply", variant = "primary", enabled = canMutate(false), onClick = "onApplyClicked" }),
            ui.label({ text = helperReason, color = "error" }),
        }),

        ui.column({ gap = 8 }, {
            ui.label({ text = "Discharge now", fontWeight = "bold" }),
            ui.label({
                text = discharging and "Force-discharge is active and managed by systemd." or "Use battery power while plugged in until the configured end threshold is reached.",
                color = discharging and "primary" or "on_surface_variant",
            }),
            ui.button({
                text = discharging and "Stop discharge" or "Discharge to " .. tostring(endThreshold) .. "%",
                variant = discharging and "destructive" or "secondary",
                enabled = canMutate(true),
                onClick = "onDischargeClicked",
            }),
            ui.label({ text = dischargeReason, color = "error" }),
            ui.label({ text = chargeBehaviour ~= "" and ("Mode: " .. chargeBehaviour) or "", color = "on_surface_variant" }),
        }),

        ui.column({ gap = 8 }, {
            ui.label({ text = "System defaults", fontWeight = "bold" }),
            ui.label({ text = "Removes only the override owned by this plugin for the selected battery.", color = "on_surface_variant" }),
            ui.button({
                text = resetArmed and "Confirm restore defaults" or "Restore system defaults",
                variant = "destructive",
                enabled = canMutate(false),
                onClick = "onResetClicked",
            }),
            ui.label({ text = resetArmed and "Click again to confirm. Custom values for the selected battery will be removed." or "", color = "error" }),
        }),

        ui.column({ gap = 5 }, {
            ui.label({ text = "Backend", fontWeight = "bold" }),
            ui.label({ text = objectPath ~= "" and ("UPower: " .. objectPath) or "No UPower object" }),
        }),

        ui.label({ text = err, color = "error" }),
    })

    panel.render(ui.column({ gap = 12, flexGrow = 1, align = "stretch" }, {
        ui.row({ align = "center", justify = "space_between" }, {
            ui.label({ text = "Battery Threshold", fontSize = 16, fontWeight = "bold", color = "primary", flexGrow = 1 }),
            ui.button({ glyph = "refresh", variant = "ghost", onClick = "onRefreshClicked" }),
            ui.button({ glyph = "close", variant = "ghost", onClick = "onCloseClicked" }),
        }),
        ui.scroll({ flexGrow = 1, gap = 0 }, { body }),
    }))
end

noctalia.state.watch("battery_threshold_devices", function(value) devices = parseDevices(value); render() end)
noctalia.state.watch("battery_threshold_device", function(value)
    local nextDevice = tostring(value or "")
    if nextDevice ~= selectedDevice then
        selectedDevice = nextDevice
        desiredStart = ""
        desiredEnd = ""
        inputRev = inputRev + 1
        resetArmed = false
    end
    render()
end)
noctalia.state.watch("battery_threshold_model", function(value) selectedModel = tostring(value or ""); render() end)
noctalia.state.watch("battery_threshold_object_path", function(value) objectPath = tostring(value or ""); render() end)
noctalia.state.watch("battery_threshold_supported", function(value) supported = value == true; render() end)
noctalia.state.watch("battery_threshold_threshold_files", function(value) thresholdFiles = value == true; render() end)
noctalia.state.watch("battery_threshold_force_supported", function(value) forceSupported = value == true; render() end)
noctalia.state.watch("battery_threshold_helper_installed", function(value) helperInstalled = value == true; render() end)
noctalia.state.watch("battery_threshold_enabled", function(value) enabled = value == true; render() end)
noctalia.state.watch("battery_threshold_busy", function(value) busy = value == true; render() end)
noctalia.state.watch("battery_threshold_discharging", function(value) discharging = value == true; render() end)
noctalia.state.watch("battery_threshold_charge_behaviour", function(value) chargeBehaviour = tostring(value or ""); render() end)
noctalia.state.watch("battery_threshold_start", function(value) startThreshold = tonumber(value) or 0; render() end)
noctalia.state.watch("battery_threshold_end", function(value) endThreshold = tonumber(value) or 0; render() end)
noctalia.state.watch("battery_threshold_error", function(value) err = tostring(value or ""); render() end)

function onOpen(_context)
    desiredStart = tostring(startThreshold)
    desiredEnd = tostring(endThreshold)
    inputRev = inputRev + 1
    serviceCmd("refresh")
    render()
end

function onToggle(value) serviceCmd("set", tostring(value) == "true" and "true" or "false") end
function onStartChanged(value) desiredStart = tostring(value or "") end
function onEndChanged(value) desiredEnd = tostring(value or "") end
function onApplyClicked() serviceCmd("apply", desiredStart .. "," .. desiredEnd) end
function onPresetLongevity() serviceCmd("preset-longevity") end
function onPresetDaily() serviceCmd("preset-daily") end
function onPresetTravel() serviceCmd("preset-travel") end
function onResetClicked()
    if not resetArmed then
        resetArmed = true
        render()
        return
    end
    resetArmed = false
    serviceCmd("reset")
    render()
end
function onDischargeClicked() serviceCmd(discharging and "stop-discharge" or "discharge") end
function onRefreshClicked()
    desiredStart = tostring(startThreshold)
    desiredEnd = tostring(endThreshold)
    inputRev = inputRev + 1
    serviceCmd("refresh")
    render()
end
function onCloseClicked() panel.close() end

render()
