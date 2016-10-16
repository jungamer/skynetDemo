--路径相对于Zone目录
local DBSprotoFileList = {
    "BingHuoActivityData.sproto",
    "ActivityBaseData.sproto",
    "MoneyData.sproto",
    "DBPackage.sproto",
}

local C2SSprotoFileList = {
    "BingHuoActivityData.sproto",
    "ActivityBaseData.sproto",
    "MoneyData.sproto",
    "proto.c2s.sproto",
}

local S2CSprotoFileList = {
    "proto.s2c.sproto",
}

return {DBSprotoFileList, C2SSprotoFileList, S2CSprotoFileList}
