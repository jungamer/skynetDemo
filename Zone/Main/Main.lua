local skynet = require "skynet"
local MasterService = require "MasterService.Interface"

skynet.start(function()
	skynet.error("Server start")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)
	local proto = skynet.uniqueservice "protoloader"
	skynet.call(proto, "lua", "load", {
		"C2SSchemaBinary",
		"S2CSchemaBinary",
  	        "DBSchemaBinary",
	})
    skynet.fork(function()
        local ok, result = xpcall(MasterService.start, debug.traceback)
        if not ok then
            skynet.error("MasterService启动失败")
        end
    end)
end)
