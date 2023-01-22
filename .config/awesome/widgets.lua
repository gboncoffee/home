local awful     = require "awful"
local gears     = require "gears"
local beautiful = require "beautiful"
local wibox     = require "wibox"
local lain      = require "lain"

local M = {}

local mysep = wibox.widget {
    {
        text   = " ",
        align  = "center",
        widget = wibox.widget.textbox
    },
    widget = wibox.container.rotate,
    direction = 'west',
}

local mympd = lain.widget.mpd {
    music_dir = "~/mus",
    notify    = "off",
    settings  = function()

        if mpd_now.artist == "N/A" then
            widget:set_markup("<span foreground='"..beautiful.c.cyan.."'>Nothing playing.</span>")
        else
            local title_color = beautiful.c.grey
            if mpd_now.state == "play" then
                title_color = beautiful.c.cyan
            end
            local str = "<span foreground='"..beautiful.c.magenta.."'>"
            local artist = mpd_now.artist
            local title  = mpd_now.title

            if mpd_now.artist == "Various" then
                artist = string.sub(mpd_now.title, 1, string.find(mpd_now.title, "-") - 2)
                title  = string.sub(mpd_now.title, string.find(mpd_now.title, "-") + 2)
            end

            str = str .. artist .. "</span> "
            str = str .. "<span foreground='"..beautiful.c.green.."'>::</span>"
            str = str .. "<span foreground='"..title_color.."'> "..title.."</span>"
            widget:set_markup(str)
        end
    end,
}
mympd.widget.align = "center"
mympd.widget:buttons(gears.table.join(
    awful.button({ }, 1, function() awful.spawn "mpc toggle" end),
    awful.button({ }, 3, function()
        awful.spawn(terminal .. " --class music-panel,music-panel -e ncmpcpp")
    end),
    awful.button({ }, 5, function() awful.spawn "mpc next" end),
    awful.button({ }, 4, function() awful.spawn "mpc prev" end)
))

local mybatteryicon = wibox.widget {
    text   = "",
    align  = "center",
    font   = "CaskaydiaCove Nerd Font 20",
    widget = wibox.widget.textbox,
}
local mybattery = lain.widget.bat {
    notify   = "off",
    battery  = "BAT1",
    ac       = "ADP1",
    settings = function()
        local color = beautiful.c.green
        if bat_now.ac_status + 0 == 1 then
            color = beautiful.c.cyan
        elseif bat_now.perc <= 20 then
            color = beautiful.c.red
        end
        widget:set_markup("<span foreground='"..color.."'>"..bat_now.perc.."</span>")
    end,
}
mybattery.widget.font = beautiful.bigger_font

local myweekday = wibox.widget {
    format = "%a",
    widget = wibox.widget.textclock,
}
local mymonth = wibox.widget {
    format = "%b",
    widget = wibox.widget.textclock,
}
local myday = wibox.widget {
    {
        format = "%d",
        font   = beautiful.bigger_font,
        widget = wibox.widget.textclock,
    },
    left   = 2,
    widget = wibox.container.margin,
}

local myhours = wibox.widget {
    {
        format = "%H",
        font   = beautiful.bigger_font,
        widget = wibox.widget.textclock,
    },
    left   = 2,
    widget = wibox.container.margin,
}
local myminutes = wibox.widget {
    {
        format = "%M",
        font   = beautiful.bigger_font,
        widget = wibox.widget.textclock,
    },
    left   = 2,
    widget = wibox.container.margin,
}
local mytimesep = wibox.widget {
    {
        {
            text = ":",
            font   = beautiful.bigger_font,
            widget = wibox.widget.textbox,
        },
        margins = -5,
        widget = wibox.container.margin,
    },
    direction = "west",
    widget    = wibox.container.rotate,
}

local myend = wibox.widget {
    text   = "ﬦ",
    align  = "center",
    font   = "CaskaydiaCove Nerd Font 20",
    widget = wibox.widget.textbox,
}

M.set_bar = function(s, mytaglist, mylayoutbox)
    s.wb = awful.wibar { position = "right" }
    s.wb:setup {
        layout = wibox.layout.align.vertical,
        {
            mylayoutbox,
            mytaglist,
            mysep,
            {
                mympd.widget,
                widget = wibox.container.rotate,
                direction = "west",
            },
            layout = wibox.layout.fixed.vertical,
        },
        mysep,
        {
            {
                mybatteryicon,
                {
                    mybattery.widget,
                    left   = 2,
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.align.vertical,
            },
            mysep,
            {
                {
                    myweekday,
                    mymonth,
                    myday,
                    layout = wibox.layout.align.vertical,
                },
                widget = wibox.container.background,
                fg = beautiful.c.red,
            },
            mysep,
            {
                {
                    myhours,
                    mytimesep,
                    myminutes,
                    layout = wibox.layout.align.vertical,
                },
                widget = wibox.container.background,
                fg = beautiful.c.yellow,
            },
            {
                {
                    myend,
                    widget = wibox.container.background,
                    fg = beautiful.c.bg,
                },
                widget = wibox.container.background,
                bg = beautiful.c.magenta,
            },
            layout = wibox.layout.fixed.vertical,
        },
    }
end

return M
