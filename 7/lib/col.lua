local colonylib = {
    _version = '0.0.2'
}
local json = require "lib/json"
local net = require "lib/network"

local DEVICES = {}
local CHEAP_VISITORS_WANT = {"minecraft:hay_block", "minecraft:sunflower", "minecraft:cactus", "minecraft:gold_ingot",
                             "minecraft:iron_ingot"}

function colonylib.LoadDevices()
    for k, v in pairs(peripheral.getNames()) do
        DEVICES[v] = peripheral.getMethods(v)
    end
    -- colonylib.WriteToFile(json.encode(DEVICES), "devices.json", "w")
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function colonylib.GetSickCitizenCount()
    local ci = peripheral.find('colonyIntegrator')
    -- colonylib.WriteToFile(json.encode(ci.getCitizens()), 'cits.json', 'w')
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
        if cit.state == 'Sick' then
            counter = counter + 1
        end
    end
    return counter
end

function colonylib.GetSleepingCitizenCount()
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
        if cit.isAsleep or cit.state == 'Sleeping zZZ' then
            counter = counter + 1
        end
    end
    return counter
end


function colonylib.GetDeliveringCitizenCount()
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
        if cit.isAsleep or cit.state == 'Delivering' then
            counter = counter + 1
        end
    end
    return counter
end


function colonylib.GetDissatisfiedCitizenCount()
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
        if cit.betterFood then
            counter = counter + 1
        end
    end
    return counter
end


function colonylib.GetHungryCitizenCount()
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
        if cit.betterFood then
            counter = counter + 1
        end
    end
    return counter
end


function colonylib.GetIdleCitizenCount()
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
        if cit.state == "Idle" then
            counter = counter + 1
        end
    end
    return counter
end


function colonylib.GetWorkingCitizenCount()
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
        if cit.state == "Working" or cit.state == "Delivering" or cit.state == "Mining" then
            counter = counter + 1
        end
    end
    return counter
end


function colonylib.GetCitizenHappiness()
    local happiness = 0
    local counter = 0
    local ci = peripheral.find('colonyIntegrator')
    for _, cit in pairs(ci.getCitizens()) do
            happiness  = happiness + cit.happiness
            counter = counter + 1
    end
    return happiness / counter
end

function colonylib.WriteToFile(input, fileName, mode)
    local file = io.open(fileName, mode)
    io.output(file)
    io.write(input)
    io.close(file)
end

function colonylib.Tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function colonylib.GetStatusOfAttachedDevices()
    local MM = {}
    local device = peripheral.find("colonyIntegrator")
    for _, method in pairs(device) do
        -- TODO make whitelist or blacklist for methods and devices
        if method == "amountOfCitizens" or method == "getHappiness" or method == "maxOfCitizens" or method ==
            "getCitizens" or method == "isUnderAttack" or method == "isUnderRaid" or method == "getRequests" or method ==
            "getBuildings" or method == "getVisitors" or method == "getWorkOrders" then
            local result = device[method]()
            print(device, method, result)

            if method == "getBuildings" or method == "getRequests" or method == "getWorkOrders" or method ==
                "getVisitors" then
                local count = 0
                for _, item in pairs(result) do
                    count = count + 1
                end
                result = count
            end
        end
    end

    MM['getCitizenHappiness'] = colonylib.GetCitizenHappiness()
    MM['getRequests'] = colonylib.GetOpenRequestsCount()
    MM['getWorkOrders'] = colonylib.GetOpenWorkOrdersCount()
    MM['getHungryCitizens'] = colonylib.GetHungryCitizenCount()
    MM['getIdleCitizens'] = colonylib.GetIdleCitizenCount()
    MM['geDeliveringCitizens'] = colonylib.GetDeliveringCitizenCount()
    MM['getDissatisfiedCitizens'] = colonylib.GetDissatisfiedCitizenCount()
    MM['getWorkingCitizens'] = colonylib.GetWorkingCitizenCount()
    MM['getSleepingCitizens'] = colonylib.GetSleepingCitizenCount()
    MM['getCitizens'] = colonylib.GetCitizens()
    MM['getSickCitizens'] = colonylib.GetSickCitizenCount()
    _, MM['unstaffedBuldingCount'] = colonylib.GetUnstaffedBuldingTypes()
    MM['activeResearchCount'] = colonylib.GetActiveResearchCount()
    MM['finishedResearchCount'] = colonylib.GetCompletedResearchCount()
    MM['unguardedBuildingCount'] = colonylib.GetUnguardedBuildingsCount()
    MM['guardedBuildingCount'] = colonylib.GetGuardedBuildingsCount()
    MM['getAverageBuildingLevel'] = tonumber(colonylib.GetAverageBuildingLevel().avg)

    return MM
end

function colonylib.GetConstructionCount()
    local buildings = peripheral.find('colonyIntegrator').getBuildings()
    local count = 0
    for k, v in pairs(buildings) do
        if not v.built then
            count = count + 1
        end
    end
    return count
end

function colonylib.GetCheapVisitors()
    local visitors = peripheral.find('colonyIntegrator').getVisitors()
    local count = 0
    for k, v in pairs(visitors) do
        for i, p in pairs(CHEAP_VISITORS_WANT) do
            if p == v.recruitCost.name then
                count = count + 1
            end
        end
    end
    return count
end

function colonylib.GetUnemployedCitizens()
    local count = 0
    local citizens = peripheral.find('colonyIntegrator').getCitizens()
    -- WriteToFile(json.encode(citizens), "citizens.json", "w")
    for k, v in pairs(citizens) do
        if v.work ~= nil and (v.work.job == "com.minecolonies.job.student" or v.work.job == nil) then
            count = count + 1
        end
    end
    return count
end


function colonylib.GetCitizens()
    local count = 0
    local citizens = peripheral.find('colonyIntegrator').getCitizens()
    return #citizens
end


function colonylib.GetActiveResearchCount()
    local research = peripheral.find('colonyIntegrator').getResearch()
    local count = 0
    for k, v in pairs(research) do
        if v.status == "IN_PROGRESS" then
            count = count + 1
        end
    end
    -- colonylib.WriteToFile(json.encode(research), "research.json", "w")

    return count
end

function colonylib.GetCompletedResearchCount()
    local research = peripheral.find('colonyIntegrator').getResearch()
    local count = 0
    for k, v in pairs(research) do
        if v.status == "FINISHED" then
            count = count + 1
        end
    end
    -- colonylib.WriteToFile(json.encode(research), "research.json", "w")

    return count
end

function colonylib.GetAverageBuildingLevel() -- actual, possible
    local buildings = peripheral.find('colonyIntegrator').getBuildings()
    local actualTotal = 0
    local maxTotal = 0
    local count = 0
    for k, b in pairs(buildings) do
        if b.maxLevel > 0 then
            count = count + 1
            maxTotal = maxTotal + b.maxLevel
            actualTotal = actualTotal + b.level
        end
    end
    return {
        avg = string.format("%.2f", ((actualTotal / count))),
        total = string.format("%.2f", ((maxTotal / count)))
    }
end

function colonylib.GetUnstaffedBuldingTypes()
    local buildings = peripheral.find('colonyIntegrator').getBuildings()
    local buildingTypes = {}
    local count = 0
    for k, b in pairs(buildings) do
        if b.type ~= "residence" and b.type ~= "mysticalsite" and b.type ~= "barracks" and b.type ~= "warehouse" and
            b.type ~= "townhall" then
            if b.level > 0 and #b.citizens == 0 then
                count = count + 1
                if buildingTypes[b.type] ~= nil then
                    -- print(b.type, buildingTypes[b.type])
                    buildingTypes[b.type] = buildingTypes[b.type] + 1
                else
                    buildingTypes[b.type] = 1
                end
            end
        end
    end
    return buildingTypes, count
end

function colonylib.GetGuardedBuildingsCount()
    local buildings = peripheral.find('colonyIntegrator').getBuildings()
    local count = 0
    for k, v in pairs(buildings) do
        if v.guarded then
            count = count + 1
        end
    end
    return count
end

function colonylib.GetUnguardedBuildingsCount()
    local buildings = peripheral.find('colonyIntegrator').getBuildings()
    local count = 0
    for k, v in pairs(buildings) do
        if v.guarded then
            count = count + 1
        end
    end
    return #buildings - count
end

function colonylib.GetResearchedCount()
    local research = peripheral.find('colonyIntegrator').getResearch()
    local count = 0
    for k, v in pairs(research) do
        print(v.status)
        -- if not v.built then constructionSites = constructionSites + 1 end
    end
    return count
end

function colonylib.GetOpenRequestsCount()
    local requests = peripheral.find('colonyIntegrator').getRequests()
    local count = 0
    for k, v in pairs(requests) do
        count = count + 1
    end
    return count
end


function colonylib.GetOpenWorkOrdersCount()
    local requests = peripheral.find('colonyIntegrator').getWorkOrders()
    local count = 0
    for k, v in pairs(requests) do
        count = count + 1
    end
    return count
end

function colonylib.GetWarehouse()
    local result = {
        total = 0,
        used = 0,
        percentUsed = 0.0
    }
    local peripherals = peripheral.getNames()
    for _, per in pairs(peripherals) do
        if string.find(per, "minecolonies:warehouse") then
            local wh = peripheral.wrap(per)
            if wh ~= nil then
                result.total = result.total + wh.size()
                result.used = result.used + #wh.list()
            end
        end
    end
    result.percentUsed = (result.used / result.total) * 100
    return result
end

function colonylib.GetIdleBuilders()
    local citizens = peripheral.find('colonyIntegrator').getCitizens()
    local idleBuilders = {}
    local count = 0
    for k, v in pairs(citizens) do
        if v.work ~= nil and (v.work.job == "com.minecolonies.job.builder" and v.isIdle) then
            count = count + 1
            table.insert(idleBuilders, v.name)
        end
    end
    return count, idleBuilders
end

print("Loading devices.")
colonylib.LoadDevices()
print(colonylib.Tablelength(DEVICES) .. " Devices loaded.")

return colonylib
