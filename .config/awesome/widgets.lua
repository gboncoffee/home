local awful     = require "awful"
local gears     = require "gears"
local beautiful = require "beautiful"
local wibox     = require "wibox"
local lain      = require "lain"

local M = {}

local mysep = wibox.widget {
    text   = " ",
    align  = "center",
    widget = wibox.widget.textbox
}

local mydoublesep = wibox.widget {
    text   = "  ",
    align  = "center",
    widget = wibox.widget.textbox
}

-- bar widgets

local mympd = lain.widget.mpd {
    music_dir = "~/mus",
    notify    = "off",
    settings  = function()

        if mpd_now.artist == "N/A" then
            widget:set_markup(" <span foreground='"..beautiful.c.cyan.."'> Nothing playing.</span>")
        else
            local icon = " ||"
            if mpd_now.state == "play" then icon = " |>" end

            local str = " <span foreground='"..beautiful.c.magenta.."'> "
            local artist = mpd_now.artist
            local title  = mpd_now.title

            if mpd_now.artist == "Various" then
                artist = string.sub(mpd_now.title, 1, string.find(mpd_now.title, "-") - 2)
                title  = string.sub(mpd_now.title, string.find(mpd_now.title, "-") + 2)
            end

            str = str .. artist .. "</span> "
            str = str .. "<span foreground='"..beautiful.c.green.."'>::</span>"
            str = str .. "<span foreground='"..beautiful.c.cyan.."'> "..title.."</span>"
            widget:set_markup(str .. icon)
        end
    end,
}
mympd.widget.align = "center"

local mytextdate = wibox.widget {
    format = " %a %b %d ",
    widget = wibox.widget.textclock
}
local mytextclock = wibox.widget {
    format = "  %H:%M ",
    widget = wibox.widget.textclock
}

M.set_bar = function(s, mytaglist)
    s.wb = awful.wibar { position = "right" }
    s.wb:setup {
        layout = wibox.layout.align.vertical,
        {
            {
                mytaglist,
                direction = 'west',
                widget = wibox.container.rotate
            },
            layout = wibox.layout.fixed.vertical,
        },
        {
            layout = wibox.layout.align.vertical,
            {
                mydoublesep,
                widget = wibox.container.rotate,
                direction = 'west',
            },
            {
                mympd.widget,
                widget = wibox.container.rotate,
                direction = 'west',
            }
        },
        {
            layout = wibox.layout.fixed.vertical,
            {
                {
                    mydoublesep,
                    widget = wibox.container.rotate,
                    direction = 'west',
                },
                {
                    {
                        {
                            mytextdate,
                            widget = wibox.container.background,
                            fg = beautiful.c.yellow
                        },
                        {
                            mytextclock,
                            widget = wibox.container.background,
                            fg = beautiful.c.red
                        },
                        layout = wibox.layout.align.horizontal,
                    },
                    widget = wibox.container.rotate,
                    direction = 'west',
                },
                layout = wibox.layout.fixed.vertical,
            },
        },
    }
end

-- popup

local mycalendar = wibox.widget {
    font   = "CaskaydiaCove Nerd Font 20",
    align  = "center",
    widget = wibox.widget.calendar.month
}
mycalendar.spacing  = 15
mycalendar.fn_embed = function(widget, flag, date)
    if flag == "focus" then
        return wibox.widget {
                widget,
                fg = beautiful.border_color_active,
                widget  = wibox.container.background
            }
    end
    return widget
end

local mypopupclock = wibox.widget {
    format = " %H:%M",
    font   = "CaskaydiaCove Nerd Font 40",
    align  = "center",
    widget = wibox.widget.textclock
}

-- audio popup widgets

local popupmpd = lain.widget.mpd {
    music_dir = "~/mus",
    notify    = "off",
    settings  = function()

        if mpd_now.artist == "N/A" then
            widget:set_markup("Nothing playing.")
        else
            local str = "|| "
            if mpd_now.state == "play" then str = "|> " end

            local artist = mpd_now.artist
            local title  = mpd_now.title
            if mpd_now.artist == "Various" then
                artist = string.sub(mpd_now.title, 1, string.find(mpd_now.title, "-") - 2)
                title  = string.sub(mpd_now.title, string.find(mpd_now.title, "-") + 2)
            end

            str = str .. "<span foreground='"..beautiful.c.magenta.."'>" .. artist .. "</span>\n\n"
            str = str .. "<span foreground='"..beautiful.c.cyan.."'>" .. title .. "</span>"
            widget:set_markup(str)
        end
    end,
}
popupmpd.widget.align = "center"
popupmpd.widget.font  = "CaskaydiaCove Nerd Font 20"

local popupalsa = lain.widget.alsa {
    timeout = 2,
    settings = function()
        local init_span = "<span foreground='"..beautiful.c.yellow.."'>"
        if volume_now.status == "off" then
            widget:set_markup(init_span.."  婢 mut".."</span> Muted")
        else
            widget:set_markup(init_span.."  墳 "..volume_now.level.."%".."</span> On")
        end
    end,
}
popupalsa.widget.align = "left"
popupalsa.widget.font  = "CaskaydiaCove Nerd Font 20"

-- battery popup

local popupbattery = lain.widget.bat {
    battery = "BAT1",
    timeout = 10,
    notify = "off",
    settings = function()
        local icon   = "  "
        local status = " Discharging"
        local init_span = " <span foreground='"..beautiful.c.blue.."'>"
        if bat_now.status == "Charging" then
            status = " Charging"
        elseif bat_now.perc <= 20 then
            icon = "  "
        elseif bat_now.perc <= 40 then
            icon = "  "
        elseif bat_now.perc <= 60 then
            icon = "  "
        elseif bat_now.perc <= 80 then
            icon = "  "
        end
        widget:set_markup(init_span..icon..bat_now.perc.."%".."</span>".. status)
    end,
}
popupbattery.widget.align = "left"
popupbattery.widget.font  = "CaskaydiaCove Nerd Font 20"
popupbattery.widget.forced_width  = 400
popupbattery.widget.forced_height = 70

M.set_popup = function(s)
    s.calendar = mycalendar
    s.popup = awful.popup {
        widget = {
            {
                {
                    mydoublesep,
                    popupmpd,
                    layout = wibox.layout.align.vertical,
                },
                {
                    {
                        {
                            mydoublesep,
                            mycalendar,
                            mydoublesep,
                            expand = "outside",
                            layout = wibox.layout.align.horizontal,
                        },
                        {
                            mydoublesep,
                            {
                                mypopupclock,
                                widget = wibox.container.background,
                                fg     = beautiful.c.red,
                            },
                            mydoublesep,
                            expand = "outside",
                            layout = wibox.layout.align.horizontal,
                        },
                        expand = "inside",
                        layout = wibox.layout.align.vertical,
                    },
                    widget = wibox.container.background,
                    bg     = beautiful.c.black,
                },
                {
                    popupbattery,
                    popupalsa,
                    mydoublesep,
                    layout = wibox.layout.align.vertical,
                },
                expand = "none",
                layout = wibox.layout.align.vertical,
            },
            widget = wibox.container.background,
            bg = beautiful.wibar_bg,
            forced_height = 1072,
            forced_width  = 400,
        },
        placement     = awful.placement.right,
        visible       = false,
        ontop         = true,
        border_width  = beautiful.border_width,
        border_color  = beautiful.border_color_active,
    }
end

return M
