pin_fan = 0
pin_cooling = 1

gpio.mode(pin_fan, gpio.OUTPUT)
gpio.mode(pin_cooling, gpio.OUTPUT)
gpio.write(pin_fan, 0)
gpio.write(pin_cooling, 0)

function set_cooling(is_on)
    print("cooling set to " .. fif(is_on, "on", "off"))
    local v = fif(is_on, gpio.HIGH, gpio.LOW)
    gpio.write(pin_fan, v)
    gpio.write(pin_cooling, v)
end

function get_cooling()
    return gpio.read(pin_cooling) == gpio.HIGH
end
