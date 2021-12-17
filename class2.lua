local _class = {}
local _super = {}
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

function api.class(...) -- 类的基础模板
	local class_type = {}
    -- class_type.private = {}
	class_type.ctor = false -- 构造函数，需要子类自己去定义
	class_type.super = {...}
	class_type.new = function(...)
		local obj = {}
        print(...)
		obj.TYPE = class_type
		do -- 如果ctor == false，不做事；不过一般子类都会定义
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
		setmetatable(
			obj,
			{
				__index = _class[class_type]
			}
		)
		_weakcnt = _weakcnt + 1
		_weaktb[obj] = _weakcnt
		return obj
	end
	class_type.release = function(obj)
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
		release(obj, class_type.super)
		obj.isRelease = true
	end
	local vtbl = {}
	_class[class_type] = vtbl

	setmetatable(
		class_type,
		{
			__newindex = function(t, k, v)
				vtbl[k] = v
			end,
			__index = vtbl
		}
	)

	if #class_type.super > 0 then
		_super[vtbl] = {}
		setmetatable(
			vtbl,
			{
				__index = function(t, k)
					for _, super in pairs(class_type.super) do
						if _class[super][k] then
							local ret = _class[super][k]
							vtbl[k] = ret
							_super[vtbl][super] = _super[vtbl][super] or {}
							_super[vtbl][super][k] = ret
							return ret
						end
					end
				end
			}
		)
	end

	return class_type
end

function api.hotfix_super(old_t, vtbl_o)
	for k, v in pairs(_class) do
		local function isContain(list, value)
			for _, super in pairs(list) do
				if super == value then
					return true
				end
			end
			return false
		end
		if isContain(k.super, old_t) then
			for super_k, super_v in pairs(vtbl_o) do
				if _super[v] ~= nil and _super[v][old_t] ~= nil and _super[v][old_t][super_k] ~= nil then
					v[super_k] = super_v
				end
			end

			api.hotfix_super(k, v)
		end
	end
end

function api.hotfix(old_obj, new_obj)
	if type(old_obj) ~= "table" or type(new_obj) ~= "table" then
		return
	end
	local vtbl_o = _class[old_obj]
	local vtbl_n = _class[new_obj]
	if vtbl_o ~= nil and vtbl_n ~= nil then
		for k, v in pairs(vtbl_n) do
			vtbl_o[k] = v
		end

		for k, v in pairs(new_obj) do
			if k ~= "new" and k ~= "super" then
				old_obj[k] = v
			end
		end
		api.hotfix_super(old_obj, vtbl_o)
	else
		for k, v in pairs(new_obj) do
			old_obj[k] = v
		end
	end

	_class[new_obj] = nil
end

function api.require_handler(handlers)
	for _, v in ipairs(handlers) do
		package.loaded[v] = nil
		require(v)
	end
end

function api.require_module(modules)
	for _, v in ipairs(modules) do
		local new_module = nil
		local old_module = package.loaded[v]
		if old_module == nil then
			new_module = require(v)
		else
			package.loaded[v] = nil
			local ret, new_module = pcall(require, v)
			if ret and new_module then
				api.hotfix(old_module, new_module)
			else
				print("error exist in file:", v, ret, new_module)
			end
			package.loaded[v] = old_module
		end
		old_module = nil
		new_module = nil
	end
end

return api
