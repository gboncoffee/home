local awful     = require "awful"
local gears     = require "gears"
local beautiful = require "beautiful"
local wibox     = require "wibox"
local lain      = require "lain"

local M = {}

local taglist_buttons = function()
    return gears.table.join(
        awful.button({ }, 1, function(t)
            t:view_only()
        end),
        awful.button({ }, 3, awful.tag.viewtoggle)
    )
end

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
            widget:set_markup(" nothing playing")
        elseif mpd_now.artist == "Various" then
            widget:set_markup(" " .. mpd_now.title)
        else
            widget:set_markup(" " .. mpd_now.artist .. " - " .. mpd_now.title)
        end
    end,
}
mympd.widget.align = "center"
-- }}}

local myalsa = lain.widget.alsa { -- {{{
    timeout = 2,
    settings = function()
        if volume_now.status == "off" then
            widget:set_text "蓼 muted"
        else
            widget:set_text("蓼 " .. volume_now.level .. "%")
        end
    end,
} -- }}}

local mybattery = lain.widget.bat { -- {{{
    battery = "BAT1",
    timeout = 10,
    n_perc  = { 10, 20 },
    settings = function()
        bat_notification_charged_preset = {
            title   = "Battery full",
            text    = "You can unplug the cable",
            timeout = 10,
            fg      = beautiful.notification_fg,
            bg      = beautiful.notification_bg
        }
        bat_notification_low_preset = {
            title   = "Battery low",
            text    = "Plug the cable!",
            timeout = 15,
            fg      = beautiful.notification_fg,
            bg      = beautiful.notification_bg
        }
        bat_notification_critical_preset = {
            title   = "Battery exhausted",
            text    = "Shutdown imminent",
            timeout = 0,
            fg      = beautiful.notification_urgent_bg,
            bg      = beautiful.notification_fg
        }
        local icon = " "
        if bat_now.ac_status then
            icon = " "
        end
        widget:set_text(icon .. bat_now.perc .. "%")
    end,
} -- }}}

local mytextclock = wibox.widget { -- {{{
    format = "羽 %a %b %d, %H:%M ",
    widget = wibox.widget.textclock
} -- }}}

local myend = wibox.widget { -- {{{
    text   = "ﬦ",
    font   = "Delugia Book Medium 20",
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
                    mysep,
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

-- popup widgets {{{

local mycalendar = wibox.widget { -- {{{
    font   = "Delugia Book 25",
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
    font   = "Delugia Book 70",
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

return M
