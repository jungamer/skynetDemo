local nMysql = require "nMysql"
local ZoneConfig = require "config.ZoneConfig"

local mysqlConnection
local nextUserId = 1
function init()
	mysqlConnection = nMysql.connect(ZoneConfig.mysqlConfig)
end

function exit()
	mysqlConnection:close()
end

local function newUserData(account_name, char_name, uid)
	local value = {account_name, char_name, uid}
	local valueStr = table.concat(value, ",")
	mysqlConnection:query("INSERT INTO USER_DATA (ACCOUNT_NAME, CHAR_NAME, CHAR_ID) VALUES ("..valueStr..")")
end

--TODO nextUserId 应该存数据库，保证唯一，这里注册也得先查询数据库，看是否存在, 这里都简单处理了
function response.signUp(account_name, char_name)
	nextUserId = nextUserId + 1
	newUserData(account_name, char_name, nextUserId)
	return nextUserId
end

function response.loadUserData(uid)
	local res = mysqlConnection:query("SELECT ACCOUNT_NAME, CHAR_NAME, CHAR_ID, MONEY_BINARY, BING_HUO_ACTIVITY_BINARY FROM USER_DATA WHERE CHAR_ID = "..uid)
	local row = res[1]
	for k, v in pairs(row) do
		print("userData[", uid, k, v, "]")
	end
	return res[1]
end
