local skynet = require "skynet"
local service = require "service"
local client = require "client"
local log = require "log"
local User = require "AgentService.User"
local MsgParse = require "AgentService.MsgParse"
local SprotoDefine = require "Common.SprotoDefine"

--多个连接共用一份userData 
local userData = {}
local user 
function init( ... )
	user = User.new()
	MsgParse = client.handler(MsgParse)
	MsgParse.init(user)
	client.init()
end

local function new_client(fd)
	local ok, error = pcall(client.dispatch, { fd = fd })
	client.close(fd)
	user:dealClientClose(fd)
	skynet.error("fd=%d is gone. error = %s", fd, error)
end

function response.assign(fd, userid)
	if user:checkNewClient(fd, userid) then
		skynet.fork(new_client, fd)
		return true
	end
	return false
end

function exit(...)
	User.final()
end
