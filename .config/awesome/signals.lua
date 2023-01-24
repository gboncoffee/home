local awful     = require "awful"
local beautiful = require "beautiful"
local gears     = require "gears"

local move_mouse_onto_focused_client = function()
    local c = client.focus
    gears.timer({ timeout = 0.1,
        autostart   = true,
        single_shot = true,
        callback    = function()
            if mouse.object_under_pointer() ~= c then
                local geometry = c:geometry()
                local x = geometry.x + geometry.width/2
                local y = geometry.y + geometry.height/2
                mouse.coords({x = x, y = y}, true)
            end
        end
    })
end

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

client.connect_signal("focus", move_mouse_onto_focused_client)
client.connect_signal("swapped", move_mouse_onto_focused_client)

screen.connect_signal("property::geometry", require "screens".set_wallpaper)
