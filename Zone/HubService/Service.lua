local skynet = require "skynet"
local socket = require "socket"
local proxy = require "socket_proxy"
--local log = require "log"
local service = require "service"
function init()
	skynet.error("HubService start")
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
