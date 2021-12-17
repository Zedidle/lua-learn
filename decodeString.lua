#!/usr/local/bin/lua

local function printTable(t, level)
    for k,v in pairs(t) do
        if(type(v) == "table") then
            printTable(v, level+10)
        else
            local space = ""
            for i=1, level do
                space = space.." "
            end
            print(space, k, v)
        end
    end
end




-- 先尝试构造最简单的, 没有空格
local simpleS = "{s010autosupply=10,s005reiki=1500}"
local simpleS2 = "{s010autosupply=10,s005reiki=1500,101={s008lordList={},s006skills={},s006wearid=0,s005level=1}}"
S = "{s010autosupply=1,s005reiki=1500,s006wearid=104,s004list={104={s008lordList={},s006skills={},s006wearid=0,s005level=1},101={s008lordList={},s006skills={},s006wearid=0,s005level=1},102={s008lordList={},s006skills={},s006wearid=102,s005level=1},103={s008lordList={},s006skills={},s006wearid=103,s005level=1}}}"

local sLen = 3

-- print(math.min(1,10,0.2))

local testTable = {}
local testSubTable = {}
testTable["AA"] = testSubTable
-- print(testTable)


-- 匹配N个数字
-- str = "10131dsg"
-- p = string.match(str, "%d+")
-- print(p, #p)




function DecodeSimple(simpleS)
    local R = {}
    local bracketNum = 0
    local index = 1
    local strLen = #simpleS
    local bJudge = false
    local curchar = ""
    -- print(index, strLen)
    while (index <= strLen)
    do
        local curchar = string.sub(simpleS, index, index)
        if (curchar == "}") then
            index = index + 1
        elseif(bJudge == true) then
            if (curchar == "s") then -- 如果是字符串作为属性名
                local strNum = string.sub(simpleS, index+1, index + sLen)
                local n = tonumber(strNum)
                -- print("cur==s:", strNum, n)
                index = index + sLen
                local propName = string.sub(simpleS, index+1, index + n)
                -- print("propName:", propName)
                index = index + n + 1 -- 由于必然有=接着，因此还要+1
                local followSubstr1 = string.sub(simpleS, index+1)
                -- print("followSubstr1:", followSubstr1)
                -- 查找=的后续子串的 , 或 } 作为取值的终止
                local stopIndex = string.find(followSubstr1, string.match(followSubstr1, "[,}]") , 1) 
                local followValue = string.sub(followSubstr1, 1, stopIndex-1)
                -- print("stopIndex:", stopIndex)
                -- print("followValue:", followValue)
                R[propName] = followValue
                index = index + stopIndex
                bJudge = true
            else
                -- 判断后续获得的第一个 数字串
                local followSubstr2 = string.sub(simpleS, index)
                local fProp = string.match(followSubstr2, "%d+")
                R[fProp] = DecodeSimple(string.sub(simpleS, index + #fProp))
            end
        else
            bJudge = false
            if(curchar == "{") then
                bracketNum = bracketNum + 1
                bJudge = true
            elseif(curchar == ",") then
                bJudge = true
            elseif(curchar == "}") then
                -- 这种情况暂不考虑太复杂
                bracketNum = bracketNum - 1         
            end
        end
        index = index + 1
        print("")
    end
    -- print(bracketNum)
    return R
end

-- R = DecodeSimple(simpleS)
R1 = DecodeSimple(simpleS2)
-- R2 = DecodeSimple(S)
-- printTable(R, 1)
printTable(R1, 1)
-- printTable(R2, 1)




















-- 字符串找整数的方法
-- s = "Deadline is 30/05/1999, firm"
-- date = "%d%d/%d%d/%d%d%d%d"
-- print(string.sub(s, string.find(s, date)))    --> 30/05/1999

-- 字符串转整数
-- print(tonumber("010210"))


function Decode(str)
    local R = {}
    local innerStrLen = 0
    local bracketStack = {}

    -- i = 0
    -- while(i < 100)
    -- do
    --     print(i, #bracketRecord)
    --     bracketRecord[#bracketRecord + 1] = i
    --     i = i + 1
    -- end
    
    return R
end


-- Decode(S)

-- list[104] = {
--     lordList
-- } 



function printTable(T)
    

end