local _class = {} -- 记录所有的class的虚表
local _super = {} -- 父类追踪树，热更有用到
local api = {}
local _weaktb = {}
local _weakcnt = 0
setmetatable(_weaktb, {__mode = "k"})

function api.show()
	local cnt = 0
	for tb, __ in pairs(_weaktb) do
		cnt = cnt + 1
	end
	print("class obj len:", cnt)
	print("class max cnt:", _weakcnt)
end


--[[ OOP
	
	面向对象程序设计基于三个基本的概念：数据抽象、继承、动态绑定。通过使用数据抽象，可以将类的接口和实现分离；
	使用继承，可以定义类似的类型并对其相似关系建模；使用动态绑定，可以在一定程度上忽略相似类型的区别，而以统一的方式使用它们。

	只有深刻理解封装、继承、多态的含义，才能明白OOP内部实现；


	__index 的用法：
	当你通过键来访问 table 的时候，如果这个键没有值，那么Lua就会寻找该table的metatable（假定有metatable）中的__index 键。
		1. 如果__index包含一个表格，Lua会在表格中查找相应的键，逐层往上。
		2. 如果__index包含一个函数的话，Lua就会调用那个函数，table和键会作为参数传递给函数。

]]
function api.class(...) -- 类的基础模板
	local class_type = {} -- 类内维持各种操作的域
	class_type.ctor = false -- 构造函数，需要子类自己去定义
	class_type.dtor = false -- 析构函数，需要子类自己去定义
	class_type.super = {...}
	class_type.new = function(...)
		local obj = {}
		obj.TYPE = class_type
		do	-- 如果ctor == false，不做事；不过一般子类都会定义
			-- 多态的实现基础，
			local create
			create = function(c, ...) -- 深度优先调用父类的构造函数
				for _, super in pairs(c.super) do
					if super then
						create(super, ...)
					end
				end
				if c.ctor then
					c.ctor(obj, ...)
				end
			end
			create(class_type, ...)
		end
		-- 这个做法导致能取值
		setmetatable(
			obj,
			{
				__index = _class[class_type] -- 可以直接拿该虚表的值，也许这个虚表能读取表中的任何字段，包括函数
			}
		)
		-- 这个weak有什么用？是不是拿来管理释放内存？
		_weakcnt = _weakcnt + 1
		_weaktb[obj] = _weakcnt
		return obj
	end
	class_type.release = function(obj) -- 释放资源
		if obj.dtor then
			obj.dtor(obj)
		end
		local release
		release = function(obj, supers)
			for _, super in pairs(supers) do
				if super.dtor then
					super.dtor(obj)
				end
				release(obj, super.super)
			end
		end
		release(obj, class_type.super) -- obj对象自己，
		obj.isRelease = true
	end


    -- 多态与虚表
	local vtbl = {}
	_class[class_type] = vtbl -- 记录该类的虚表，这里的虚表和C++的虚函数表并不同，只是为了记录它所有父类的键
	setmetatable(
		class_type, -- 返回的类要设置虚表
		{
			__newindex = function(t, k, v)
				vtbl[k] = v
			end,
			__index = vtbl
		}
	)
	if #class_type.super > 0 then -- super在创建这个类就赋值了
		_super[vtbl] = {} -- 虚表继承链
		setmetatable(
			vtbl,
			{
				__index = function(t, k)
					print("__index super: ", k)
					for _, super in pairs(class_type.super) do -- 遍历每一个父类
						-- 判断是否已经存在该父类，且该父类有这个键；如果正确使用都会通过；
						-- 设定的地方是：_class[class_type] = vtbl，每个类的虚表都被记录
						-- 从设定看来 vtbl并不存在自己的键，
						if _class[super][k] then
							local ret = _class[super][k]
							vtbl[k] = ret -- 让 虚表该键的值 为 父类该键的值，优化掉层层遍历查找父类的键的操作
							-- 为什么table可以作为一个键？
								-- 虽然诡异但应该可以；传的是它们的内存地址
							-- 初始化父类追踪树，意即：如果虚表的父类没作记录的话，赋值为空表；
							-- 然后设虚表的父类对应该键的值 为 父类该键的值
							_super[vtbl][super] = _super[vtbl][super] or {}  
							_super[vtbl][super][k] = ret -- 虚键覆盖
							return ret
						end
					end
				end
			}
		)
	end

	-- 突然有种突破次元壁的感觉！

	return class_type
end

return api