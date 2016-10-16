local snax = require "snax"
local service
local Interface = {}
function Interface.start(...)
	service = snax.uniqueservice("AuthService/Service", ...)
	service.__index = service
	setmetatable(Interface, service)
end

return Interface
