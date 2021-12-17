#!/usr/local/bin/lua

local list = {
    {
        rate = 1000,
        name = "1"
    },
    {
        rate = 2000,
        name = "2"
    },
    {
        rate = 4000,
        name = "3"
    },
    {
        rate = 1234,
        name = "4"
    }
};


math.randomseed(tostring(os.time()):reverse():sub(1, 7)) -- 设置时间种子

local function GetRewardRandomFromList(RewardList, randMax)
    local r = math.random(randMax)
    print(r)
    local t = 0;
    for i = 1, #RewardList do
        t = t + list[i].rate;
        if(r < t) then
            return i
        end
    end
    return 0
end


print(GetRewardRandomFromList(list, 10000))
