local client = require "service.client"
local skynet = require "skynet"
local DataService = require "DataService.Interface"

local handler

local SUCC = { ok = true }
local FAIL = { ok = false }

function init( ... )
	handler = client.handler()
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
	skynet.error("signin accountName = %s", args.accountName)
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
			if userInfo.userid == args.userid then
				c.exit = true
				return SUCC
			end
		end

	end
	return FAIL
end

function handler.ping()
	skynet.error("ping")
end
