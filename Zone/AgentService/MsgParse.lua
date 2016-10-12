
local skynet = require "skynet"
local client = require "client"

local MsgParse = {}
local user
local userData 
function MsgParse.init(owner)
	user = owner
	userData = owner.userData
end

function MsgParse:ping()
	assert(self.login)
	skynet.error("ping")
end

function MsgParse:login()
	assert(not self.login)
	if userData.fd then
		skynet.error("login fail %s fd=%d", userData.userid, self.fd)
		return { ok = false }
	end
	userData.fd = self.fd
	self.login = true
	skynet.error("login succ %s fd=%d", userData.userid, self.fd)
	client.push(self, "push", { text = "welcome" })	-- push message to client
	return { ok = true }
end

return MsgParse