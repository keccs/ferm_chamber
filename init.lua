function fif(cond, if_true, if_false)
    if cond then return if_true else return if_false end
end

-- this should set the globals wifi_ssid, wifi_password, thingspeak_api_key, thingspeak_channel_id
require('credentials')
require('thermometer')
require('relay')
require('storage')
require('httpserv')
require('thingspeak')

current_temp = nil
target_temp = read_target_temp()

-- temp check, start/stop cooling and send result to thingspeak
function work()
    get_current_temp(function (read_temp)
        current_temp = read_temp
        print('current_temp:' .. tostring(current_temp) .. ' target_temp:' .. tostring(target_temp))
        if not current_temp or not target_temp then
            set_cooling(false)
        elseif current_temp < target_temp - 0.25 then
            set_cooling(false)
        elseif current_temp > target_temp + 0.25 then
            set_cooling(true)
        end
        thingspeak_write(thingspeak_api_key, target_temp, current_temp, get_cooling())
    end)
end

function main()
    print('main started')
    print('target_temp:' .. tostring(target_temp))

    work()
    tmr.alarm(0, 30000, tmr.ALARM_AUTO, work)

    -- (re)start http server when we get an ip
    wifi.sta.eventMonReg(wifi.STA_GOTIP, restart_http_server)
    wifi.sta.eventMonStart(1000)

    -- init wifi
    wifi.setmode(wifi.STATION)
    local autoconnect = 1
    wifi.sta.config(wifi_ssid, wifi_password, autoconnect)
end
main()
