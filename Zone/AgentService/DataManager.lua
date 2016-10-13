local ZoneConfig = require "ZoneConfig"
local SprotoDefine = require "Common.SprotoDefine"
local sprotoloader = require "sprotoloader"

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

--dbSprotoParse 考虑到agent可能做复用，dbSprotoParse不赋值为nil, 
function DataManager.final()
	user = nil
	self.dbSprotoParse = nil
end

--TODO 不用实时存,每隔多少时间存一次
function DataManager:setNeedSave(name, data)
	local handle = SerializeHandle[name]
	local serializeData = handle.serialize(data)
	if serializeData then
		DataService.post.saveUserData(user.id, name, serializeData)
	end
end

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
			local decodeData = self.dbSprotoParse:decode("MoneyList", data)
			return user.moneyManager:unSerialize(decodeData)
		end,
	},
	["BING_HUO_ACTIVITY_BINARY"]
		serialize = function()
			return user.bingHuoActivityManager:serialize()
		end,
		unSerialize = function(data)
			local decodeData = self.dbSprotoParse:decode("BingHuoActivityData", data)
			return user.bingHuoActivityManager:unSerialize(decodeData)
		end,
	end,
}

return DataManager