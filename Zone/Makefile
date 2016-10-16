SERVER_PATH = ..
ZONE_PATH = $(SERVER_PATH)/Zone
PROTO_PATH = $(SERVER_PATH)/proto
SKYNET_PATH = $(SERVER_PATH)/3rd/skynet
LUA_BIN = $(SKYNET_PATH)/3rd/lua/lua

#任一个协议改变了，全部编译，可以优化
$(PROTO_PATH)/DBSprotoBin : $(PROTO_PATH)/*.sproto $(PROTO_PATH)/GenBinSprotoTool.lua
	$(LUA_BIN) $(PROTO_PATH)/GenBinSprotoTool.lua
