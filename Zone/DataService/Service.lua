local nMysql = require "nMysql"
local ZoneConfig = require "ZoneCofnig"
local mysql = require "mysql"

local mysqlConnection
function init()
	mysqlConnection = nMysql.connect(ZoneConfig.mysqlConfig)
end

function exit()
	mysqlConnection:close()
end

function response.newUserData(account_name, char_name, uid)
	local value = {account_name, char_name, uid}
	local valueStr = table.concat(value, ",")
	mysqlConnection:query("INSERT INTO USER_DATA (ACCOUNT_NAME, CHAR_NAME, CHAR_ID) VALUES ("..valueStr..")")
end

function response.loadUserData(uid)
	local res = mysqlConnection:query("SELECT ACCOUNT_NAME, CHAR_NAME, CHAR_ID, MONEY_BINARY, BING_HUO_ACTIVITY_BINARY FROM USER_DATA WHERE CHAR_ID = "..uid)
	local row = res[1]
	for k, v in pairs(row) do
		print("userData[", uid, k, v, "]")
	end
	return res[1]
end
