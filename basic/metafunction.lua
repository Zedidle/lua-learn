local Point = setmetatable({
    x = 0,
    y = 0,
    -- Add = function(self, p) -- 这种写法可以，但第一个参数必须是自己
    --     self.x = self.x + p.x
    --     self.y = self.y + p.y
    -- end,
    new = function(self, o)
        o = o or {}
        setmetatable(o, self) -- 无效。。看看是不是版本不同了！ 建议还是直接看源码吧 unlua和逍遥情缘的
        o.__index = self
        return o
    end
},{

    __index = self, -- 为什么可以？

    __tostring = function(self)
        local output = "x, y = " .. self.x .. ", " .. self.y
        return output
    end,

    __add = function(t1, t2)
        t1.x = t1.x + t2.x
        t1.y = t1.y + t2.y
        return t1
    end,

    __sub = function(t1, t2)
        t1.x = t1.x - t2.x
        t1.y = t1.y - t2.y
        return t1
    end,

    __mul = function(t1, t2)
        t1.x = t1.x * t2.x
        t1.y = t1.y * t2.y
        return t1
    end,

    __div = function(t1, t2)
        t1.x = t1.x / t2.x
        t1.y = t1.y / t2.y
        return t1
    end,

    __mod = function(t1, t2)
        t1.x = t1.x % t2.x
        t1.y = t1.y % t2.y
        return t1
    end,

    __concat = function(t1, t2)
    
    end,

    __eq = function(t1, t2)
        return t1.x == t2.x and t1.y == t2.y
    end,

    __lt = function(t1, t2)
        
    end,

    __le = function(t1, t2)
    
    end,

    __call = function(self, o)
        -- print("__call")
        o = o or {}            
        setmetatable(o, {
            __index = self,
            __tostring = self.__tostring,
        })
        -- o.__index = self
        return o
    end,
})


local p4 = {
    x = 100,
    y = 100
}

Point = Point + p4
print(Point)

-- local p1 = Point()
local p1 = Point:new()
-- function p1.__tostring(self)
--     return "p111"
-- end
-- p1 = p1 + p4
print("p1.x, p1.y:", p1.x, p1.y)
-- p1:Add({x = 40, y=30})
print(p1)


