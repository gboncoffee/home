local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local c = {
    bg      = '#282a36',
    fg      = '#f8f8f2',
    blue    = '#bd93f9',
    red     = '#ff5555',
    yellow  = '#f1fa8c',
    cyan    = '#8be9fd',
    magenta = '#ff92df',
    green   = '#50fa7b',
    grey    = '#6272a4',
    black   = '#21222c',
}

local theme = {}

theme.c = c

theme.useless_gap       = 4
theme.font              = "CaskaydiaCove Nerd Font 12"
theme.notification_font = "CaskaydiaCove Nerd Font 14"
theme.wallpaper         = os.getenv("HOME") .. "/.config/wallpaper"

theme.border_color_active = c.blue
theme.border_color_normal = c.bg
theme.border_color_urgent = c.red

theme.border_width            = 2
theme.border_width_floating   = 2

-- fullscreen
theme.fullscreen_hide_border = true

-- maximized
theme.maximized_hide_border = true

-- notification
theme.notification_position            = 'bottom_right'
theme.notification_bg                  = c.bg
theme.notification_fg                  = c.fg
theme.notification_urgent_bg           = c.red
theme.notification_border_width        = 14
theme.notification_border_color        = c.blue
theme.notification_urgent_border_color = c.fg
theme.notification_opacity             = 90
theme.notification_width               = 500

--
-- bar
--
theme.wibar_bg = c.bg
theme.wibar_fg = c.fg

-- taglist
theme.taglist_fg_focus  = c.bg
theme.taglist_bg_focus  = c.blue
theme.taglist_fg_urgent = c.fg
theme.taglist_bg_urgent = c.red
theme.taglist_fg_empty  = c.grey
theme.taglist_spacing   = 0

-- layoutbox
theme.layout_floating   = themes_path.."default/layouts/floatingw.png"
theme.layout_tile       = themes_path.."default/layouts/tilew.png"

return theme
