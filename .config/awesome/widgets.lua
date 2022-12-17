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

-- bar widgets {{{

local mympd = lain.widget.mpd { -- {{{
    music_dir = "~/mus",
    notify    = "off",
    settings  = function()

        if mpd_now.artist == "N/A" then
            widget:set_markup(" nothing playing")
        else
            local icon = " "
            if mpd_now.state == "play" then icon = " " end
            if mpd_now.artist == "Various" then
                widget:set_markup(" " .. mpd_now.title .. icon)
            else
                widget:set_markup(" " .. mpd_now.artist .. " - " .. mpd_now.title .. icon)
            end
        end
    end,
}
mympd.widget.align = "center"
-- }}}

local myalsa = lain.widget.alsa { -- {{{
    timeout = 2,
    settings = function()
        if volume_now.status == "off" then
            widget:set_text "婢 mut"
        else
            widget:set_text("墳 " .. volume_now.level .. "%")
        end
    end,
} -- }}}

local mybattery = lain.widget.bat { -- {{{
    battery = "BAT1",
    timeout = 10,
    notify  = "off",
    settings = function()
        local icon = " "
        if bat_now.status == "Charging" then
            icon = " "
        elseif bat_now.perc <= 20 then
            icon = " "
        elseif bat_now.perc <= 30 then
            icon = " "
        elseif bat_now.perc <= 40 then
            icon = " "
        elseif bat_now.perc <= 50 then
            icon = " "
        elseif bat_now.perc <= 60 then
            icon = " "
        elseif bat_now.perc <= 70 then
            icon = " "
        elseif bat_now.perc <= 80 then
            icon = " "
        elseif bat_now.perc <= 90 then
            icon = " "
        end
        widget:set_text(icon .. bat_now.perc .. "%")
    end,
} -- }}}

local mytextclock = wibox.widget { -- {{{
    format = " %a %b %d, %H:%M ",
    widget = wibox.widget.textclock
} -- }}}

local myend = wibox.widget { -- {{{
    text   = "ﬦ",
    font   = "CaskaydiaCove Nerd Font 25",
    align  = "center",
    widget = wibox.widget.textbox
} -- }}}

-- }}}

M.set_bar = function(s, mytaglist) -- {{{
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
                {
                    mympd.widget,
                    widget = wibox.container.background,
                    fg = beautiful.c.cyan
                },
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
                        myalsa.widget,
                        widget = wibox.container.background,
                        fg = beautiful.c.yellow
                    },
                    widget = wibox.container.rotate,
                    direction = 'west',
                },
                {
                    mysep,
                    widget = wibox.container.rotate,
                    direction = 'west',
                },
                {
                    {
                        mybattery.widget,
                        widget = wibox.container.background,
                        fg = beautiful.c.blue
                    },
                    widget = wibox.container.rotate,
                    direction = 'west',
                },
                {
                    mysep,
                    widget = wibox.container.rotate,
                    direction = 'west',
                },
                {
                    {
                        mytextclock,
                        widget = wibox.container.background,
                        fg = beautiful.c.red
                    },
                    widget = wibox.container.rotate,
                    direction = 'west',
                },
                layout = wibox.layout.fixed.vertical,
            },
            {
                {
                    myend,
                    widget = wibox.container.background,
                    direction = 'north',
                },
                layout = wibox.layout.fixed.vertical,
            }
        },
    }
end -- }}}

-- calendar widgets {{{

local mycalendar = wibox.widget { -- {{{
    font   = "CaskaydiaCove Nerd Font 22",
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
-- }}}

local mypopupclock = wibox.widget { -- {{{
    format = "%H:%M",
    font   = "CaskaydiaCove Nerd Font 70",
    align  = "center",
    widget = wibox.widget.textclock
} -- }}}

-- }}}

M.calendar_popup = function(s) -- {{{
    s.calendar       = mycalendar
    s.calendar_popup = awful.popup {
        widget = {
            {
                {
                    mysep,
                    mypopupclock,
                    layout = wibox.layout.align.horizontal
                },
                {
                    mysep,
                    mycalendar,
                    mysep,
                    layout = wibox.layout.align.horizontal,
                    expand = "outside",
                },
                layout = wibox.layout.align.vertical,
            },
            bg      = beautiful.wibar_bg,
            widget  = wibox.container.background
        },
        placement      = awful.placement.centered,
        visible        = false,
        ontop          = true,
        minimum_width  = 600,
        border_width   = beautiful.border_width,
        border_color   = beautiful.border_color_active
    }
end -- }}}

-- audio popup widgets {{{

local popupmpd = lain.widget.mpd { -- {{{
    music_dir = "~/mus",
    notify    = "off",
    settings  = function()

        if mpd_now.artist == "N/A" then
            widget:set_markup("Nothing playing.")
        else
            local status = "Paused:\n"
            local init_span = "<span foreground='"..beautiful.c.cyan.."'>"
            if mpd_now.state == "play" then status = "Playing:\n" end
            if mpd_now.artist == "Various" then
                widget:set_markup(init_span..status.."</span>"..string.gsub(mpd_now.title, "-", "\n", 1, true))
            else
                widget:set_markup(init_span..status.."</span>"..mpd_now.artist.."\n"..mpd_now.title)
            end
        end
    end,
}
popupmpd.widget.align = "center"
popupmpd.widget.font  = "CaskaydiaCove Nerd Font 25"
-- }}}

local popupalsa = lain.widget.alsa { -- {{{
    timeout = 2,
    settings = function()
        local init_span = "<span foreground='"..beautiful.c.yellow.."'>"
        if volume_now.status == "off" then
            widget:set_markup(init_span.." 婢 mut".."</span>")
        else
            widget:set_markup(init_span.." 墳 "..volume_now.level.."%".."</span>")
        end
    end,
}
popupalsa.widget.align = "center"
popupalsa.widget.font  = "CaskaydiaCove Nerd Font 50"
-- }}}

-- }}}

M.audio_popup = function(s) -- {{{
    s.audio_popup = awful.popup {
        widget = {
            {
                popupmpd,
                {
                    mysep,
                    popupalsa,
                    mysep,
                    layout = wibox.layout.align.horizontal,
                    expand = "outside",
                },
                layout = wibox.layout.align.horizontal,
            },
            bg      = beautiful.wibar_bg,
            widget  = wibox.container.background
        },
        placement      = function(c)
            awful.placement.bottom(c, { margins = 100 })
        end,
        visible        = false,
        ontop          = true,
        border_width   = beautiful.border_width,
        border_color   = beautiful.border_color_active
    }
end -- }}}

-- battery popup {{{

local popupbattery = lain.widget.bat { -- {{{
    battery = "BAT1",
    timeout = 10,
    notify = "off",
    settings = function()
        local icon   = "  "
        local status = " Discharging"
        local init_span = "<span foreground='"..beautiful.c.blue.."'>"
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
popupbattery.widget.align = "center"
popupbattery.widget.font  = "CaskaydiaCove Nerd Font 25"
popupbattery.widget.forced_width  = 400
popupbattery.widget.forced_height = 70
-- }}}

M.battery_popup = function(s) -- {{{
    s.battery_popup = awful.popup {
        widget    = {
            {
                popupbattery,
                layout = wibox.layout.align.horizontal,
            },
            bg      = beautiful.wibar_bg,
            widget  = wibox.container.background
        },
        placement = function(c)
            awful.placement.top(c, { margins = 100 })
        end,
        visible        = false,
        ontop          = true,
        border_width   = beautiful.border_width,
        border_color   = beautiful.border_color_active
    }
end -- }}}

-- }}}

return M
