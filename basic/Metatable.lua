#!/usr/local/bin/lua

--元表的主要两个作用：
	--1.提供类似于C++的继承；
	--2.提供运算符重载操作；







--当 Lua 试图对两个表进行相加时，先检查两者之一是否有元表，之后检查是否有一个叫 __add 的字段，若找到，则调用对应的值。 __add 等即时字段，其对应的值（往往是一个函数或是 table）就是"元方法"。

--有两个很重要的函数来处理元表：
--setmetatable(table,metatable): 对指定 table 设置元表(metatable)，如果元表(metatable)中存在 __metatable 键值，setmetatable 会失败。
--getmetatable(table): 返回对象的元表(metatable)。


--1__index 元方法
mytable = setmetatable({key1 = "value1"}, {
  __index = function(mytable, key)
    if key == "key2" then
      return "metatablevalue"
    else
      return nil
    end
  end
})
print(mytable.key1,mytable.key2)

-- Same as 1 and 2
-- 2
mytable = setmetatable({key1 = "value1"}, { __index = { key2 = "metatablevalue" } })
print(mytable.key1,mytable.key2)




--3 __newindex 元方法
mymetatable = {}
mytable = setmetatable({key1 = "value1"}, { __newindex = mymetatable })

print(mytable.key1)

mytable.newkey = "新值1"
mytable.newkey2 = "新值2"
print(mytable.newkey, mymetatable.newkey)
print(mytable.newkey2, mymetatable.newkey2)

mytable.key1 = "新值1"
print(mytable.key1, mymetatable.key1)





print("\n为表添加操作符")
--4 为表添加操作符 design operator for yourself
-- 计算表中最大值，table.maxn在Lua5.2以上版本中已无法使用
-- 自定义计算表中最大键值函数 table_maxn，即计算表的元素个数
function table_maxn(t)
    local mn = 0
    for k, v in pairs(t) do
        if mn < k then
            mn = k
        end
    end
    return mn
end


-- 两表相加操作
mytable = setmetatable({ 1, 2, 3 }, {
  __add = function(mytable, newtable)
    for i = 1, table_maxn(newtable) do
		table.insert(mytable, table_maxn(mytable)+1, newtable[i])
    end
    return mytable
  end
})

secondtable = {4,5,6,7}

mytable = mytable + secondtable
for k,v in ipairs(mytable) do
	print(k, v)
end





print("\n__call 元方法")
-- 计算表中最大值，table.maxn在Lua5.2以上版本中已无法使用
-- 自定义计算表中最大键值函数 table_maxn，即计算表的元素个数
function table_maxn(t)
    local mn = 0
    for k, v in pairs(t) do
        if mn < k then
            mn = k
        end
    end
    return mn
end

-- 定义元方法__call
-- Definitly, the first argument should be itself;
mytable = setmetatable({10}, {
  __call = function(mytable, newtable)
        sum = 0
        for i = 1, table_maxn(mytable) do
                sum = sum + mytable[i]
        end
    for i = 1, table_maxn(newtable) do
                sum = sum + newtable[i]
        end
        return sum
  end
})
newtable = {10,20,30}
print(mytable(newtable))




print("\n__tostring 元方法")
mytable = setmetatable({ 10, 20, 30 }, {
  __tostring = function(mytable)
    sum = 0
    for k, v in pairs(mytable) do
                sum = sum + v
        end
    return "表所有元素的和为 " .. sum
  end
})
print(mytable)




















