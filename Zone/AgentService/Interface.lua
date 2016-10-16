local snax = require "snax"
local service
local Interface = {}
function Interface.start(...)
	service = snax.newservice("AgentService/Service", ...)
	service.__index = service
	setmetatable(Interface, service)
end

return Interface
