Account = {balance = 100}
function Account.withdraw(v)
    Account.balance = Account.balance - v
end

Account.withdraw(30)
print(Account.balance)

local a = Account
print(a.balance)
a.withdraw(20)
print(a.balance)
-- Account = nil  -- 这违反了对象独立的生命周期
-- a.withdraw(10)


-- 一个灵活的方法是：定义方法的时候带上一个额外的参数，来表示方法作用的对象； self 或者 this
function Account.withdraw(self, v)   -- 通过 . 来定义方法
    self.balance = self.balance - v
end

local a1 = Account
a1.withdraw(a1, 10)
print(a1.balance)
Account = nil -- 前面定义了 self 之后就可以了
a1.withdraw(a1, 10)
print(a1.balance)

a1:withdraw(10) 
print(a1.balance) -- 可以通过 . 定义，  : 调用



Account = {balance = 100}
-- : 调用的方法会自动让 self 指代对应的作用域;  也可以通过 ： 定义，  . 调用
function Account:withdraw(v)  -- 通过 : 来定义方法，可以省略 self 
    self.balance = self.balance - v
end
a1.withdraw(a1, 5)
print(a1.balance)



local a2 = {balance = 0, withdraw = Account.withdraw}
a2.withdraw(a2, 260)
print(a2.balance)


function Account:deposit(v)
    self.balance = self.balance + v
end

-- 也就是说，函数与对象之前并没有强制绑定，处于一种游离状态...每个函数通过 . 调用的话，可以第一个参数选取一个对象作为作用域
Account.deposit(a2, 100)
print(a2.balance)





-- 重新定义
Account = {
    balance = 0,
    withdraw = function(self, v)
        self.balance = self.balance - v
    end
}

function Account:deposit(v)
    self.balance = self.balance + v
end



-- 类，很容易实现prototypes. 更明确的来说，如果我们有两个对象 a 和 b，我们像让b作为a的prototype，只需要：
-- setmetatable(a, {__index = b})
-- 对象 a 调用任何不存在的成员都会到对象 b 中查找。术语上，可以将b看做类，a看做对象；
function Account:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

a = Account:new{balance = 0}
a:deposit(100.00)

getmetatable(a).__index.deposit(a, 100.00)
Account.deposit(a, 100.00)

local b = Account:new()
print(b.balance) --> 0


-- 继承

