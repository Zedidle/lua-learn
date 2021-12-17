#!/usr/local/bin/lua



list = {
    {
        rate = 0.1,
        name = "1"
    },
    {
        rate = 0.2,
        name = "2"
    },
    {
        rate = 0.3,
        name = "3"
    },
    {
        rate = 0.3,
        name = "4"
    }
};

-- 关于随机数种子：


function GetRewardRandomFromList(RewardList)
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    r = math.random()
    print(r)
    t = 0;
    for i = 1, #RewardList do
        t = t + list[i].rate;
        if(r < t) then
            return i
        end
    end
    return 0
end


print(GetRewardRandomFromList(list))
