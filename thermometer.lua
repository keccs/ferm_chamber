function get_current_temp (on_temp)
    if get_temp_running then
        on_temp(nil)
        return
    end

    get_temp_running = true
    local pinOw = 4 -- DS18B20 is on pin 4
    local power = 1

    ow.setup(pinOw)

    -- set maximum resolution
    if ow.reset(pinOw) == 0 then
        on_temp(nil)
        return
    end
    ow.skip(pinOw)
    ow.write(pinOw, 0x4e, power)
    ow.write(pinOw, 0, power)
    ow.write(pinOw, 0, power)
    ow.write(pinOw, 0xff, power)

    -- start conversion
    ow.reset(pinOw)
    ow.skip(pinOw)
    ow.write(pinOw, 0x44, power)

    -- wait for temp
    tmr.alarm(6, 750, tmr.ALARM_SINGLE, function()
        -- extract temp
        ow.reset(pinOw)
        ow.skip(pinOw)
        ow.write(pinOw, 0xbe, power)

        local temp = (ow.read(pinOw) + ow.read(pinOw) * 256) / 16.0

        ow.reset(pinOw)
        get_temp_running = false

        on_temp(temp)
    end)
end
