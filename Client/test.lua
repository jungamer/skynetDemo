local a = {["cc"] = 10}
a.__index = a
local b = {}
setmetatable(b, a)
print(b.cc)
