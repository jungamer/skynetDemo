local PATH,IP = ...

IP = IP or "127.0.0.1"

package.path = string.format("%s/client/?.lua;%s/skynet/lualib/?.lua", PATH, PATH)
package.cpath = string.format("%s/skynet/luaclib/?.so;%s/lsocket/?.so", PATH, PATH)

local socket = require "SimpleSocket"
local message = require "SimpleMessage"

message.register(string.format("%s/proto/%s", PATH, "proto"))

message.peer(IP, 5678)
message.connect()

local event = {}

message.bind({}, event)

function event:__error(what, err, req, session)
	print("error", what, err)
end

function event:ping()
	print("ping")
end

function event:signin(req, resp)
	print("signin", req.userid, resp.ok)
	if resp.ok then
		self.userInfoList = resp.userInfoList
		message.request "ping"	-- should error before login
		message.request("selectUid", { userid = self.userInfoList[1].userid })
	else
		-- signin failed, signup
		message.request("signup", { accountName = req.accountName})
	end
end

function event:signup(req, resp)
	print("signup", resp.ok)
	if resp.ok then
		message.request("signin", { accountName = req.accountName})
	else
		error "Can't signup"
	end
end

function event:login(_, resp)
	print("login", resp.ok)
	if resp.ok then
		message.request "ping"
	else
		error "Can't login"
	end
end

function event:selectUid(req, resp)
	message.request "requestUserData"
end

function event:requestUserData(args)
	if resp.ok then
		for k, v in pairs(args) do
			print(k, v)
		end
		message.request "logout"
	else
		error "requestUserData err"
	end
end

function event:logout(req, resp)
	if resp.ok then
		message.request "ping"
	end
end

function event:push(args)
	print("server push", args.text)
end

message.request("signin", { accountName = "account_alice" })

while true do
	message.update()
end
