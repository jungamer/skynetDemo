local snax = require "snax"
local service
local Interface = {}
setmetatable(Interface, Interface)
Interface.__index = function(k, v)
    service = snax.queryservice("DataService/Service")
	service.__index = service
	setmetatable(Interface, service)
    return service[v]
end

function Interface.start(...)
	service = snax.uniqueservice("DataService/Service", ...)
	service.__index = service
	setmetatable(Interface, service)
    return Interface
end

return Interface
