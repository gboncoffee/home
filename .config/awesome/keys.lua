local awful = require "awful"
local gears = require "gears"

local M = {}

local spawn = awful.spawn
local keymap = function(mods, key, fun)
    return awful.key(mods, key, fun, {})
end

local client_movement = function(c, dir)
    if c.floating or awful.layout.getname() == "floating" then
        if dir == "left" then
            c.x = c.x - 15
        elseif dir == "down" then
            c.y = c.y + 15
        elseif dir == "up" then
            c.y = c.y - 15
        elseif dir == "right" then
            c.x = c.x + 15
        end
    else
        awful.client.swap.bydirection(dir, c)
    end
end

-- global keys
M.globalkeys = function()
    local globalkeys = gears.table.join(
        --
        -- layouts
        --
        -- focus other clients
        keymap({ modkey }, "j", function()
            awful.client.focus.byidx(1)
        end),
        keymap({ modkey }, "k", function()
            awful.client.focus.byidx(-1)
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
            awful.tag.incmwfact(0.01)
        end),
        keymap({ modkey }, "h", function()
            awful.tag.incmwfact(-0.01)
        end),
        -- add/remove masters
        keymap({ modkey, "Shift" }, "a", function()
            awful.tag.incnmaster(1, nil, true)
        end),
        keymap({ modkey, "Shift" }, "s", function()
            awful.tag.incnmaster(-1, nil, true)
        end),
        -- next/previous layout
        keymap({ modkey }, "space", function()
            awful.layout.inc(1)
        end),
        keymap({ modkey, "Shift" }, "space", function()
            awful.layout.inc(-1)
        end),
        -- toggle bar
        keymap({ modkey, "Shift" }, "b", function()
            local s = awful.screen.focused()
            s.wb.visible = not s.wb.visible
        end),
        -- toggle popups
        keymap({ modkey, "Shift" }, "c", function()
            local s = awful.screen.focused()
            s.calendar_popup.visible = not s.calendar_popup.visible
            s.audio_popup.visible = not s.audio_popup.visible
            s.battery_popup.visible = not s.battery_popup.visible
            s.calendar.date = os.date("*t")
        end),
        --
        --
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
        -- sound panel
        keymap({ modkey }, "s", function()
            spawn(terminal .. " --class pulse-panel,pulse-panel -e pulsemixer")
        end),
        -- file man
        keymap({ modkey }, "f", function()
            spawn(terminal .. " -t Lf -e lf")
        end),
        -- calculator
        keymap({ modkey }, "c", function()
            spawn(terminal .. " -t Calculator --class calculator,calculator -e julia")
        end),
        -- sys monitor
        keymap({ modkey }, "t", function()
            spawn(terminal .. " -e btm")
        end),
        -- screenshot
        keymap({ modkey }, "p", function()
            spawn "screenshotter"
        end),
        keymap({ modkey, "Shift" }, "p", function()
            spawn "screenshotter select"
        end),
        --
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
        --
        -- audio
        --
        keymap({ "Mod1", "Control" }, "k", function()
            spawn "pulsemixer --change-volume +1"
        end),
        keymap({ "Mod1", "Control" }, "j", function()
            spawn "pulsemixer --change-volume -1"
        end),
        keymap({ "Mod1", "Control" }, "m", function()
            spawn "pulsemixer --toggle-mute"
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
            require "naughty".destroy_all_notifications(nil, nil)
        end),
        keymap({ modkey, "Control" }, "b", function()
            spawn "dmenu_bluetooth"
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
    return globalkeys
end

M.globalkeys_setup = function()
    root.keys(M.globalkeys())
end

-- client keys
M.clientkeys = function()
    return gears.table.join(
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
        keymap({ modkey, "Shift" }, "h", function(c)
            client_movement(c, "left")
        end),
        keymap({ modkey, "Shift" }, "j", function(c)
            client_movement(c, "down")
        end),
        keymap({ modkey, "Shift" }, "k", function(c)
            client_movement(c, "up")
        end),
        keymap({ modkey, "Shift" }, "l", function(c)
            client_movement(c, "right")
        end),
        -- resize clients
        keymap({ modkey, "Control" }, "k", function(c)
            if not c.floating then c.floating = true end
            c.height = c.height - 15
        end),
        keymap({ modkey, "Control" }, "j", function(c)
            if not c.floating then c.floating = true end
            c.height = c.height + 15
        end),
        keymap({ modkey, "Control" }, "h", function(c)
            if not c.floating then c.floating = true end
            c.width = c.width - 15
        end),
        keymap({ modkey, "Control" }, "l", function(c)
            if not c.floating then c.floating = true end
            c.width = c.width + 15
        end),
        -- move to master
        keymap({ modkey, "Shift" }, "Return", function(c)
            if c == awful.client.getmaster() then
                awful.client.swap.byidx(1, c)
            else
                c:swap(awful.client.getmaster())
            end
        end),
        -- toggle sticky
        keymap({ modkey, "Shift" }, "0", function(c)
            c.sticky = not c.sticky
        end),
        -- move between screens
        keymap({ modkey, "Shift" }, "period", function(c)
            c:move_to_screen(c.screen.index + 1)
        end),
        keymap({ modkey, "Shift" }, "comma", function(c)
            c:move_to_screen(c.screen.index - 1)
        end),
        -- all tags toggle
        keymap({ modkey }, "0", function(c)
            local screen = awful.screen.focused()
            local all_toggled = true
            for _, tag in pairs(screen.tags) do
                if not tag.selected then
                    all_toggled = false
                    break
                end
            end
            if all_toggled then
                c.first_tag:view_only()
            else
                for _, tag in pairs(screen.tags) do
                    if not tag.selected then
                        awful.tag.viewtoggle(tag)
                    end
                end
            end
        end)
    )
end

-- client buttons
M.clientbuttons = function()
    return gears.table.join(
        awful.button({ }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
        end),
        awful.button({ modkey }, 1, function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            if not c.floating then c.floating = true end
            awful.mouse.client.move(c)
        end),
        awful.button({ modkey }, 3, function (c)
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            if not c.floating then c.floating = true end
            awful.mouse.client.resize(c)
        end)
    )
end

return M
