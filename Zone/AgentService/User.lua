local skynet = require "skynet"

local User = {__index = User}
setmetatable(User, client)

local userData = {}
function User.new()
	User.userData = userData
	return User
end

function User:checkNewClient(fd, userid)
	if userData.exit then
		return false
	end
	if userData.userid == nil then
		userData.userid = userid
	end
	assert(userData.userid == userid)
	return true
end

function User:dealClientClose(fd)
	if userData.fd == fd then
		userData.fd = nil
		skynet.sleep(1000)	-- exit after 10s
		if userData.fd == nil then
			-- double check
			if not userData.exit then
				userData.exit = true	-- mark exit
				skynet.call(service.manager, "lua", "exit", userData.userid)	-- report exit
				skynet.error("user %s afk", userData.userid)
				skynet.exit()
			end
		end
	end
end

return User