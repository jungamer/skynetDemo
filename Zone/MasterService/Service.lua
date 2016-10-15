local DataService = require "DataService.Interface"
local AgentManagerService = require "AgentManagerService.Interface"
local AuthService = require "AuthService.Interface"
local HubService = require "HubService.Interface"

local skynet = require "skynet"

function init()
	DataService.start()
	AgentManagerService.start()
	AuthService.start()
	HubService.start()
	skynet.error("MasterService start")
end

function exit(...)
    	HubService.close()
	AuthService.close()
	AgentManagerService.close()
	DataService.close()
	skynet.error("MasterService exit")
end
