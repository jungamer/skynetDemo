local Interface = {}

local service
function Interface.start(...)
	service = snax.uniqueservice("AgentManagerService/Service", ...)
	return service
end

function Interface.getRpcObj( ... )
	return service
end

return Interface