local whi = require 'lib/whi'
local net = require 'lib/network'
local sc = require "lib/sc"


local minraw_before_smelt = 256
local max_result_allowed = 512

local furnaces = 'sophisticatedstorage:barrel_17'
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
    local moved = 0
    for _, raw_item in pairs(raw_items) do
        if string.find(raw_item, 'block') then goto next end
        for _, furnace in pairs(net.ListMatchingDevices(furnaces)) do
            moved = moved + sc.pull(raw_item, 64, false, furnace)
        end
        if moved > 0 then print(moved, raw_item) end
        ::next::
    end
end

while true do
    if not pcall(AttendFurnaces) then print('AttendFurnaces() failed to complete') end
    sleep(1)
end
