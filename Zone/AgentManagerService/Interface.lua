local service
local Interface = {}
function Interface.start(...)
	service = snax.uniqueservice("AgentManagerService/Service", ...)
	service.__index = service
	setmetatable(Interface, service)
end

return Interface
