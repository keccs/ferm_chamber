
function restart_http_server()
    if srv then
        srv:close()
    end
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
                local newtemp_str = post_table["temp"];
                local newtemp = tonumber(newtemp_str)
                if newtemp then
                    target_temp = temp
                    save_target_temp(temp)
                end
                print("newtemp: " .. tostring(newtemp))
                buf = "HTTP/1.1 302 Found\nLocation: /"
            else
                buf = '' ..
                    '<h1>Ferm chamber control</h1>' ..
                    '<h2>Current temp</h2>' ..
                    string.format('%d C', current_temp)  ..
                    '<h2>Target temp</h2>' ..
                    string.format('%d °C', target_temp) ..
                    '<form method="post">' ..
                    '    <input type="text" name="temp" value="TODO"></input>' ..
                    '    <input type="submit" value="Set new temp">' ..
                    '</form>' ..
                    '<h2>Thingspeak logs</h2>' ..
                    string.format('<a href="https://thingspeak.com/channels/%d">Go to thingspeak...</a>', thingspeak_channel_id)                    
            end
            client:send(buf)
            client:close()
            collectgarbage()
        end)
    end)
end
