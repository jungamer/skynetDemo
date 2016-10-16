local skynet = require "skynet"
local client
--local log = require "log"
local User = require "AgentService.User"
local MsgParse = require "AgentService.MsgParse"

local user 
function init( ... )
    client = require "client"
	user = User.new()
	MsgParse = client.handler(MsgParse)
	MsgParse.init(user)
	client.init()
end

local function close_client(fd)
	client.close(fd)
	user:dealClientClose(fd)
	skynet.error("fd=%d is gone. error = %s", fd, error)
end

local function new_client(newClient)
	local ok, err = pcall(client.dispatch, newClient)
    if not ok then
        skynet.error(err)
    end
	close_client(newClient.fd)
end

function response.assign(fd, userid)
    local newClient = user:checkNewClient(fd, userid)
	if newClient then
		skynet.fork(new_client, newClient)
		return true
	end
	return false
end

function exit(...)
	User.final()
end
