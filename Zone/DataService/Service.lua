local skynet = require "skynet"
local service = require "service"
local AgentService = require "AgentService.Interface"
local nMysql = require "nMysql"
local ZoneConfig = require "config.ZoneConfig"
--local log = require "log"

local dbConnection
function init(...)
	dbConnection = nMysql.connect(ZoneConfig.mysqlConfig)
end

function exit(...)
	dbConnection:close()
end

function response.loadUserData(userId)
	local data = dbConnection:select("USER_BASE", {"ACCOUNT_NAME", "CHAR_ID", "LEVEL", "MONEY"})
	return data	
end

function response.saveUserData(userId)
end
