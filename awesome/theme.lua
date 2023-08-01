local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme = {}

theme.font = "sans 8"

theme.bg_normal = "#161616"
theme.bg_focus = "#333333cb"
theme.bg_urgent = "#E59400"
theme.bg_minimize = "#444444db"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#bcaf8e"
theme.fg_focus = "#E59400"
theme.fg_urgent = "#ebdbb2"
theme.fg_minimize = "#ebdbb2"

theme.useless_gap = dpi(3)
theme.border_width = dpi(1)
theme.border_normal = theme.bg_normal
theme.border_focus = "#996900"
theme.border_marked = "#91231c"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size,
    theme.fg_normal
)

theme.wallpaper = "~/Pictures/Wallpapers/sidcyberpunk.png"

return theme
