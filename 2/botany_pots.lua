local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"
local sc = require "lib/sc"
local net = require 'lib/network'

local botanypots = "botanypots:botany_pot"

function Harvest()
    local pots = net.ListMatchingDevices(botanypots)
    for _, pot in pairs(pots) do
        local itemsMoved = 0
        local src = peripheral.wrap(pot)
        for slot, item in pairs(src.list()) do
            if slot > 2 then
                itemsMoved = itemsMoved + sc.push(pot, slot)
            end
        end
        if itemsMoved > 0 then print(itemsMoved, 'xferred') end
    end
end

while true do
    -- if not pcall(Harvest) then print('Harvest() failed to complete') end
    pcall(Harvest)
    sleep(15)
end
