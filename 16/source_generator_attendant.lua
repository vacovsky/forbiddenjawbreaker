local net = require 'lib/network'


local pedestal = "pedestal"
local barrels_str = "barrel"

function consumeBerries()
    local barrels = net.ListMatchingDevices(barrels_str)
    local peds = net.ListMatchingDevices(pedestal)
    for _, barrel in pairs(barrels) do
        local pbarrel = peripheral.wrap(barrel)
        for slot, item in pairs(pbarrel.list()) do
            for _, ped in pairs(peds) do
                local p = peripheral.wrap(ped)
                p.pullItems(barrel, slot)
            end
        end
    end
end

while true do
    if not pcall(consumeBerries) then print('consumeBerries() failed to complete') end

    -- consumeBerries()
    sleep(1)
end