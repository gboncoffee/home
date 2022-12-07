local naughty   = require "naughty"
local beautiful = require "beautiful"

local common_notify = {
    timeout      = 10,
    bg           = beautiful.notification_bg,
    fg           = beautiful.notification_fg
}
local urgent_notify = {
    timeout      = 0,
    bg           = beautiful.notification_urgent_bg,
    fg           = beautiful.notification_fg,
}
naughty.config.presets = {
    low      = common_notify,
    normal   = common_notify,
    critical = urgent_notify
}
naughty.config.defaults.border_width = 4
naughty.config.defaults.font         = beautiful.notification_font
naughty.config.defaults.position     = beautiful.notification_position
