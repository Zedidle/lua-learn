local UObject = function(...)
    local private = {}
    local public = {}
    local obj = {}
    obj.ctor = nil
    obj.supers = ...
    obj.new = function(o, subclass)
        subclass = subclass or {}
        setmetatable(subclass, {
            __index = o
        })
        return subclass
    end



    setmetatable(obj, {
        __index = function(o, k)
            -- print("UObject.__index:", k)
            if k == "private" then
                print(debug.traceback("类外部不能读取私有域:")) -- 要获取外部环境
                return ""
            end
            if private[k] then
                print("private key")
                if type(private[k]) == "function" then
                    print(debug.traceback("类外部不能调用私有函数："))
                else
                    print(debug.traceback("类外部不能读取私有数据："))
                end
                return ""
            end
            return public[k]
        end,
        
        __newindex = function(o, k, v)
            -- print("UObject.__newindex")
            if private[k] then
                print(debug.traceback("已经存在对应键值的私有函数或数据："))
                return ""
            end
            public[k] = v
        end,

        __ctor = function(...)
            -- print("UObject.__ctor")
            -- 构造新的
            -- for _, super in pairs(obj.supers) do
            --     if super.ctor then
            --         super.ctor()
            --     end
            -- end
        end,

        __len = function(o) -- 对应#.. 返回长度
            return #private + #public --为什么返回0
        end
    })
    obj.SetPrivate = function(o, k, v)
        -- print("obj.Private k, v:", k, v)
        -- print("type(k), type(v):", type(k), type(v))
        if not private[k] then
            private[k] = v
        end
    end
    obj.GetPrivate = function(o, k)
        return private[k]
    end

    return obj
end

return UObject








