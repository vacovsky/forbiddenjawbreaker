local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'
local enchants = require 'lib/ars_enchanter_recipes'
local sc = require "lib/sc"

local ITEM_INPUT = 'warehouse'
local ITEM_OUTPUT = 'warehouse'
local arcanePedestals = 'ars_nouveau:arcane_pedestal'
local enchanter = 'ars_nouveau:enchanting_apparatus_0'

function UnloadAllPedestals()
    local peds = net.ListMatchingDevices(arcanePedestals)
    for _, ped in pairs(peds) do
        local p = peripheral.wrap(ped)
        for slot, item in pairs(p.list()) do
            sc.push(ped, slot)
            -- whi.DepositInAnyWarehouse(ped, slot)
        end
    end
end

function ReturnTargetItemToUser()
    -- local ea = peripheral.wrap(enchanter)
    -- for slot, item in pairs(ea.list()) do
    -- whi.DepositInAnyWarehouse(enchanter, 1)
    sc.push(enchanter, 1)

    -- ea.pushItems(ITEM_OUTPUT, slot)
    -- end
end

function PlaceTargetItemInEnchanter(item)
    sc.pull(item, 1, true, enchanter)
end

function LoadPedestalsWithMaterials(recipe)
    local peds = net.ListMatchingDevices(arcanePedestals)
    for _, mat in pairs(recipe) do
        local moved = 0
        for _, ped in pairs(peds) do
            moved = sc.pull(mat, 1, true, ped)
            if moved > 0 then
                goto next
            end
        end
        ::next::
    end
end

function EnchantItem(base_item, recipe)
    term.clear()
    print("\n\n             Enchanting", base_item, "\n\n             This may take a while")
    print("\n \n \n \n \n")
    UnloadAllPedestals()
    LoadPedestalsWithMaterials(recipe)

    PlaceTargetItemInEnchanter(base_item)

    sleep(15)
    ReturnTargetItemToUser()
end

while true do
    local currentInventory = whi.ItemCountMap()

    term.clear()
    term.setBackgroundColor(colors.black)

    local base_bow = 'minecraft:bow'
    local ars_bow = 'ars_nouveau:spell_bow'

    local base_leggings = 'minecraft:iron_leggings'
    local ars_leggings = 'ars_nouveau:arcanist_leggings'

    local base_boots = 'minecraft:iron_boots'
    local ars_boots = 'ars_nouveau:boots'

    local base_chestplate = 'minecraft:iron_chestplate'
    local ars_robes = 'ars_nouveau:robes'

    local base_helmet = 'minecraft:iron_helmet'
    local ars_hood = 'ars_nouveau:hood'

    -- print(currentInventory)
    
    -- rednet.send(16, 'item_count_map', 'storage_status_api')
    -- local id, message = rednet.receive()
    -- for i, k in pairs(message) do print(i, k) end

    -- -- boots hood leggings robes
    -- if currentInventory[ars_leggings] == nil or currentInventory[ars_leggings] < 3 then
    --     EnchantItem(base_leggings, enchants.arcanist_armor)
    -- end

    -- if currentInventory[ars_hood] == nil or currentInventory[ars_hood] < 3 then
    --     EnchantItem(base_helmet, enchants.arcanist_armor)
    -- end

    -- if currentInventory[ars_robes] == nil or currentInventory[ars_robes] < 3 then
    --     EnchantItem(base_chestplate, enchants.arcanist_armor)
    -- end

    -- if currentInventory[ars_boots] == nil or currentInventory[ars_boots] < 3 then
    --     EnchantItem(base_boots, enchants.arcanist_armor)
    -- end
    print(sc.count(ars_bow))
    if sc.count(ars_bow) < 3 then
        EnchantItem(base_bow, enchants.spell_bow)
    end
    sleep(300)
end
