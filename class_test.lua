-- local oo = require "class"
-- local testobj = oo.class()
-- function testobj:ctor(x, y)
-- function testobj:ctor(o, x, y)
--     print("testobj:ctor")
--     print(o.a)
--     print("x, y:", x, y )
--     self.x = x
--     self.y = y
-- end
-- testobj:new(10, 10)
-- print(testobj.a)
-- print(testobj.x, testobj.y)


local UObject = require "class"
local object = UObject()
-- object["a"] = 1
-- print(object["a"])

-- object.a = 1
-- print(object.a)

object:SetPrivate("Func_A", function(o, k, v)
    print("Hello A")
end)
-- object:Func_A()

-- print(object.private) -- 堆栈提示

-- 类型测试
-- print(type(object.SetPrivate)) -- function
-- function Func_A()
-- end
-- print(type(Func_A))
-- print(type(100))
-- print(type("100"))
-- print(type(nil))
-- print(type(false))


object:SetPrivate("A", 100)
-- object["A"] = 101
-- print(object.A)

function object:RunSomething()
    print("object:RunSomething")
    print(self:GetPrivate("A"))
    self:GetPrivate("Func_A")() -- 可以内部调用私有函数，如果判断调用时的外部环境
end
object:RunSomething()
object:GetPrivate("Func_A")() -- 应该报错误，不能外部调用私有函数,

-- print(#object)


print("\n")
local AActor = UObject({
    x = 0,
    y = 0,
}) 
print(AActor.x, AActor.y)

