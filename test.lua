-- function printTable(t, level)
--     local space = ""
--     for _=1, level do
--         space = space.." "
--     end
--     for k,v in pairs(t) do
--         if(type(v) == "table") then
--             print(space..k..":")
--             printTable(v, level+10)
--         else
--             print(space, k, v)
--         end
--     end
-- end






local all = {a="aaa", b="bbb"}
local b = all.b
b = 100
print(all.b)



local outDeleteList = {}
print(outDeleteList[100])

local function changeList(outerList)
    outDeleteList[100] = 100
end

changeList(outDeleteList)
print(outDeleteList[100])



-- table 的 and 运算
local tableA = {a=11, aa=111, aaa=1111}
local tableB = {b=11, bb=111, bbb=1111}
local tableC = tableA and tableB
-- printTable(tableC)