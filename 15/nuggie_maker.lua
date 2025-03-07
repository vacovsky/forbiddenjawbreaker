local net = require 'lib/network'
local sc = require 'lib/sc'

local nuggieSlots = {"create:mechanical_crafter_19", "create:mechanical_crafter_20"}

local nuggieTypes = {
    ['minecraft:iron_nugget'] = 'minecraft:iron_ingot',
    ['minecraft:gold_nugget'] = 'minecraft:gold_ingot',
    ['scguns:gunpowder_dust'] = 'minecraft:gunpowder'
}

function makeNuggies()
    for _, ns in pairs(nuggieSlots) do
        for k, v in pairs(nuggieTypes) do
            print(k)
            if sc.count(k) < 64 then
                sc.pull(v, 1, true, ns)
            end
        end
    end
end

while true do
    -- if not pcall(makeNuggies) then print('makeNuggies() failed to complete') end

    makeNuggies()
    sleep(1)
end
