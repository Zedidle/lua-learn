local T = {}

local string = "zfc.odd"

T[string] = function(something)
    print("hello",something)    
end

T["zfc.odd"]("world")
-- T.zfc.odd("world")  -- 不行