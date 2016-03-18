net.dns.setdnsserver('8.8.8.8', 0)
net.dns.setdnsserver('4.4.4.4', 1)

function thingspeak_write(key, target_temp, current_temp, cooling_on)
    print('updating thingspeak')
    net.dns.resolve('api.thingspeak.com', function(_, ip)
        if not ip then
            print('cannot lookup api.thingspeak.com')
            return
        end
        local url = string.format('https://%s/update?key=%s&field1=%s&field2=%s&field3=%s',
                                  ip,
                                  key,
                                  tostring(target_temp or 0),
                                  tostring(current_temp or 0),
                                  tostring(fif(cooling_on, 1, 0)))
        http.get(url, {}, function(code, response)
            print('thingspeak update response: ' .. tostring(code) .. ' --- ' .. tostring(response))
        end)
    end)
end
