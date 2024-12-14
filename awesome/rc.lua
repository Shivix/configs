-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

naughty.config.defaults.screen = 1

if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors,
    }
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify {
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
        }
        in_error = false
    end)
end

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max.fullscreen,
}

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

local widgets = require("widgets")
local keymaps = require("keymaps")

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)

    awful.tag(
        { "░░", "░░", "░░", "░░", "░░", "░░", "░░", "░░" },
        s,
        awful.layout.layouts[1]
    )

    s.mypromptbox = awful.widget.prompt()

    s.mytaglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = keymaps.taglist_buttons,
    }

    s.mywibox = awful.wibar { position = "top", screen = s }

    if s == screen.primary then
        s.mywibox:setup(widgets.primary(s))
    else
        s.mywibox:setup(widgets.secondary(s))
    end
end)

root.keys(keymaps.globalkeys)

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keymaps.clientkeys,
            buttons = keymaps.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        },
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true },
    },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- Backup jrnl
local jrnl_location = os.getenv("HOME") .. "/.local/share/jrnl/journal.txt"
local backup_location = os.getenv("HOME") .. "/.local/share/backup/journal.txt.backup"

local file = io.open(backup_location, "r")
if file == nil then
    return
end
local backup_size = file:seek("end")
file:close()
file = io.open(jrnl_location, "r")
if file == nil then
    return
end
local jrnl_size = file:seek("end")
file:close()

if jrnl_size < 500 or jrnl_size < backup_size or jrnl_size > backup_size + 500 then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "The jrnl size is smaller or massively larger than the backup, please check contents and manually backup",
    }
else
    os.execute("cp " .. jrnl_location .. " " .. backup_location)
end
