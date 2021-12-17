local oo = require "class3"
local A = oo.class()
-- 构造函数
-- 为什么这里第一个参数是 o ？ 貌似游戏里又不同，照抄的吧  
-- 其实一样，在构造Player时，构造子模块会传player作为playerComponent的参数；可以看到，所有playerComponent的ctor的参数都只有一个，而且是player
function A:ctor(o, x, y, name)
    print("A:ctor:", x, y)
    self.x = x
    self.y = y
    self.name = name


end

function A:sayHello()
    print(self.name..".sayHello A")
end




-- 封装，实例与实例，实例与类之间的数据各自独立，因为其内部维护了自己的域
-- local a1 = A:new(10, 10, "a1") -- A:ctor: 10	10
-- local a2 = A:new(15, 15, "a2") -- A:ctor: 15    15
-- print(a1.x, a1.y) -- 10, 10
-- print(a2.x, a2.y) -- 15, 15
-- print(A.x, A.y) -- nil, nil
-- a1:sayHello()   -- a1.sayHello
-- a2:sayHello()   -- a2.sayHello


print("\n")


-- (多)继承，设定能让子类的调用穿梭于自己和父类们的属性和方法中；
-- 在oo.class是就已经根据（继承的类）supers 设定好了__index表；
local B = oo.class(A)
function B:sayHello() -- 覆盖
    print(self.name..".sayHello B")
end

local b1 = B:new(nil, nil, "b1")
local b2 = B:new(20, 20, "b2")
print(b1.x, b1.y)
print(b2.x, b2.y)
b1:sayHello()
b2:sayHello()



-- 多态，态与继承、方法重写密切相关





-- 需要搞清楚继承和多态的区别，它们的内部实现有何不同？ 继承是否为多态的前置条件？






















return A
