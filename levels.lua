local function printTable(t, level)
    local space = ""
    for i=1, level do
        space = space.." "
    end
    for k,v in pairs(t) do
        if(type(v) == "table") then
            print(space..k..":")
            printTable(v, level+10)
        else
            print(space, k, v)
        end
    end
end


local player = {}

for i=1, 5 do
    -- player = player[i] -- 不行，相当于c++的右值
    player[tostring(i)] = i * i
end

printTable(player, 10)