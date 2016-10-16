local PATH,IP = ...

IP = IP or "127.0.0.1"

package.path = "./?.lua;../3rd/skynet/lualib/?.lua;../base/lualib/?.lua"
package.cpath = "../3rd/skynet/luaclib/?.so;../base/luaclib/?.so;"

--local socket = require "SimpleSocket"
local message = require "SimpleMessage"

message.register(string.format("%s/proto/%s", PATH, "proto"))

message.peer(IP, 50000)
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
	message.request "ping"
	message.request "requestUserData"
end
local function print_t(t)
    if type(t) == "table" then
        for i, j in pairs(t) do
            if type(j) == "table" then
                if next(j) then
                    print(i.." ={")
                    print_t(j)
                    print("\n}")
                else
                    print(i.." ={}")
                end
            else
                print(i, j)
            end
        end
    end
end

function event:requestUserData(req, resp)
    for k, v in pairs(resp) do
        print(k, v)
    end
    print("requestUserData begin")
    print_t(resp)
    print("requestUserData end")
	message.request "logout"
end

function event:logout(req, resp)
	message.request "ping"
end

function event:push(args)
	print("server push", args.text)
end

function event:updateBingHuo(args)
    print("updateBingHuo begin")
    print_t(args)
    print("updateBingHuo end")
end

message.request("signin", { accountName = "account_alice" })

while true do
	message.update()
end
