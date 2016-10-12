local sproto = require "sproto"
local core = require "sproto.core"
local print_r = require "print_r"
local sprotoparser = require "sprotoparser"

local f 
f = assert(io.open("BingHuoActivityData.sproto"))
local BingHuoActivityData = f:read "a"
f:close()

f = assert(io.open("ActivityBaseData.sproto"))
local ActivityBaseData = f:read "a"
f:close()

local activityData = BingHuoActivityData..ActivityBaseData
local sp = sproto.parse(activityData)
core.dumpproto(sp.__cobj)

local bingHuoActivityData = {
	bingHuoScore = 1,
	activityBaseData = {
		id 		= 1,
		state   = 2,
		name    = "bingHuo",
	},
}

sp:encode"BingHuoActivityData", bingHuoActivityData)
local activitySchemaBinary = sprotoparser.parse(activityData)
f = assert(io.open("DBSchemaBinary", "w+"))
local ok, err = f:write(activitySchemaBinary)
f:close()

f= assert(io.open("DBSchemaBinary"))
local DBSchemaBinary = f:read "a"
local DBSchema = sproto.new(DBSchemaBinary)