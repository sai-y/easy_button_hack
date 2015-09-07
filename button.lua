--button.lua
buttonPin = 2 
local pin = 0            
local value = gpio.LOW
local duration = 1000   
gpio.mode(buttonPin,gpio.INT,gpio.PULLUP)
gpio.mode(pin,gpio.OUTPUT,gpio.PULLUP)

gpio.write(pin, value)
-- Function toggles LED state
function toggleLED ()
    if value == gpio.LOW then
        value = gpio.HIGH
    else
        value = gpio.LOW
    end

    gpio.write(pin, value)
end

function debounce (func)
    local last = 0
    local delay = 200000

    return function (...)
        local now = tmr.now()
        if now - last < delay then return end

        last = now
        return func(...)
    end
end

function onChange()
    if gpio.read(buttonPin) == 0 then
        print("That was easy! ")
		gpio.write(pin, gpio.LOW)
		tmr.stop(0)
		tmr.alarm(2, 900000, 0, function()
			tmr.alarm(0, duration, 1, toggleLED)
		end)
		
        tmr.delay(500000)
    end
end

gpio.trig(buttonPin,"down", debounce(onChange))
tmr.alarm(2, 300000, 0, function()
			tmr.alarm(0, duration, 1, toggleLED)
		end)