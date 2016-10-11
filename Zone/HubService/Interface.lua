local snax = require "snax"

local Interface = {}
local service
function Interface.start(...)
    if service then
        return
    end
    service = snax.uniqueservice("HubService/Service", ...)
end

function Interface.getHandle(...)
    return service
end

return Interface
