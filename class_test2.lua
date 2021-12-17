local oo2 = require "class2"
local testobj2 = oo2.class()
function testobj2:ctor(x, y)
    print("testobj:ctor")
    self.x = x
    self.y = y
end
testobj2:new(10, 10)
print(testobj2.x, testobj2.y)