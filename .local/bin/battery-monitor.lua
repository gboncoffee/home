#!/usr/bin/env lua

--
-- System battery notifier ;)
--

sleep = function(sec)
    local s = os.clock()
    while os.clock() - s < sec do end
end

-- BATTERY_PATH = ""
BATTERY_PATH = "/sys/class/power_supply/BAT1/"

open_file_or_panic = function(path)
    local file = io.open(path, "r")
    if file then
        return file
    end
    print("Could not open file " .. path)
    os.exit(false)
end

generate_getter = function(path)
    local input = open_file_or_panic(path)
    local asrt = asrt or function() return true end
    return function()
        input:flush()
        input:seek("set")
        return input:read()
    end
end

getstate = generate_getter(BATTERY_PATH .. "status")
getcapac = generate_getter(BATTERY_PATH .. "capacity")

notify_send = function(head, body, critical)
    if critical then
        os.execute("notify-send --urgency=critical '" .. head .. "' '" .. body .. "'")
    else
        os.execute("notify-send '" .. head .. "' '" .. body .. "'")
    end
end

notify_critical = function()
    notify_send("Critical battery level.", "Please connect the computer to the charger now.", true)
end

notify = function()
    notify_send("Low battery level.", "You may connect the computer to the charger.")
end

connected = function()
    notify_send("Charger connected.", "The computer is now on AV.")
end

disconnected = function()
    notify_send("Charger disconnected.", "The computer is now on battery power.")
end

update_and_notify = function(state)
    local newstate = {
        state = getstate(),
        notf = state.notf,
        notc = state.notc,
    }
    local capac = getcapac()

    print("Status: " .. newstate.state .. " Capacity: " .. capac)

    if (newstate.state == state.state) then
        if (not state.notf) and ((capac + 0) <= 20) then
            newstate.notf = true
            notify()
        end
        if (not state.notc) and ((capac + 0) <= 10) then
            newstate.notc = true
            notify_critical()
        end
    else
        if (newstate.state == "Charging") then
            connected()
            newstate.notf = true
            newstate.notc = true
            newstate.state = "Charging"
        else
            disconnected()
            newstate.state = "Discharging"
            newstate.notf = false
            newstate.notc = false
        end
    end

    return newstate
end

init_state = getstate()
state = {
    state = init_state,
    notf = (init_state == "Charging") or false,
    notc = (init_state == "Charging") or false,
}

while true do
    state = update_and_notify(state)
    sleep(10)
end
