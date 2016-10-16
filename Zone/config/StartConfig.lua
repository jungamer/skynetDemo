--luacheck: ignore 113 111
local skynet_path = "../3rd/skynet/"
local base_lua_path = "../base/lualib/?.lua;"
local base_service_path = "../base/service/?.lua;"
local base_lua_c_path = "../base/luaclib/?.so;"
thread = 5
logger = nil
harbor = 0
start = "Main/Main"
bootstrap = "snlua bootstrap"	-- The service for bootstrap
luaservice = skynet_path.."service/?.lua;../base/service/?.lua;./?.lua"
lualoader = skynet_path.."lualib/loader.lua"
lua_path = "./?.lua;../?.lua;"..skynet_path.."lualib/?.lua;"..base_lua_path..base_service_path
lua_cpath = skynet_path.."luaclib/?.so;../luaclib/?.so;./?.so;"..base_lua_c_path.."luaclib/?.so;"
cpath = skynet_path.."cservice/?.so;"..lua_cpath
snax = "./?.lua;"..base_service_path
daemon = ""
if daemon == "" then
	daemon = nil
end
--preload = "./Main/PreloadZone.lua"
