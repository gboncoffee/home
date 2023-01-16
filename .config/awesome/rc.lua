pcall(require, "luarocks.loader")
local gears     = require "gears"
local awful     = require "awful"
require("awful.autofocus")
local wibox     = require "wibox"
local beautiful = require "beautiful"
local naughty   = require "naughty"
local lain      = require "lain"

-- error handling 
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

-- ensure Lua gc runs more often cause of mem leaks
gears.timer.start_new(10, function()
    collectgarbage("step", 20000)
    return true
end)

beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

terminal = "alacritty"
modkey = "Mod4"
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
}

require "notifications"
require "screens".load_each_screen()
require "rules"
require "keys".globalkeys_setup()
require "signals"

io.popen(os.getenv("HOME") .. "/.config/awesome/autorun.sh")
