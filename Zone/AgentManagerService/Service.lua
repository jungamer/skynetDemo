local skynet = require "skynet"
local service = require "service"
local AgentService = require "AgentService.Interface"
local log = require "log"

local users = {}

local agentPoll = {}
local agentPoollSize = 10
function init(...)
	local agent
	for i = 1, agentPoollSize do
		agent = AgentService.start()
		table.insert(agentPoll, agent)
	end
end

function exit(...)
	for _, agent in ipairs(agentPoll) do
		skynet.kill(agent)
	end
end

local function new_agent()
	local agent = agentPoll[#agentPoll]
	if not agent then
		agent = AgentService.start()
	end
	return agent
end

local function free_agent(agent)
	table.insert(agentPoll, agent)
end

function response.assign(fd, userid)
	local agent
	repeat
		agent = users[userid]
		if not agent then
			agent = new_agent()
			if not users[userid] then
				-- double check
				users[userid] = agent
			else
				free_agent(agent)
				agent = users[userid]
			end
		end
	until agent.req.assign(fd, userid)
	log("Assign %d to %s [%s]", fd, userid, agent)
end

function response.exit(userid)
	users[userid] = nil
end
