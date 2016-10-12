local serviceList = {}
function Interface.start(...)
	local service = snax.newservice("AgentService/Service", ...)
	table.insert(serviceList, service)
end

function Interface.getRpcObj( ... )
	return serviceList[1]
end

return Interface