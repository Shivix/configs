local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")

local M = {}

local delimeter = wibox.widget {
    text = "|",
    font = "Inconsolata 22",
    widget = wibox.widget.textbox,
}

local mytextclock = wibox.widget.textclock()
local ram_widget = wibox.widget {
    widget = wibox.widget.textbox,
}

local function update_ram_widget()
    local total_mem, available_mem
    for line in io.lines("/proc/meminfo") do
        if line:match("^MemTotal:") then
            total_mem = tonumber(line:match("%d+"))
        elseif line:match("^MemAvailable:") then
            available_mem = tonumber(line:match("%d+"))
        end

        if total_mem and available_mem then
            break
        end
    end
    local used_mem = total_mem - available_mem
    ram_widget:set_text("RAM: " .. math.floor(used_mem / 1024) .. " MB")
end

gears.timer {
    timeout = 10,
    autostart = true,
    call_now = true,
    callback = update_ram_widget
}

local battery_widget = wibox.widget {
    widget = wibox.widget.textbox,
}

local battery_alert = false
local function update_battery_widget()
    local battery_path = "/sys/class/power_supply/BAT0/"
    local status_file = battery_path .. "status"
    local capacity_file = battery_path .. "capacity"
    local power_file = battery_path .. "power_now"

    local file = assert(io.open(status_file, "r"))
    local status = file:read("*all") == "Discharging\n" and "" or " AC"
    file:close()
    file = assert(io.open(capacity_file, "r"))
    local capacity = tonumber(file:read("*all"))
    file:close()
    file = assert(io.open(power_file, "r"))
    local power_now = file:read("*all")
    file:close()
    local wattage = string.format(" %.2fW", power_now / 1000000)
    battery_widget:set_text(capacity .. "%" .. status .. wattage)

    if capacity < 20 and status == "" and (battery_alert == false or capacity < 10) then
        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Low Battery",
            text = capacity .. "% remaining",
        }
        battery_alert = true
    end
    if capacity > 20 then
        battery_alert = false
    end
end

local file = io.open("/sys/class/power_supply/BAT0/", "r")
if file ~= nil then
    gears.timer {
        timeout = 10,
        autostart = true,
        call_now = true,
        callback = update_battery_widget
    }
    file:close()
else
    battery_widget = nil
end

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

function M.primary(s)
    return {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mypromptbox,
        },
        { -- Center widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
            { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            cpu_widget {
                width = 70,
                step_width = 2,
                step_spacing = 0,
                color = "#D3BC8D",
            },
            delimeter,
            ram_widget,
            delimeter,
            wibox.widget.systray(),
            delimeter,
            battery_widget,
            battery_widget and delimeter or nil,
            mytextclock,
        },
    }
end

function M.secondary(s)
    return {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mypromptbox,
        },
        { -- Center widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
        },
    }
end

return M
