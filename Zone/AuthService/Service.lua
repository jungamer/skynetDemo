local client = require "client"
local skynet = require "skynet"
local DataService = require "DataService.Interface"
local log = require "log"

local handler = {}
handler.__index = handler

local SUCC = { ok = true }
local FAIL = { ok = false }

function init( ... )
	client.init()
    local clientHandle = client.handler()
    setmetatable(clientHandle, handler)
end

function exit( ... )
end

function response.auth(fd)
	local c = client.dispatch({fd = fd})
	return c.userid
end

function handler.signup(c, args)
	local ok, userid = DataService.req.checkSignUp(args.accountName)
	if ok then
		return {ok = true, userid = userid}
	else
		return FAIL
	end
end

function handler.signin(c, args)
	log("signin accountName = %s", args.accountName)
	local ok, userInfoList = DataService.req.checkSignin(args.accountName)
	if ok then
		c.userInfoList = userInfoList
		return {ok = true, userInfoList = userInfoList}
	else
		return FAIL
	end
end

function handler.selectUid(c, args)
	if c.userInfoList then
		for _, userInfo in pairs(c.userInfoList) do
			if tostring(userInfo.userid) == tostring(args.userid) then
                c.userid = tostring(userInfo.userid)
				c.client_exit = true
				return SUCC
			end
		end

	end
	return FAIL
end

function handler.ping()
	skynet.error("ping")
end
