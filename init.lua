uart.setup(0, 115200, 7, uart.PARITY_ODD, uart.STOPBITS_1, 0)

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
target_temp = nil

function main()
    -- start temp->relay checks
    tmr.alarm(0, 5000, tmr.ALARM_AUTO, function()
        get_target_temp(function (read_temp)
            current_temp = read_temp
            if not current_temp or not target_temp then
                set_cooling(false)
            elseif current_temp < target_temp - 0.25 then
                set_cooling(false)
            elseif current_temp > target_temp + 0.25 then
                set_cooling(true)
            end
        end)
    end)

    -- init wifi
    wifi.setmode(wifi.STATION)
    local autoconnect = 1
    wifi.sta.config(wifi_ssid, wifi_password, autoconnect)

    -- start thingspeak sending
    net.dns.setdnsserver('8.8.8.8', 0)
    net.dns.setdnsserver('4.4.4.4', 1)
    tmr.alarm(1, 5000, tmr.ALARM_AUTO, function()
        thingspeak_write(thingspeak_api_key, target_temp, current_temp, get_cooling())
    end)

    -- (re)start http server when we get an ip
    wifi.sta.eventMonReg(wifi.STA_GOTIP, restart_http_server)
    wifi.sta.eventMonStart(1000)
end
main()
