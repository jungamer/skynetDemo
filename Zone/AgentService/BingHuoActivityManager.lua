local BingHuoActivityManager = {
    _score = 0,
}
local user

function BingHuoActivityManager.new(owner)
	user = owner
    return BingHuoActivityManager
end

function BingHuoActivityManager:init()
end

function BingHuoActivityManager:addScore(score)
    self._score = self._score + score
    --user:pushMsg("updateBingHuo", {bingHuoActivityData = {bingHuoScore = self._score}})
    user:pushMsg("updateBingHuo", {bingHuoActivityData = self:serialize()})
end

function BingHuoActivityManager:serialize()
	local data = {
		activityBaseData = {
			id 	= self._id,
			name 	= self._name,
			state 	= self._state,
		},
		bingHuoScore = self._score,
	}
	return data
end

function BingHuoActivityManager:unSerialize(data)
	self._score = data.bingHuoScore
	self._id = self.activityBaseData.id
	self._name = self.activityBaseData.name
	self._state = self.activityBaseData.state
end

function BingHuoActivityManager:final()
	self._score = 0
	self._id = nil
	self._name = nil
	self._state = nil
end

return BingHuoActivityManager
