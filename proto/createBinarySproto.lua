package.cpath ="../3rd/skynet/luaclib/?.so"
package.path ="../3rd/skynet/lualib/?.lua;../base/lualib/?.lua"
local sproto = require "sproto"
local core = require "sproto.core"
local print_r = require "print_r"
local sprotoparser = require "sprotoparser"
local DBSprotoFileList = require "DBSprotoFileList"

local protoPath = "../proto/"
local function createBinarySproto(schemaBinaryName, sprotoFileList)
    local file
    local schemaRawData = ""
    local tempSchema
    for _, sprotoFile in pairs(sprotoFileList) do
        file = assert(io.open(protoPath..sprotoFile))
        tempSchemaData = file:read "a"
        schemaRawData = schemaRawData..tempSchemaData
        file:close()
    end
    local schemaBinaryData = sprotoparser.parse(schemaRawData)
    file = assert(io.open(protoPath..schemaBinaryName, "w+"))
    local ok, err = f:write(schemaBinaryData)
    file:close()
end

createBinarySproto("DBSchemaBinary", DBSprotoFileList)
createBinarySproto("C2SSchemaBinary", {"proto.c2s.sproto"})
createBinarySproto("S2CSchemaBinary", {"proto.s2c.sproto"})
--return function(sprotoFileList, schemaBinaryName)
--end

--local schemaParseObj = sproto.parse(schemaRawData)
--core.dumpproto(schemaParseObj.__cobj)
--
--local bingHuoActivityData = {
--	bingHuoScore = 1,
--	activityBaseData = {
--		id 		= 1,
--		state   = 2,
--		name    = "bingHuo",
--	},
--}
--
--local activityEncodeData = schemaParseObj:encode("BingHuoActivityData", bingHuoActivityData)
--
--
--f= assert(io.open("../proto/DBSchemaBinary"))
--local DBSchemaBinary = f:read "a"
--local DBSchema = sproto.new(DBSchemaBinary)
