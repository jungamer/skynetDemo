local snax = require "snax"

local Interface = {}
local serviceList = {}
--TODO 可以启动多份做负载均衡
function Interface.start(...)
    local service = snax.newservice("AuthService/Service", ...)
    table.insert(serviceList, service)
end

function Interface.getHandle(...)
    return service
end

return Interface
