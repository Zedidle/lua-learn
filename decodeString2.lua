S = "{s010autosupply=1,s005reiki=1500,s006wearid=104,s004list={104={s008lordList={},s006skills={},s006wearid=0,s005level=1},101={s008lordList={},s006skills={},s006wearid=0,s005level=1},102={s008lordList={},s006skills={},s006wearid=102,s005level=1},103={s008lordList={},s006skills={},s006wearid=103,s005level=1}}}"

-- print("2333333333333")

local function printTable(t, level)
    local space = ""
    for i=1, level do
        space = space.." "
    end
    for k,v in pairs(t) do
        if(type(v) == "table") then
            print(space..k..":")
            printTable(v, level+10)
        else
            print(space, k, v)
        end
    end
end


-- 获取 = 左边的第一个碰到 { 或 , 的下标，用来确定属性名前提
local function getEqualLeftIndex(str, equalIndex)
    local index = equalIndex-1
    while(index > 0) do
        -- print("getEqualLeftIndex", index)
        local cur = string.sub(str, index, index)
        if(cur == "{" or cur == ",") then
            return index
        end
        index = index - 1
    end
    return 0
end

-- 从字符串获取属性名的方法, 必须从=左边到 { 或 , 之间的值判断
local function getPropNameFromString(str)
    local sLen = 3
    local start = string.sub(str, 1, 1)
    if(start == "s") then
        return string.sub(str, sLen+2)
    else -- 暂时默认为长度为3的数字串
        return str
    end
end


-- 获取 = 右边的第一个碰到 } 或 , 的下标，前提是已经判断=的下一个位置不是{，能够直接取值而不是table
local function getEqualRightIndex(str, equalIndex)
    local index = equalIndex+1
    while(index <= #str) do
        -- print("getEqualRightIndex", index)
        local cur = string.sub(str, index, index)
        if(cur == "," or cur == "}") then
            return index
        end
        index = index + 1
    end
    return 0
end



function DecodeString(S)
    local length = #S - 1
    local R = {}
    local i = 2
    while(i < length)do
        -- print("DecodeString")
        local cur = string.sub(S, i, i)
        -- 确定属性，需要找 = 
        if(cur == "=") then
            -- 确定直接值
            local leftIndex = getEqualLeftIndex(S, i)
            -- print(leftIndex, string.sub(S, leftIndex, i))
            local prop = getPropNameFromString(string.sub(S, leftIndex+1, i-1))
            -- print("prop:",prop)

            -- 判断其直接右方是否为{，从而确定是否进入table递归
            local curRight = string.sub(S, i+1, i+1)
            if(curRight ~= "{") then
                local rightIndex = getEqualRightIndex(S, i)
                -- print("rightIndex:", rightIndex)
                -- 获取直接值
                local directValue = string.sub(S, i+1, rightIndex-1)
                -- print("directValue:",directValue)
                R[prop] = directValue  -- 看看如果是纯数字串，是否需要转

                -- 确定i的跳跃距离
                i = rightIndex + 1
            else
                local bracketNum = 1
                local bracketIndex = i+2
                -- print("bracketIndex:", bracketIndex)
                while(bracketIndex <= #S) do
                    local b = string.sub(S, bracketIndex, bracketIndex)
                    if(b == "{") then
                        bracketNum = bracketNum + 1
                    elseif(b == "}") then
                        bracketNum = bracketNum - 1
                        if(bracketNum == 0) then
                            break
                        end
                    end
                    bracketIndex = bracketIndex + 1
                end

                local substr = string.sub(S, i+1, bracketIndex)
                -- print("substr:", substr)
                -- 确定需要遍历递归的值
                R[prop] = DecodeString(substr) 

                -- 确定i的跳跃距离，需要记录括号栈
                i = bracketIndex + 1
            end
        else
            i = i + 1
        end
    end
    return R
end


local R = DecodeString(S)


printTable(R, 10)