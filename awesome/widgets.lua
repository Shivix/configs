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
local cpu_widget = wibox.widget {
    widget = wibox.widget.textbox,
}

local idle_prev
local total_prev
local function update_cpu_widget()
    local handle = assert(io.popen("grep --max-count=1 ^cpu. /proc/stat"))
    local result = handle:read("*all")
    handle:close()
    local cpu_stats = {}
    for word in result:gmatch("(%d+)") do
        table.insert(cpu_stats, tonumber(word))
    end
    local idle = cpu_stats[4]
    local total = 0
    for i = 1, #cpu_stats - 2 do
        total = total + cpu_stats[i]
    end

    local diff_idle = idle - tonumber(idle_prev or 0)
    local diff_total = total - tonumber(total_prev or 0)
    local usage = (1 - diff_idle / diff_total) * 100
    cpu_widget:set_text("CPU: " .. math.floor(usage) .. "%")
    idle_prev = idle
    total_prev = total
end

gears.timer {
    timeout = 10,
    autostart = true,
    call_now = true,
    callback = update_cpu_widget
}

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
    local wattage = ""
    if status == "" then
        file = assert(io.open(power_file, "r"))
        local power_now = file:read("*all")
        file:close()
        wattage = string.format(" %.2fW", power_now / 1000000)
    end
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
            cpu_widget,
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
