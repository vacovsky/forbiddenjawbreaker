-- get_item_count_api.lua
-- storage_controller

local args = {...}
local client_id = tonumber(args[1])
local client_protocol = args[2]
local item_query = args[3]

local whi = require 'lib/whi'
local map = whi.ItemCountMap()

local count = map[item_query].count
if count == nil then count = 0 end

rednet.send(client_id, count, client_protocol)

print("debug sleep")
sleep(20)
print("debug end")
