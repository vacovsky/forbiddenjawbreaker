local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'

local warehouses = {':warehouse', 'sophisticatedstorage:chest'}
local TRASHCAN = 'sophisticatedstorage:barrel_28'

local MIN_KEEP_COUNT = 5120


function PruneWarehouse()
    local itemCountMap = {}

    -- COLLECT WAREHOUSE NAMES
    local warehouse_list = net.ListMultipleMatchingDevices(warehouses)

    for _, warehouse in pairs(warehouse_list) do
        local whp = peripheral.wrap(warehouse)
        for _, item in pairs(whp.list()) do
            -- print(item.name, item.count)
            if itemCountMap[item.name] == nil then
                itemCountMap[item.name] = item.count
            else
                itemCountMap[item.name] = itemCountMap[item.name] + item.count
            end
        end
    end

    ::loopback::
    for name, count in pairs(itemCountMap) do
        if count > MIN_KEEP_COUNT then
            
            print(count, name)
            local moved = whi.GetFromAnyWarehouse_OLD(false, name, TRASHCAN, 64)
            itemCountMap[name] = itemCountMap[name] - moved
            print('burned', itemCountMap[name],'-', moved, name)
            sleep()
            goto loopback
        end
    end
end

while true do
    PruneWarehouse()
    sleep(600)
end