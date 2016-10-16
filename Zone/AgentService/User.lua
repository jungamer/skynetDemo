local skynet = require "skynet"
local MoneyManager = require "AgentService.MoneyManager"
local DataManager = require "AgentService.DataManager"
local BingHuoActivityManager = require "AgentService.BingHuoActivityManager"
local client = require "client"
local AgentManagerService = require "AgentManagerService.Interface"

--支持多个连接同时在线, 支持agent回收
local User = {
--	userid    	= nil,
--	fd	  	= nil,
--	_user_exiting  = nil,
	_online_fd_client = {},
}

function User.new()
	User.dataManager = DataManager.new(User)
	User.moneyManager = MoneyManager.new(User)
	User.bingHuoActivityManager = BingHuoActivityManager.new(User)
	return User
end

function User:dealNewClient()
	if not next(self._online_fd_client) then
		self.dataManager:init()
		self.moneyManager:init()
		self.bingHuoActivityManager:init()
	end
end

--TODO 优化，去掉for循环
function User:pushMsg(msgName, msg)
    for _, c in pairs(self._online_fd_client) do
        client.push(c, msgName, msg)
    end
end

function User:final()
	self.bingHuoActivityManager:final()
	self.moneyManager:final()
	self.dataManager:final()
	self.userid = nil
	self._user_exiting = nil
end

function User:checkNewClient(fd, userid)
	if self._user_exiting then
		skynet.error("正在退出状态中[", userid, "]")
		return false
	end
    local newClient = {fd = fd}
	if not self._online_fd_client[fd] then
		self._online_fd_client[fd] = newClient
	end
--	assert(self._online_fd_client[fd] == userid)
	return newClient
end

function User:dealClientClose(fd)
	client.close(fd)
	self._online_fd_client[fd] = nil
	--全部链接断开了
	if not next(self._online_fd_client) then
		--这里会挂起，所以需要double check
		skynet.sleep(1000)	-- exit after 10s
		if not next(self._online_fd_client) then
			-- double check
			if not self._user_exiting then
				self._user_exiting = true	-- mark exit
				AgentManagerService.req.exit(self.userid)
				skynet.error("user %s afk", self.userid)
				--agent只回收不销毁
				self:final()
			end
		end
	end
end

function User:sendUserData()
	local userData = {
		moneyData   = self.moneyManager:serialize(),
		bingHuoData = self.bingHuoActivityManager:serialize(),
	}
	return userData
end

return User
