local skynet = require "skynet"
local MoneyManager = require "AgentService.MoneyManager"
local DataManager = require "AgentService.DataManager"
local BingHuoActivityManager = require "AgentService.BingHuoActivityManager"
local client = require "client"

--支持多个连接同时在线, 支持agent回收
local User = {
--	userid  = nil,
--	fd	= nil,
--	exiting = nil,
	_online_fd_userid = {},
}

function User.new()
	User.dataManager = DataManager.new(User)
	User.moneyManager = MoneyManager.new(User)
	User.bingHuoActivityManager = BingHuoActivityManager.new(User)
	return User
end

function User:dealNewClient()
	if not next(self._online_fd_userid) then
		self.dataManager:init()
		self.moneyManager:init()
		self.bingHuoActivityManager:init()
	end
end

function User:final()
	self.bingHuoActivityManager:final()
	self.moneyManager:final()
	self.dataManager:final()
	self.userid = nil
	self.exiting = nil
end

function User:checkNewClient(fd, userid)
	if self.exiting then
		skynet.error("正在退出状态中[", userid, "]")
		return false
	end
	if not self._online_fd_userid[fd] then
		self._online_fd_userid[fd] = userid
	end
	assert(self._online_fd_userid[fd] == userid)
	return true
end

function User:dealClientClose(fd)
	client.close(fd)
	self._online_fd_userid[fd] = nil
	--全部链接断开了
	if not next(self._online_fd_userid) then
		skynet.sleep(1000)	-- exit after 10s
		if not next(self._online_fd_userid) then
			-- double check
			if not self.exit then
				self.exit = true	-- mark exit
				AgentManagerService.req.exit(self.userid)
				skynet.error("user %s afk", self.userid)
				--agent只回收不销毁
				self:final()
			end
		end
	end
end

return User
