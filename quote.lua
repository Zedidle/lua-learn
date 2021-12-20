
-- 若果用table的话，赋值之后，它们共享同一个域；
-- 意味着local会申请一个地址和内存；

local a = {
    a = 1,
    b = 2
}
local b = a
local c = a

print(a.a, b.a, c.a, a.b, b.b, c.b)
a.a = 10
print(a.a, b.a, c.a, a.b, b.b, c.b)
print(a.a, b.a, c.a, a.b, b.b, c.b)