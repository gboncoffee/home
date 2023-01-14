local awful     = require "awful"
local gears     = require "gears"
local beautiful = require "beautiful"

local M = {}

M.set_wallpaper = function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s)
end

M.initscr = function(s)
    M.set_wallpaper(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    local mytaglist = awful.widget.taglist {
        buttons = taglist_buttons,
        filter  = awful.widget.taglist.filter.all,
        screen  = s
    }

    require "widgets".set_bar(s, mytaglist)
    require "widgets".set_popup(s)
end

M.load_each_screen = function()
    awful.screen.connect_for_each_screen(M.initscr)
end

return M
