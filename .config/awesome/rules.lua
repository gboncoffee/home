local awful     = require "awful"
local beautiful = require "beautiful"

awful.rules.rules = {
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus        = awful.client.focus.filter,
            raise        = true,
            keys         = require "keys".clientkeys(),
            buttons      = require "keys".clientbuttons(),
            screen       = awful.screen.preferred,
            placement    = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },
    -- floating
    {
        rule_any = {
            class = {
                "feh",
                "Gimp",
                "Gnome-screenshot",
                "Xfce-polkit",
                "calculator",
                "music-panel",
                "pulse-panel",
            },
        }, 
        properties = { 
            floating  = true,
            placement = awful.placement.centered
        }
    },
    -- maximized
    {
        rule_any = {
            class = {
                "MPlayer",
                "mpv",
            },
        },
        properties = {
            fullscreen = true
        }
    }
}
