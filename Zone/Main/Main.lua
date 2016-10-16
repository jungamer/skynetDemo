local skynet = require "skynet"
local MasterService = require "MasterService.Interface"
local ZoneConfig = require "config.ZoneConfig"

skynet.start(function()
	skynet.error("Server start")
	if not skynet.getenv "daemon" then
		skynet.newservice("console")
	end
	skynet.newservice("debug_console",ZoneConfig.telnetConfig.ip, ZoneConfig.telnetConfig.port)
	local proto = skynet.uniqueservice "protoloader"
	skynet.call(proto, "lua", "load", {
		"C2SSprotoBin",
		"S2CSprotoBin",
  	    "DBSprotoBin",
	})
    skynet.fork(function()
        local ok, _ = xpcall(MasterService.start, debug.traceback)
        if not ok then
            skynet.error("MasterService启动失败")
        end
    end)
end)
