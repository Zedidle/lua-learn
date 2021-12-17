local function printTable(t, level)
    for k,v in pairs(t) do
        if(type(v) == "table") then
            printTable(v, level+10)
        else
            local space = ""
            for i=1, level do
                space = space.." "
            end
            print(space, k, v)
        end
    end
end

local groups = { 
    group = "item0", chance = 1,
    {group = "item1", chance = 10}, 
    {group = "item2", chance = 20}, 
    {group = "item3", chance = 30}
}

printTable(groups, 1)


local function SayHello(wei, pp)
    print(wei.name, wei.hi, pp)
end

SayHello{name="zz", hi="ff"}
SayHello({name="zzz", hi="fff"}, "666")

