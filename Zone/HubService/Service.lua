--local skynet = require "skynet"
local socket = require "socket"
local proxy = require "socket_proxy"
local log = require "log"
local AgentManagerService = require "AgentManagerService.Interface"
local AuthService
local ZoneConfig = require "config.ZoneConfig"

local data = {socket = {}}

local function new_socket(fd, addr)
	data.socket[fd] = "[AUTH]"
	proxy.subscribe(fd)
	local userid =  AuthService.req.auth(fd)
	if userid then
		data.socket[fd] = userid
		AgentManagerService.req.assign(fd, userid)
	else
		log("Auth faild %s", addr)
	end
end

function init()
    AuthService = require "AuthService.Interface"
	log("HubService start")
	assert(data.fd == nil, "Already open")
	data.fd = socket.listen(ZoneConfig.HubConfig.ip, ZoneConfig.HubConfig.port)
	log("Hub Listen %s:%d", ZoneConfig.HubConfig.ip, ZoneConfig.HubConfig.port)
	data.ip = ZoneConfig.HubConfig.ip
	data.port = ZoneConfig.HubConfig.port
	socket.start(data.fd, new_socket)
end


function exit()
    log("Close %s:%d", data.ip, data.port)
    socket.close(data.fd)
    data.ip = nil
    data.port = nil
end
