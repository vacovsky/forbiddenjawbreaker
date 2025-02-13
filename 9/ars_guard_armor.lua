
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'
local enchants = require 'lib/ars_enchanter_recipes'
local sc = require "lib/sc"

local ITEM_INPUT = 'warehouse'
local ITEM_OUTPUT = 'warehouse'
local arcanePedestals = 'ars_nouveau:arcane_pedestal'
local enchanter = 'ars_nouveau:enchanting_apparatus_0'

local armors = {
    'minecraft:iron_leggings',
    'minecraft:iron_helmet',
    'minecraft:iron_chestplate',
    'minecraft:iron_boots'
}

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

function PlaceTargetItemInEnchanter()
    for _, armor in pairs(armors) do
        -- local input = peripheral.wrap(ITEM_INPUT)
        local moved = 0
        moved = sc.pull(armor, 1, true, enchanter)
        -- local moved = whi.GetFromAnyWarehouse(false, armor, enchanter, 1)
        -- whi.GetFromAnyWarehouse(false, 'ars_nouveau:source_gem', ic, 1)
        if moved > 0 then goto breakout end

        -- local ea = peripheral.wrap(enchanter)
        -- for slot, item in pairs(input.list()) do
            -- ea.pullItems(ITEM_INPUT, slot)
        -- end
    end
    ::breakout::
end

function LoadPedestalsWithMaterials(recipe)
    local peds = net.ListMatchingDevices(arcanePedestals)
    for _, mat in pairs(recipe) do
        local moved = 0
        for _, ped in pairs(peds) do
            -- sc.pull(mat, 1, false, ped, nil)
            -- moved = whi.GetFromAnyWarehouse(false, mat, ped, 1)
            moved = sc.pull(mat, 1, true, ped)
            if moved > 0 then goto next end
        end
        ::next::
    end
end

function EnchantItem(recipe)
    term.clear()
    print("\n\n             Enchanting", recipe,
    "\n\n             This may take a while")
    print("\n \n \n \n \n")
    UnloadAllPedestals()
    LoadPedestalsWithMaterials(enchants[recipe])

    PlaceTargetItemInEnchanter()
    
    sleep(15)
    ReturnTargetItemToUser()
end

while true do
    term.clear()
    term.setBackgroundColor(colors.black)

    EnchantItem('arcanist_armor')

    -- print("Enter enchant name from the list below. Item in the left storage will be enchanted, if possible.\n\n")
    -- for name, _ in pairs(enchants) do
    --     print(name)
    -- end
    -- write("\n\nENCH_UI> ")
    -- local msg = read()
    -- if msg == nil then goto continue end
    -- local words = {}
    -- for word in msg:gmatch("%S+") do
    --     pcall(table.insert, words, word)
    -- end
    -- if not pcall(EnchantItem, words[1]) then print('EnchantItem() failed to complete') end
    -- ::continue::
    sleep(15)
end
