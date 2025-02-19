-- get_item_count_api.lua
-- storage_controller

local args = {...}
local client_id = tonumber(args[1])
local client_protocol = args[2]
local item_query = args[3]

local whi = require 'lib/whi'
local count = whi.GetSpecificItemCount(item_query)
rednet.send(client_id, count, client_protocol)

print("debug sleep")
sleep(20)
print("debug end")
