local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"
local net = require "lib/network"
local sc = require "lib/sc"

local combs_dest = 'enderstorage:ender_chest_9'


function CollectFromHives()
    local combsMoved = 0
    for _, hive in pairs(net.ListMatchingDevices(vars.hives)) do
        local phive = peripheral.wrap(hive)
        local pcombdest = peripheral.wrap(combs_dest)
        for slot, item in pairs(phive.list()) do
            if slot == 1 or slot == 2 then goto skip end
            if not string.find(item.name, 'minecraft:') and
                string.find(item.name, 'productivebees') and not string.find(item.name, 'sugarbag') then
                combsMoved = combsMoved + pcombdest.pullItems(hive, slot)
            else
                combsMoved = combsMoved + sc.push(hive, slot)
                -- combsMoved = combsMoved + whi.DepositInAnyWarehouse(hive, slot)
            end
            ::skip::
        end
    end
    if combsMoved > 0 then print('Transferred', combsMoved, 'combs') end
end


print("Starting hive collector...")
while true do
    if not pcall(CollectFromHives) then print('CollectFromHives() failed to complete') end
    -- CollectFromHives()
    sleep(1)
end
