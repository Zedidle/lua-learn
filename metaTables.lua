Set = {}
Set.mt = {}

function Set.new(t)
    local set = {}
    setmetatable(set, Set.mt)
    for _, l in ipairs(t) do set[l] = true end
    return set
end

function Set.union(a, b)
    if getmetatable(a) ~= Set.mt or getmetatable(b) ~= Set.mt then
        error("attempt to 'add' a set with a non-set value", 2)
    end

    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end
Set.mt.__add = Set.union

function Set.intersection(a, b)
    local res = Set.new{}
    for k in pairs(a) do 
        res[k] = b[k]
    end
    return res
end
Set.mt.__mul = Set.intersection


function Set.tostring(set)
    local s = "{"
    local sep = ""
    for e in pairs(set) do
        s = s .. sep .. e
        sep = ", "
    end
    return s .. "}"
end
Set.mt.__tostring = Set.tostring

function Set.print(s)
    print(Set.tostring(s))
end


local s1 = Set.new{10, 20, 30, 50}
local s2 = Set.new{30, 1}
print(getmetatable(s1))
print(getmetatable(s2))

local s3 = s1 + s2
print(s3)

-- Metamethods
print("windows...")

Window = {}
Window.prototype = {x=0, y=0, width=100, height=100, }
Window.mt = {}

function Window.new(o)
    setmetatable(o, Window.mt)
    return o
end

Window.mt.__index = function(table, key)
    return Window.prototype[key]
end
-- Window.mt.__index = Window.prototype

local w = Window.new({x=10, y=20})
print(w.width) --> 100



print("read-only table")
local function readOnly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(t, k, v)
            error("attempt to update read-only table", 2)
        end
    }

    setmetatable(proxy, mt)
    return proxy
end

local days = readOnly{"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

print(days[1])
days[2] = "Noday"



