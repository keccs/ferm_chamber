
function restart_http_server()
    print("starting http server")
    if srv then
        srv:close()
    end
    mdns.register("ferm_chamber", "http", 80, { hardware='NodeMCU'})
    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
        conn:on("receive", function(client,request)
            local post = string.sub(request, 0, 4) == "POST"

            local post_table = {}
            if post then
                for line in string.gmatch(request, "%S+") do
                    for k, v in string.gmatch(line, "(.*)=(.*)") do
                        post_table[k] = v
                    end
                end
            end

            local buf = ""
            if post then
                local newtemp = tonumber(post_table["temp"])
                target_temp = newtemp
                save_target_temp(newtemp)
                buf = "HTTP/1.1 302 Found\nLocation: /"
            else
                buf = '' ..
                    '<h1>Ferm chamber control</h1>' ..
                    string.format('<h2>Current temp: %s C</h2>', tostring(current_temp))  ..
                    string.format('<h2>Target temp: %s C</h2>', tostring(target_temp)) ..
                    '<form method="post">' ..
                    '    <input type="text" name="temp" value=""></input>' ..
                    '    <input type="submit" value="Set new temp">' ..
                    '</form>' ..
                    '<h2>Thingspeak logs</h2>' ..
                    '<iframe width="600" height="260" style="border: none;" src="https://thingspeak.com/channels/' .. tostring(thingspeak_channel_id) .. '/charts/1?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&type=line"></iframe><br />' ..
                    '<iframe width="600" height="260" style="border: none;" src="https://thingspeak.com/channels/' .. tostring(thingspeak_channel_id) .. '/charts/2?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&type=line"></iframe><br />' ..
                    '<iframe width="600" height="260" style="border: none;" src="https://thingspeak.com/channels/' .. tostring(thingspeak_channel_id) .. '/charts/3?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&type=line"></iframe><br />' ..
                    string.format('<a href="https://thingspeak.com/channels/%d">Go to thingspeak...</a>', thingspeak_channel_id)
            end
            client:send(buf)
            client:close()
            collectgarbage()
        end)
    end)
end
