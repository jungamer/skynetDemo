local HubService = require "HubService.Interface"
local skynet = require "skynet"

function init()
	skynet.error("MasterService start")
    HubService.start()
end

function exit(...)
	skynet.error("MasterService exit")
    HubService.close()
end
