local BingHuoActivityManager = {}
local user

function BingHuoActivityManager.new(owner)
	user = owner
end

function BingHuoActivityManager:init()
end

function BingHuoActivityManager:serialize()
	local data = {
		activityBaseData = {
			id 	= self._id,
			name 	= self._name,
			state 	= self._state,
		},
		bingHuoScore = self._bing_huo_score,
	}
	return data
end

function BingHuoActivityManager:unSerialize(data)
	self._bing_huo_score = data.bingHuoScore
	self._id = self.activityBaseData.id
	self._name = self.activityBaseData.name
	self._state = self.activityBaseData.state
end

function BingHuoActivityManager:final()
	self._bing_huo_score = nil
	self._id = nil
	self._name = nil
	self._state = nil
end

return BingHuoActivityManager
