local gears     = require "gears"
local awful     = require "awful"
require("awful.autofocus")
local wibox     = require "wibox"
local beautiful = require "beautiful"
local naughty   = require "naughty"
local lain      = require "lain"

-- error handling {{{ 
if awesome.startup_errors then
    naughty.notify {
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true
        naughty.notify {
            preset = naughty.config.presets.critical,
            title  = "Oops, an error happened!",
            text   = tostring(err)
        }
        in_error = false
    end)
end
-- }}}

-- vars {{{
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

terminal = "alacritty"
editor = os.getenv("EDITOR")
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating
}
-- }}}

-- bar and screen {{{ 

-- bar buttons {{{
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t)
        t:view_only()
    end),
    awful.button({ }, 3, awful.tag.viewtoggle)
)
-- }}}

-- screen wallpaper {{{
local set_wallpaper = function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}

-- widgets {{{
local mympd = lain.widget.mpd {
    music_dir = "~/mus",
    notify    = "off",
    settings  = function()
        if mpd_now.artist == "N/A" then
            widget:set_text(" nothing playing")
        elseif mpd_now.artist == "Various" then
            widget:set_text(" " .. mpd_now.title)
        else
            widget:set_text(" " .. mpd_now.artist .. " - " .. mpd_now.title)
        end
    end,
}
mympd.widget.align = "center"
local myalsa = lain.widget.alsa {
    timeout = 2,
    settings = function()
        if volume_now.status == "off" then
            widget:set_text "蓼 muted"
        else
            widget:set_text("蓼 " .. volume_now.level .. "%")
        end
    end,
}
local mybattery = lain.widget.bat {
    battery = "BAT1",
    timeout = 10,
    settings = function()
        local icon = " "
        if bat_now.ac_status then
            icon = " "
        end
        widget:set_text(icon .. bat_now.perc .. "%")
    end,
}
local mysep = wibox.widget {
    text   = "  ",
    align  = "center",
    widget = wibox.widget.textbox
}
local mytextclock = wibox.widget {
    format = "羽 %a %b %d, %H:%M ",
    widget = wibox.widget.textclock
}
local myend = wibox.widget {
    text   = "ﬦ",
    font   = "Delugia Book Medium 20",
    align  = "center",
    widget = wibox.widget.textbox
}
-- }}}

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    local mytaglist = awful.widget.taglist {
        buttons = taglist_buttons,
        filter  = awful.widget.taglist.filter.noempty,
        screen  = s
    }

    local wb = awful.wibar { position = "right" }
    wb:setup {
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
                mysep,
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
end)
-- }}}

-- notify {{{
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
-- }}}

-- bindings {{{

spawn = awful.spawn

keymap = function(mods, key, fun)
    return awful.key(mods, key, fun, {})
end

globalkeys = gears.table.join(
    -- focus other clients
    keymap({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end),
    keymap({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end),
    --
    -- layouts
    --
    -- swap clients
    keymap({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end),
    keymap({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end),
    -- focus other screens
    keymap({ modkey, "Control" }, "period", function()
        awful.screen.focus_relative(1)
    end),
    keymap({ modkey, "Control" }, "comma", function()
        awful.screen.focus_relative(-1)
    end),
    -- change master size
    keymap({ modkey }, "l", function()
        awful.tag.incmwfact(0.05)
    end),
    keymap({ modkey }, "h", function()
        awful.tag.incmwfact(-0.05)
    end),
    -- add/remove masters
    keymap({ modkey, "Shift" }, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end),
    keymap({ modkey, "Shift" }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end),
    -- next/previous layout
    keymap({ modkey }, "space", function()
        awful.layout.inc(1)
    end),
    keymap({ modkey, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end),
    -- progs
    --
    -- terminal
    keymap({ modkey }, "Return", function()
        spawn(terminal)
    end),
    -- browser
    keymap({ modkey }, "n", function()
        spawn(os.getenv("BROWSER"))
    end),
    -- music panel
    keymap({ modkey }, "m", function()
        spawn(terminal .. " --class music-panel,music-panel -e ncmpcpp")
    end),
    -- sys monitor
    keymap({ modkey }, "s", function()
        spawn(terminal .. " -t 'Sys Monitor' -e btm")
    end),
    -- file man
    keymap({ modkey }, "f", function()
        spawn(terminal .. " -t Lf -e lf")
    end),
    -- calculator
    keymap({ modkey }, "c", function()
        spawn(terminal .. " -t Calculator --class calculator,calculator -e julia")
    end),
    -- screenshot
    keymap({ modkey }, "p", function()
        spawn "gnome-screenshot -i"
    end),
    --
    -- dmenu
    --
    keymap({ modkey }, "a", function()
        spawn "rofi -show run"
    end),
    -- shutdown
    keymap({ modkey }, "q", function() 
        spawn "dmenu_shutdown"
    end),
    -- passmenu
    keymap({ modkey, "Control" }, "p", function() 
        spawn "passmenu --type"
    end),
    -- web
    keymap({ modkey }, "b", function() 
        spawn "dmenu_web"
    end),
    --
    -- audio
    --
    keymap({ "Mod1", "Control" }, "k", function()
        spawn "pulsevolume --increase"
    end),
    keymap({ "Mod1", "Control" }, "j", function()
        spawn "pulsevolume --decrease"
    end),
    keymap({ "Mod1", "Control" }, "m", function()
        spawn "pulsevolume --mute"
    end),
    keymap({ "Mod1", "Control" }, "p", function()
        spawn "mpc toggle"
    end),
    keymap({ "Mod1", "Control" }, "l", function()
        spawn "mpc next"
    end),
    keymap({ "Mod1", "Control" }, "h", function()
        spawn "mpc prev"
    end),
    keymap({ "Mod1", "Control" }, "equal", function()
        spawn "mpc volume +10"
    end),
    keymap({ "Mod1", "Control" }, "minus", function()
        spawn "mpc volume -10"
    end),
    --
    -- others
    --
    keymap({ modkey, "Control" }, "r", awesome.restart),
    keymap({ "Mod1", "Control" }, "x", function()
        spawn "changexmap"
    end),
    keymap({ "Mod1", "Control" }, "d", function()
        spawn "monitors"
    end),
    keymap({ modkey, "Control" }, "c", function()
        naughty.destroy_all_notifications(nil, nil)
    end),
    keymap({ modkey, "Control" }, "b", function()
        spawn "dmenu_bluetooth"
    end)
)

clientkeys = gears.table.join(
    -- fullscreen
    keymap({ modkey, "Shift" }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end),
    -- kill client
    keymap({ modkey }, "w", function(c)
        c:kill()
    end),
    -- float toggle
    keymap({ modkey, "Shift" }, "t",  awful.client.floating.toggle),
    -- move clients
    keymap({ modkey, "Control" }, "h", function(c)
        c.x = c.x - 15
    end),
    keymap({ modkey, "Control" }, "j", function(c)
        c.y = c.y + 15
    end),
    keymap({ modkey, "Control" }, "k", function(c)
        c.y = c.y - 15
    end),
    keymap({ modkey, "Control" }, "l", function(c)
        c.x = c.x + 15
    end),
    -- resize clients
    keymap({ modkey, "Mod1" }, "k", function(c)
        c.height = c.height - 15
    end),
    keymap({ modkey, "Mod1" }, "j", function(c)
        c.height = c.height + 15
    end),
    keymap({ modkey, "Mod1" }, "h", function(c)
        c.width = c.width - 15
    end),
    keymap({ modkey, "Mod1" }, "l", function(c)
        c.width = c.width + 15
    end),
    -- move to master
    keymap({ modkey, "Shift" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end)
)

for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- view tag only
        keymap({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
            end
        end),
        -- toggle tag
        keymap({ modkey, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
        end),
        -- move client to tag
        keymap({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- rules {{{ 
awful.rules.rules = {
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus        = awful.client.focus.filter,
            raise        = true,
            keys         = clientkeys,
            buttons      = clientbuttons,
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
-- }}}

-- signals {{{ 
client.connect_signal("manage", function (c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color   = beautiful.border_color_active end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_color_normal end)
-- }}}

io.popen(os.getenv("HOME") .. "/.config/awesome/autorun.sh")
