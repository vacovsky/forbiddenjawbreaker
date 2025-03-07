local net = require 'lib/network'
local sc = require 'lib/sc'

local nuggetDests = {
    "create:mechanical_crafter_10",
    "create:mechanical_crafter_11",
    "create:mechanical_crafter_12",
    "create:mechanical_crafter_13",
    "create:mechanical_crafter_15",
    "create:mechanical_crafter_16",
    "create:mechanical_crafter_17",
    "create:mechanical_crafter_18",
}
local carrotSlot = "create:mechanical_crafter_14"


function makeGoldenCarrots()
    -- nuggets
    for _, mc in pairs(nuggetDests) do
        sc.pull("minecraft:gold_nugget", 1, true, mc)
    end
    -- carrot
    sc.pull("minecraft:carrot", 1, true, carrotSlot)
end

while true do
    -- if not pcall(makeGoldenCarrots) then print('makeGoldenCarrots() failed to complete') end

    makeGoldenCarrots()
    sleep(1)
end