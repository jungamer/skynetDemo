local skynet = require "skynet"
local client = require "client"

local MsgParse = {}
local user
--MsgParse self表示每个连接里的数据
function MsgParse.init(owner)
	user = owner
end

function MsgParse:ping()
	assert(self.login)
	skynet.error("ping")
end

function MsgParse:login()
	assert(not self.login)
	if user.fd then
		skynet.error("login fail %s fd=%d", user.userid, user.fd)
		return { ok = false }
	end
	user.fd = self.fd
	self.login = true
	skynet.error("login succ %s fd=%d", user.userid, self.fd)
	client.push(self, "push", { text = "welcome" })	-- push message to client
	return { ok = true }
end

function MsgParse:logout()
	self.client_exit = true
	return { ok = true }
end

function MsgParse:requestUserData()
    user.bingHuoActivityManager:addScore(10)
	return user:sendUserData()
end

return MsgParse
