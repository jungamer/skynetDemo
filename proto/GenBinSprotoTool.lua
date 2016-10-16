package.cpath ="../3rd/skynet/luaclib/?.so"
package.path ="../3rd/skynet/lualib/?.lua;../base/lualib/?.lua;../proto/?.lua"
local sproto = require "sproto"
local core = require "sproto.core"
local print_r = require "print_r"
local sprotoparser = require "sprotoparser"
local SprotoFileList = require "SprotoFileList"
local DBSprotoFileList, C2SSprotoFileList, S2CSprotoFileList = table.unpack(SprotoFileList)
print(DBSprotoFileList, C2SSprotoFileList, S2CSprotoFileList)

local protoPath = "../proto/"
local function createBinarySproto(sprotoBinName, sprotoFileList)
    local file
    local schemaRawData = ""
    local tempSchema
    for _, sprotoFile in pairs(sprotoFileList) do
        file = assert(io.open(protoPath..sprotoFile))
        tempSchemaData = file:read "a"
        schemaRawData = schemaRawData.."\n"..tempSchemaData
        file:close()
    end
    print(schemaRawData)
    local schemaBinaryData = sprotoparser.parse(schemaRawData)
    file = assert(io.open(protoPath..sprotoBinName, "w+"))
    local ok, err = file:write(schemaBinaryData)
    file:close()
end

createBinarySproto("DBSprotoBin", DBSprotoFileList)
createBinarySproto("C2SSprotoBin", C2SSprotoFileList)
createBinarySproto("S2CSprotoBin", S2CSprotoFileList)
--return function(sprotoFileList, sprotoBinName)
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
