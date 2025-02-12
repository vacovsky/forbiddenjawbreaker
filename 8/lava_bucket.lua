local vars = require "lib/constants"
local net = require 'lib/network'
local whi = require 'lib/whi'

local fluid_storage = 'enderio:fluid_tank_1'
local bottler = 'create:depot_2'
local dispenser = 'create:spout_0'

function BucketFiller()
    -- FILL SPOUT
    local lava = peripheral.wrap(fluid_storage).pushFluid(dispenser)
    if lava > 0 then print('Refilled', lava, 'lava mb') end

    -- BOTTLER
    local container = peripheral.wrap(bottler)

    -- PLACE FILLED buckets IN WAREHOUSE
    for slot, item in pairs(container.list()) do
        if item.name == 'minecraft:lava_bucket' then
            local depositNum = whi.DepositInAnyWarehouse(bottler, slot)
            if depositNum > 0 then print('Filled', depositNum, 'lava buckets') end
        end
    end

    -- REFILL WITH EMPTY buckets
    local restockNum = whi.GetFromAnyWarehouse(false, 'minecraft:bucket', bottler, 16)
    if restockNum > 0 then print('Restocked', restockNum, 'buckets') end
end


print('Starting BOTTLER')
while true do
    if not pcall(BucketFiller) then print('BucketFiller() failed to complete') end
    -- BucketFiller()
    sleep(1)
end