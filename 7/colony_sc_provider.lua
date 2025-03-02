local tsdb = require 'lib/tsdb'
local sc = require "lib/sc"
local net = require "lib/network"

local colony = peripheral.find("colonyIntegrator")
local COLONY_WAREHOUSE = "minecolonies:warehouse"

function FullfillColonyRequests()
    local warehouses = net.ListMatchingDevices(COLONY_WAREHOUSE)
    -- TODO add cache because this searching will take forever

    local requests = colony.getRequests()
    print("procesing", #requests, "requests")
    for _, request in pairs(requests) do
        local moved = 0
        for _, item in pairs(request.items) do
            for _, wh in pairs(warehouses) do
                local aMove = sc.pull(item.name, request.count * 5, true, wh, nil)
                if aMove > 0 then
                    moved = moved + aMove
                    print("partial:", aMove, item.displayName)
                end
            end
            if moved == request.count then
                goto breakout
            end

        end
        -- found everything, go to next req
        ::breakout::
        if moved == request.count then
            print("xfer", moved, request.name)
        elseif moved > 0 and moved ~= request.count then
            print(request.name, "found", moved, "of", request.count)
        else
            -- print(request.name, "not found")
        end
    end
end



while true do
    FullfillColonyRequests()
    sleep(15)
end