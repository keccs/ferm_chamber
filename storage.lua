file_name = 'target_temp'

function get_target_temp()
    if file.open(file_name, 'r') then
        temp = file.readline()
        file.close()
        return tonumber(temp)
    else
        return nil
    end
end

function set_target_temp(temp)
    file.open(file_name, 'w+')
    file.writeline(tostring(temp))
    file.close()
end
