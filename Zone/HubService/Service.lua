local skynet = require "skynet"
local socket = require "socket"
local proxy = require "socket_proxy"
local log = require "log"
local AgentManagerService = require "AgentManagerService.Interface"
local AuthService = require "AuthService.Interface"

local data = {socket = {}}
function init()
	skynet.error("HubService start")
end

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
	proxy.close(fd)
	data.socket[fd] = nil
end

function accept.open(ip, port)
	skynet.error("Listen %s:%d", ip, port)
	assert(data.fd == nil, "Already open")
	data.fd = socket.listen(ip, port)
	data.ip = ip
	data.port = port
	socket.start(data.fd, new_socket)
end

function accept.close()
end

function exit()
	skynet.error("HubService exit")
end
