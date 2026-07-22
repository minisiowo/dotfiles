--!nonstrict
-- Battery Threshold bar widget.

local PANEL_ID = "dominik/battery-threshold:panel"
local SERVICE_ID = "dominik/battery-threshold:service"

local supported = false
local enabled = false
local busy = false
local discharging = false
local startThreshold = 0
local endThreshold = 0
local err = ""

local function shellQuote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function serviceCmd(event, payload)
    local cmd = "noctalia msg plugin " .. SERVICE_ID .. " all " .. event
    if payload ~= nil then
        cmd = cmd .. " " .. shellQuote(payload)
    end
    noctalia.runAsync(cmd .. " >/dev/null 2>&1")
end

local function labelText()
    if busy then
        return "…"
    end
    if discharging then
        return "↓" .. tostring(endThreshold) .. "%"
    end
    if not supported then
        return "N/A"
    end
    if enabled then
        return tostring(startThreshold) .. "–" .. tostring(endThreshold) .. "%"
    end
    return "Off"
end

local function render()
    local glyph = noctalia.getConfig("glyph") or "battery-eco"
    barWidget.setGlyph(glyph)

    if noctalia.getConfig("show_label") == true then
        barWidget.setText(labelText())
    else
        barWidget.setText("")
    end

    if not supported then
        barWidget.setGlyphColor("error")
        barWidget.setTooltip("Battery charge thresholds are not supported for this UPower device." .. (err ~= "" and ("\n" .. err) or ""))
    elseif discharging then
        barWidget.setGlyphColor("primary")
        barWidget.setTooltip("Force-discharge active until battery reaches " .. tostring(endThreshold) .. "%")
    elseif enabled then
        barWidget.setGlyphColor("primary")
        barWidget.setTooltip("Battery charge limit enabled: " .. tostring(startThreshold) .. "–" .. tostring(endThreshold) .. "%")
    else
        barWidget.setGlyphColor("on_surface")
        barWidget.setTooltip("Battery charge limit disabled. Click to toggle, right-click for settings.")
    end
end

noctalia.state.watch("battery_threshold_supported", function(value)
    supported = value == true
    render()
end)

noctalia.state.watch("battery_threshold_enabled", function(value)
    enabled = value == true
    render()
end)

noctalia.state.watch("battery_threshold_busy", function(value)
    busy = value == true
    render()
end)

noctalia.state.watch("battery_threshold_discharging", function(value)
    discharging = value == true
    render()
end)

noctalia.state.watch("battery_threshold_start", function(value)
    startThreshold = tonumber(value) or 0
    render()
end)

noctalia.state.watch("battery_threshold_end", function(value)
    endThreshold = tonumber(value) or 0
    render()
end)

noctalia.state.watch("battery_threshold_error", function(value)
    err = tostring(value or "")
    render()
end)

function update()
    render()
end

function onClick()
    if supported and not busy then
        serviceCmd("toggle")
    else
        noctalia.togglePanel(PANEL_ID)
    end
end

function onRightClick()
    noctalia.togglePanel(PANEL_ID)
end

function onMiddleClick()
    serviceCmd("refresh")
end

noctalia.setUpdateInterval(5000)
serviceCmd("refresh")
render()
