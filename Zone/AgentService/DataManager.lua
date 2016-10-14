local ZoneConfig = require "ZoneConfig"
local SprotoDefine = require "Common.SprotoDefine"
local sprotoloader = require "sprotoloader"
local DataService = require "DataService.Interface"

local DataManager = {}
local SerializeHandle
local user
function DataManager.new(owner)
	user = owner
end

function DataManager:init()
	if not self.dbSprotoParse then
		self.dbSprotoParse = sprotoloader.load(SprotoDefine.SprotoIndexDB)
	end
	local userData = DataService.req.loadUserData()
	local columnData, decodeData
	for columnName, handle in pairs(SerializeHandle) do
		columnData = userData[columnName]
		if columnData then
			handle.unSerialize(columnData)
		elseif handle.init then
			handle.init()
		end
	end
end

function DataManager.final()
end

--TODO 不用实时存,每隔多少时间存一次
function DataManager:setNeedSave(name, data)
	local handle = SerializeHandle[name]
	local serializeData = handle.serialize(data)
	if serializeData then
		DataService.post.saveUserData(user.id, name, serializeData)
	end
end

--TODO存储数据时加入版本号
SerializeHandle = {
	["LEVEL"] = {
		serialize = function()
			return user.level
		end,
		unSerialize = function(data)
			user.level = data.level
		end,
	},
	["MONEY_BINARY"]	= {
		serialize = function()
			return user.moneyManager:serialize()
		end,
		unSerialize = function(data)
			local decodeData = self.dbSprotoParse:decode("MoneyData", data)
			user.moneyManager:unSerialize(decodeData)
		end,
	},
	["BING_HUO_ACTIVITY_BINARY"] = {
		serialize = function()
			return user.bingHuoActivityManager:serialize()
		end,
		unSerialize = function(data)
			local decodeData = self.dbSprotoParse:decode("BingHuoActivityData", data)
			user.bingHuoActivityManager:unSerialize(decodeData)
		end,
	},
}

return DataManager
