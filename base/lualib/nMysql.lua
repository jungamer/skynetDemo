local mysql = require "mysql"
local skynet = require "skynet"

--TODO 对mysql进行封装
local nMysql = {}
function nMysql.connect(conf)
	local self = {
		conf = conf,
	}
	setmetatable(self, nMysql)
	self._connect_handle = mysql.connect(conf)
	if not self._connect_handle then
		skynet.error("connect db error[", conf.host, conf.port, conf.database, conf.user, conf.password,"]")
	end
    return self
end

function nMysql:connect(conf)
end

return nMysql
