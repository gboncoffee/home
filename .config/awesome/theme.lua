local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local c = {
    bg     = '#282a36',
    fg     = '#f8f8f2',
    blue   = '#bd93f9',
    red    = '#ff5555',
    yellow = '#f1fa8c',
    cyan   = '#8be9fd',
    grey   = '#6272a4'
}

local theme = {}

theme.c = c

theme.useless_gap       = nil
theme.font              = "Delugia Book Medium 14"
theme.notification_font = "Delugia Book Medium 18"
theme.wallpaper         = os.getenv("HOME") .. "/.config/wallpaper"
theme.wibar_cursor      = "Simple-and-Soft"

theme.border_color_active = c.blue
theme.border_color_normal = c.bg
theme.border_color_urgent = c.red

theme.border_width            = 4
theme.border_width_floating   = 4
theme.border_width_maximized  = 0
theme.border_width_fullscreen = 0

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
theme.notification_height              = 100

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

return theme
