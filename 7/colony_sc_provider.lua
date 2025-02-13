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
            -- print(item.name)
            for _, wh in pairs(warehouses) do
                local aMove = sc.pull(item.name, request.count, true, wh, nil)
                if aMove > 0 then 
                    moved = moved + aMove
                    print("partial", aMove, request.name)
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
    sleep(30)
end

-- function WriteToFile(input, fileName, mode)
--     local file = io.open(fileName, mode)
--     io.output(file)
--     io.write(input)
--     io.close(file)
-- end

-- function serializeTable(val, name, skipnewlines, depth)
--     skipnewlines = skipnewlines or false
--     depth = depth or 0

--     local tmp = string.rep(" ", depth)

--     if name then tmp = tmp .. name .. " = " end

--     if type(val) == "table" then
--         tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

--         for k, v in pairs(val) do
--             tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
--         end

--         tmp = tmp .. string.rep(" ", depth) .. "}"
--     elseif type(val) == "number" then
--         tmp = tmp .. tostring(val)
--     elseif type(val) == "string" then
--         tmp = tmp .. string.format("%q", val)
--     elseif type(val) == "boolean" then
--         tmp = tmp .. (val and "true" or "false")
--     else
--         tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
--     end

--     return tmp
-- end

-- WriteToFile(serializeTable(colony.getRequests()), "requests.json", "w")

