local json = require "lib/json"
local vars = require "lib/constants"
local net = require "lib/network"
local whi = require "lib/whi"
local sc = require "lib/sc"


local bottle = 'minecraft:glass_bottle'

function StockBottles()
    for _, hive in pairs(net.ListMatchingDevices(vars.hives)) do
        -- local bottles_replenished = whi.GetFromAnyWarehouse(false, 'minecraft:glass_bottle', hive, 4)
        local bottles_replenished = sc.pull(bottle, 1, true, hive, 4)
        bottles_replenished = sc.pull(bottle, 1, true, hive, 1)
        bottles_replenished = sc.pull(bottle, 1, true, hive, 2)
        bottles_replenished = sc.pull(bottle, 1, true, hive, 3)
        -- bottles_replenished = sc.pull(bottle, 1, true, hive, 4)
        print(bottles_replenished, hive)
        if bottles_replenished > 0 then print('Stocked', bottles_replenished, '->', hive) end
    end
end

while true do
    StockBottles()
    -- if not pcall(StockBottles) then print('StockBottles() failed to complete') end
    sleep(1)
end
