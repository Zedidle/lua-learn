local co = coroutine.create(function() 
    print("hi")
end)

print(co)
print(coroutine.status(co))  --> suspended
coroutine.resume(co)         --> hi
print(coroutine.status(co))  -- dead


local co2 = coroutine.create(function()
    for i=1,10 do
        print("co2", i)
        coroutine.yield()
    end
end)

coroutine.resume(co2)    --> co2  1
print(coroutine.status(co2))
while(coroutine.status(co2) ~= "dead")do
    coroutine.resume(co2)
end
print(coroutine.status(co2))

print("\n")

local co3 = coroutine.create(function(a, b, c)
    print("co3", a, b, c)
end)
coroutine.resume(co3, 1, 2, 3)


print("\n")



local co4 = coroutine.create(function (a, b)
    coroutine.yield(a+b, a-b)
end)
print(coroutine.resume(co4, 20, 10))  --> true  30  10



local co5 = coroutine.create(function()
    print("co5", coroutine.yield())
end)
coroutine.resume(co5) 
coroutine.resume(co5, 4, 5)     --> co 4 5


local co6 = coroutine.create(function ()
    return 6, 7
end)
print(coroutine.resume(co6))

local co7 = coroutine.create(function ()
end)
print(coroutine.resume(co7))
