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
            placement    = awful.placement.centered
        }
    },
    -- floating
    {
        rule_any = {
            class = {
                "feh",
                "Gimp",
                "Xfce-polkit",
                "calculator",
                "music-panel",
                "pulse-panel",
                "QjackCtl",
                "Guitarix",
            },
            name = {
                "Open File",
            },
        }, 
        properties = { 
            floating  = true,
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
