#!/usr/local/bin/lua

print("\nLua 模块与包")


-- module 模块为上文提到到 module.lua
-- 别名变量 m
local m = require("module")

print(m.constant)

m.func3()





