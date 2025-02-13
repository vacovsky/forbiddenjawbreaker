local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'
local sc = require "lib/sc"


local imbuementChamber = 'ars_nouveau:imbuement_chamber'

function ImbueGemsToEssences()
    local stored = 0
    local imbuing = 0

    for _, ic in pairs(net.ListMatchingDevices(imbuementChamber)) do
        local icp = peripheral.wrap(ic)
        for slot, item in pairs(icp.list()) do
            -- if item.name ~= "ars_nouveau:source_gem" and item.name ~= "minecraft:amethyst_shard" then
            -- if item.name ~= "ars_nouveau:source_gem" and item.name ~= "minecraft:amethyst_shard" then
                -- stored = stored + whi.DepositInAnyWarehouse(ic, slot)
                stored = stored + sc.push(ic, slot)
            -- end
        end
        imbuing = imbuing + sc.pull("ars_nouveau:source_gem", 1, true, ic, 1)
        imbuing = imbuing + sc.pull("minecraft:amethyst_shard", 1, true, ic, 1)
        -- imbuing = imbuing + whi.GetFromAnyWarehouse(false, 'ars_nouveau:source_gem', ic, 1)
        -- imbuing = imbuing + whi.GetFromAnyWarehouse(false, "minecraft:amethyst_shard", ic, 1)
    end
    print("imbued", imbuing, "stored", stored)
end

print('Imbuement starting...')
while true do
    -- ImbueShardsToGems()
    -- ImbueGemsToEssences()
    -- if not pcall(ImbueShardsToGems) then print('ImbueShardsToGems() failed to complete') end
    if not pcall(ImbueGemsToEssences) then print('ImbueGemsToEssences() failed to complete') end
    sleep(300)
end
