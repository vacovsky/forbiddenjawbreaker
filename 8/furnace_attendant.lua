local whi = require 'lib/whi'
local net = require 'lib/network'
local sc = require "lib/sc"


local minraw_before_smelt = 256
local max_result_allowed = 512

local furnaces = 'furnace'
-- local furnaces = 'minecraft:furnace'
local waxfuel = 'productivebees:wax'
local lavafuel = "minecraft:lava_bucket"
-- local generator_coalbox = 'sophisticatedstorage:barrel_3'
local coalfuel = 'minecraft:coal'
local raw_items = {
    -- 'minecraft:cobblestone',
    -- 'minecraft:clay_ball',
    -- 'minecraft:echo_shard',
    -- 'create:crushed_raw_gold',
    -- 'create:crushed_raw_copper',
    -- 'create:crushed_raw_iron',
    -- 'create:crushed_raw_zinc',
    -- 'create:crushed_raw_silver',
    -- 'scguns:crushed_raw_anthralite',
    -- 'scguns:diamond_steel_blend',
    -- 'minecraft:rotten_flesh',
    -- 'minecraft:raw_gold',
    "raw_ore",
    ":raw_",
    ":crushed_raw_",
    -- 'minecraft:raw_gold',
    -- 'minecraft:raw_copper',
    -- 'minecraft:raw_iron',
    -- 'scguns:raw_anthralite',
}

function AttendFurnaces()
    for _, raw_item in pairs(raw_items) do
        local moved = 0
        local stored = 0
        for _, furnace in pairs(net.ListMatchingDevices(furnaces)) do
            -- Refuel furnaces
            -- print(whi.GetFromAnyWarehouse(false, coalfuel, furnace, 64, 2), 'fueled (coal)')
            -- print('deposited', whi.DepositInAnyWarehouse(furnace, 2), raw_item)

            -- print(whi.GetFromAnyWarehouse(false, waxfuel, furnace, 64, 2), 'fueled (wax)', furnace)

            -- print(whi.GetFromAnyWarehouse(false, 'minecraft:lava_bucket', furnace, 1, 2), 'fueled (lava)', furnace)
            stored = moved + sc.push(furnace, 2)
            moved = moved + sc.pull(waxfuel, 64, true, furnace, 2)
            moved = moved + sc.pull(lavafuel, 1, true, furnace, 2)


            -- sc.pull(waxfuel, 8, true, furnace, 2)
            -- move smelted items to warehouse
            -- print('deposited', whi.DepositInAnyWarehouse(furnace, 3), 'items')
            stored = moved + sc.push(furnace, 3)
            -- move item for smelting to furnace
            moved = moved + sc.pull(raw_item, 8, false, furnace, 1)
            -- moved = moved + whi.GetFromAnyWarehouse(true, raw_item, furnace, 64, 1)
            -- if moved >= 32 then
            --     goto next_item
            -- end
        end
        if moved > 0 then print(moved, raw_item) end
        if stored > 0 then print(stored, "processed items") end
        -- ::next_item::
    end
end

function FuelGenerators()

    -- sc.pull(raw_item, 8, true, furnace, 1)

    -- print(sc.pull(waxfuel, 1024, true, generator_coalbox), 'gen: fueled (wax)')
    -- print(whi.GetFromAnyWarehouse(false, waxfuel, generator_coalbox, 1024, 2), 'gen: fueled (wax)')
    -- print(whi.GetFromAnyWarehouse(false, waxfuel, generator_coalbox, 1024, 2), 'gen: fueled (wax)')
    -- print(whi.GetFromAnyWarehouse(false, waxfuel, generator_coalbox, 1024, 2), 'gen: fueled (wax)')
    -- print(whi.GetFromAnyWarehouse(false, waxfuel, generator_coalbox, 1024, 2), 'gen: fueled (wax)')
    -- print(whi.GetFromAnyWarehouse(false, coalfuel, generator_coalbox, 64, 2), 'gen: fueled (coal)')
    -- print(whi.GetFromAnyWarehouse(false, coalfuel, generator_coalbox, 64, 2), 'gen: fueled (coal)')
end

while true do
    -- if not pcall(FuelGenerators) then print('FuelGenerators() failed to complete') end
    -- FuelGenerators()
    if not pcall(AttendFurnaces) then print('AttendFurnaces() failed to complete') end
    -- AttendFurnaces()

    -- pcall(FuelGenerators)
    -- pcall(AttendFurnaces())
    sleep(1)
end
