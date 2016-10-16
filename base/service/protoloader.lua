--local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local service = require "service"
--local log = require "log"

local loader = {}
local data = {}

local function load(name)
	local filename = string.format("../proto/"..name)
	local f = assert(io.open(filename), "Can't open " .. name)
	local t = f:read "a"
	f:close()
    return t
end

function loader.load(list)
	for i, name in ipairs(list) do
		local p = load(name)
		data[name] = i
		sprotoloader.save(p, i)
	end
end

function loader.index(name)
	return data[name]
end

service.init {
	command = loader,
	info = data
}
