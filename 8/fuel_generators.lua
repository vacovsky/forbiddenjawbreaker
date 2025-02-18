local whi = require 'lib/whi'
local net = require 'lib/network'
local sc = require "lib/sc"


local minraw_before_smelt = 256
local max_result_allowed = 512

local furnaces = 'furnace'
local generators = 'enderio:stirling'
-- local furnaces = 'minecraft:furnace'
local waxfuel = 'productivebees:wax'
local lavafuel = "minecraft:lava_bucket"


function FuelGenerators()
    for _, gen in pairs(net.ListMatchingDevices(generators)) do
        print(sc.pull(waxfuel, 64, true, gen, 1), 'gen: fueled (wax)')
        print(sc.pull(lavafuel, 1, true, gen, 1), 'gen: fueled (lava)')
    end
end

while true do
    if not pcall(FuelGenerators) then print('FuelGenerators() failed to complete') end
    -- FuelGenerators()
    sleep(30)
end
