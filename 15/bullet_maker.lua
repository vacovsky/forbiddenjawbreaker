local json = require "lib/json"
local whi = require 'lib/whi'
local tsdb = require 'lib/tsdb'
local net = require 'lib/network'
local sc = require 'lib/sc'

local COLONY_NAME = 'Nolins'

-- 1, 2, 3 are input slots
-- 4 is mold
-- 5 is fuel slot
-- 6 is output
local casing = 'scguns:medium_copper_casing'
local powder = 'scguns:gunpowder_dust'
local slug = 'minecraft:iron_nugget'
-- local fuel = 'minecraft:coal'

local gunpress = 'scguns:powered_mechanical_press'
local turret = 'scguns:basic_turret'
local shellcatcher = 'scguns:shell_catcher_module'

function MakeBullets()
    local bullets_made = 0
    local turrets = {}
    local gunpresses = {}
    local shellcatchers = {}

    gunpresses = net.ListMatchingDevices(gunpress)
    turrets = net.ListMatchingDevices(turret)
    shellcatchers = net.ListMatchingDevices(shellcatcher)
    turrets[#turrets+1] = 'enderstorage:ender_chest_11'

    -- MOVE EMPTY CASINGS TO WAREHOUSE
    for _, t in pairs(shellcatchers) do
        -- print(t)
        local sc = peripheral.wrap(t)
        for slot, item in pairs(sc.list()) do
            if string.find(item.name, casing) then
                -- whi.DepositInAnyWarehouse(t, slot)
                sc.push(t, slot)
            end
        end
    end

    for _, p in pairs(gunpresses) do
        -- FILL PRESSES WITH INGREDIENTS FOR scguns:standard_copper_round
        -- whi.GetFromAnyWarehouse(false, casing, p, 64, 1)
        sc.pull(casing, 64, true, p, 1)
        -- whi.GetFromAnyWarehouse(false, powder, p, 64, 2)
        sc.pull(powder, 64, true, p, 2)
        -- whi.GetFromAnyWarehouse(false, slug, p, 64, 3)
        sc.pull(slug, 64, true, p, 3)

        -- SEND FINISHED ROUNDS TO TURRETS
        for _, t in pairs(turrets) do
            bullets_made = bullets_made + peripheral.wrap(t).pullItems(p, 5)
        end
    end

    local data = {
        bulletsMadeCount = bullets_made
    }

    tsdb.WriteOutput("ForbiddenJawbreaker:MerlinsButthair", "guns", data, 'bulletUse.json')

    if bullets_made > 0 then
        print(bullets_made, 'Standard Copper Round')
    end
end

print("starting bullet maker")
while true do
    -- if not pcall(MakeBullets) then print('MakeBullets() failed to complete') end
    MakeBullets()
    sleep(5)
end