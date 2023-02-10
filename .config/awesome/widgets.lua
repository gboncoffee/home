local awful     = require "awful"
local gears     = require "gears"
local beautiful = require "beautiful"
local wibox     = require "wibox"
local lain      = require "lain"

local M = {}

local mysep = wibox.widget {
    text   = "  ",
    align  = "center",
    widget = wibox.widget.textbox
}
local myvisiblesep = wibox.widget {
    {
        text = " | ",
        align = "center",
        widget = wibox.widget.textbox
    },
    fg     = beautiful.c.grey,
    widget = wibox.container.background,
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
        widget:set_markup("<span foreground='"..color.."'>".."Sleep: "..bat_now.perc.."%</span>")
    end,
}

local mycputemp = lain.widget.temp {
    settings = function()
        widget:set_markup("<span foreground='"..beautiful.c.magenta.."'>Coffee: "..coretemp_now.."ºC</span>")
    end
}

local myfs = lain.widget.fs {
    showpopup = "off",
    settings = function()
        local load = string.format("%.2f", fs_now["/"].used)
        local unit = fs_now["/"].units
        widget:set_markup("<span foreground='"..beautiful.c.cyan.."'>Animes: "..load..unit.."</span>")
    end
}

local mymem = lain.widget.mem {
    settings = function()
        widget:set_markup("<span foreground='"..beautiful.c.yellow.."'>Chaos: "..mem_now.used.."Mib</span>")
    end
}

local myday = wibox.widget {
    format = "%a %b %d",
    widget = wibox.widget.textclock,
}

local myclock = wibox.widget {
    format = "%H:%M ",
    widget = wibox.widget.textclock,
}

M.set_bar = function(s, mytaglist, mylayoutbox)
    s.wb = awful.wibar { position = "top" }
    s.wb:setup {
        layout = wibox.layout.align.horizontal,
        {
            mylayoutbox,
            mytaglist,
            mysep,
            mympd.widget,
            layout = wibox.layout.fixed.horizontal,
        },
        mysep,
        {
            mymem.widget,
            mysep,
            myfs.widget,
            mysep,
            mycputemp.widget,
            mysep,
            mybattery.widget,
            myvisiblesep,
            {
                myday,
                widget = wibox.container.background,
                fg = beautiful.c.red,
            },
            mysep,
            {
                myclock,
                widget = wibox.container.background,
                fg = beautiful.c.yellow,
            },
            layout = wibox.layout.fixed.horizontal,
        },
    }
end

return M
