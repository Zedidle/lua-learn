#!/usr/local/bin/lua

array = {"Google", "Runoob"}

for key,value in ipairs(array)
do
   print(key, value)
end



print("\n无状态的迭代器")
function square(iteratorMaxCount,currentNumber)
   if currentNumber<iteratorMaxCount
   then
      currentNumber = currentNumber+1
   return currentNumber, currentNumber*currentNumber
   end
end

for i,n in square,3,0
do
   print(i,n)
end



print("\n多状态的迭代器")
array = {"Google", "Runoob", "zed"}

function elementIterator (collection)
   local index = 0
   local count = #collection
   -- 闭包函数
   return function ()
      index = index + 1
	  print("curindex:", index)
      if index <= count then
         --  返回迭代器的当前元素
         return collection[index]
      end
   end
end

for element in elementIterator(array)
do
   print(element)
end
