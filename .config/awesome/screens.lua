local awful     = require "awful"
local wibox     = require "wibox"
local gears     = require "gears"
local beautiful = require "beautiful"

local M = {}

M.set_wallpaper = function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s)
end

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end)
)

M.initscr = function(s)

    M.set_wallpaper(s)
    awful.tag(
        {
            "1",
            "2",
            "3",
            "4",
            "5",
            "6",
            "7",
            "8",
            "9",
        },
        s,
        awful.layout.layouts[1])

    local mylayoutbox = awful.widget.layoutbox(s)
    mylayoutbox:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    local mytaglist = awful.widget.taglist {
        filter  = awful.widget.taglist.filter.all,
        screen  = s,
        buttons = taglist_buttons,
        layout = wibox.layout.fixed.vertical,
        widget_template = {
            {
                align  = "center",
                id     = "text_role",
                widget = wibox.widget.textbox,
            },
            id     = "background_role",
            widget = wibox.container.background,
        },
    }

    require "widgets".set_bar(s, mytaglist, mylayoutbox)
end

M.load_each_screen = function()
    awful.screen.connect_for_each_screen(M.initscr)
end

return M
