function thingspeak_write(key, target_temp, current_temp, cooling_on)
    net.dns.resolve('api.thingspeak.com', function(ip)
        if not ip then
            print('thingspeak: cannot lookup api.thingspeak.com')
            return
        end

        local logged_target_temp = tostring(target_temp or 0)
        local logged_current_temp = tostring(current_temp or 0)
        local logged_cooling_on = tostring(fif(cooling_on, 1, 0))
        local url = string.format('https://%s/update?key=%s' .. ip .. '/update?' ..
            'key=' .. key ..
            '&target_temp=' .. logged_target_temp ..
            '&current_temp=' .. logged_current_temp ..
            '&cooling_on=' .. logged_cooling_on)
        http.get(url, {}, function(code, response)
            print('thingspeak result: ' .. tostring(code) .. ' --- ' .. tostring(response))
        end)
    end)
end
