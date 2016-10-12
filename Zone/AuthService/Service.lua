local client = require "client"
local skynet = require "skynet"
local handler = {__index = handler}

setmetatable(handler, client)

local SUCC = { ok = true }
local FAIL = { ok = false }

local users = {}
function init( ... )
	handler.init("proto")
end

function exit( ... )
	handler.close("proto")
end

function response.auth(fd)
	handler:dispatch({fd = fd})
end

function handler.signup(c, args)
	skynet.error("signup userid = %s", args.userid)
	if users[args.userid] then
		return FAIL
	else
		users[args.userid] = true
		return SUCC
	end
end

function handler.signin(c, args)
	skynet.error("signin userid = %s", args.userid)
	if users[args.userid] then
		c.userid = args.userid
		c.exit = true
		return SUCC
	else
		return FAIL
	end
end

function handler.ping()
	skynet.error("ping")
end

