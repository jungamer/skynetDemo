local MoneyManager = {
	_money_type_num = {},	
}

local user
function MoneyManager.new(owner)
	user = owner
	return MoneyManager
end

function MoneyManager:init()
end

function MoneyManager:final()
	self._money_type_num = {}
end

function MoneyManager:serialize()
	local data = {}
	for moneyType, moneyNum in pairs(self._money_type_num) do
		table.insert(data, {moneyType = moneyType, moneyNum = moneyNum})
	end
	return data
end

function MoneyManager:unSerialize(data)
	for _, moneyData in ipairs(data) do
		self._money_type_num[moneyData.moneyType] = moneyData.moneyNum
	end
end

return MoneyManager