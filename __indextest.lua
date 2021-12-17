
local api = {}  
local _class = {} -- 所有类的虚表的记录
local _super = {}
function api.class()
    local class_type = {
        x = 1, -- 如果这里设置了，再来找x，就不会触发__index了；
        y = 2,
    }

    class_type.ctor = nil -- 构造函数

    class_type.new = function()
        local o = {}
        if class_type.ctor then
            class_type:ctor()
        end
        -- 当o没有找到对应的键值时，会让class_type找，如果class_type也没找到时，会让class_type的元表来找；
        -- 后面就能看到class_type的元表就是它的父类们的键值的集合；
        setmetatable(o, class_type) 
        return o
    end

    -- 错误的做法，matatable2 会完全覆盖 metatable1；
    -- local metatable1 = {
    --     __index = function(o, k)
    --         print("metatable1 __index")
    --         return o[k]
    --     end
    -- }
    -- local metatable2 = {
    --     __newindex = function(o, k, v)
    --         print("metatable2 __newindex")
    --         o[k] = v
    --     end
    -- }
    -- setmetatable(class_type, metatable1)
    -- setmetatable(class_type, metatable2)




    -- 正确的做法：直接写好一个完整的
    local vtbl = {}
    _class[class_type] = vtbl

    setmetatable(class_type, {
        __newindex = function(o, k, v)
            print("vtbl __newindex")
            vtbl[k] = v
        end,
        __index = vtbl
    })

    








    return class_type
end

-- local O = api.class() -- 这只是一个类，不该去操作
-- function O:ctor()
--     print("O:ctor")
-- end

-- local o1 = O:new()
-- print(o1.x, o1.y)








-- 标的长度测试

-- local t1 = {}
-- local t2 = {}
-- local t3 = {}

-- T ={}
-- T[t1] = 10
-- T[t2] = 20
-- -- #T只能计算序列长度，而不能计算hashmap的长度；
-- print(T[t1], T[t2], #T) -- 10  20  0
-- table.insert(T, t1)
-- table.insert(T, t2)
-- print(#T) -- 2

-- T[1] = t1
-- T[2] = t2
-- T[4] = t3
-- print(#T) -- 4, 如何计算跳跃距离
-- for i=1, #T do -- 会循环4次，第3个为nil
--     print(T[i])
-- end








