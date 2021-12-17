local testobj = {
    x = 0,
    y = 0
}

setmetatable(testobj,{
    __tostring = function(self)
        return "x, y = ", self.x, self.y
    end,
    __call = function(self, x, y)
        local o = {
            x = x, 
            y = y
        }
        setmetatable(o, {
            -- __index = self,
            __tostring = self.__tostring
        })        
        return o
    end
})


print(testobj)
print(testobj.x, testobj.y)

local t1 = testobj(10, 5)
print(t1)
print(t1.x, t1.y)
