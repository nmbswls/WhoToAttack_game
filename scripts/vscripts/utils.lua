
function table.count(tbl)
    if(tbl == nil) then
        return 0
    end
    local c = 0
    for _ in pairs(tbl) do
        c = c + 1
    end
    return c
end

function table.random(tbl)
    local key_table = {}
    for k in pairs(tbl) do
        table.insert(key_table, k)
    end

    local rnd = key_table[RandomInt(1, #key_table)]

    return tbl[rnd]
end

function table.randomKey(tbl)
    local key_table = {}
    for k in pairs(tbl) do
        table.insert(key_table, k)
    end

    return key_table[RandomInt(1, #key_table)]
end

function table.contains(tbl, val)

    if(tbl == nil) then
        return false
    end

    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function table.containsKey(tbl, val)
    if(tbl == nil) then
        return false
    end

    for key, _ in pairs(tbl) do
        if key == val then
            return true
        end
    end
    return false
end

function table.find(tbl, key, val)
    if(tbl == nil) then
        return false
    end

    for _, v in pairs(tbl) do
        if v[key] ~= nil and v[key] == val then
            return v
        end
    end
    return nil
end

function table.findcount(tbl, key, val)
    if(tbl == nil) then
        return 0
    end

    local count = 0
    for _, v in pairs(tbl) do
        if v[key] ~= nil and v[key] == val then
            count = count + 1
        end
    end
    return count
end

function table.remove_value(tbl, val)
    if(tbl == nil) then
        return
    end

    local removeIndex = nil
    for i, v in pairs(tbl) do
        if v == val then
            removeIndex = i
            break
        end
    end
    
    if removeIndex ~= nil then
        table.remove(tbl, removeIndex)
    end
end

function table.shallowcopy(tbl)
    local copy
    if type(tbl) == 'table' then
        copy = {}
        for i, v in pairs(tbl) do
            copy[i] = v
        end
    else
        copy = tbl
    end
    return copy
end

function table.shuffle(tbl)
    if(tbl == nil) then
        return
    end

    local t = table.shallowcopy(tbl)
    for i = #t, 2, -1 do
        local j = RandomInt(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function table.print(tbl)
    DeepPrintTable(tbl)
end

function table.exist(tbl, val)
    if(tbl == nil) then
        return false
    end

    for _, v in pairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

function table.clear(tbl)
    if(tbl == nil) then
        return
    end
    
    local count = #tbl
    for i = 1, count do
        tbl[i] = nil
    end
end
