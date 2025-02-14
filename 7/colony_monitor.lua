---@diagnostic disable: need-check-nil
----------------------------------
local colonylib = require "lib/col"

-- CONFIGURATION SECTION
local REFRESH_TIME = 60

-- END CONFIGURATION SECTION
----------------------------------
local colony = peripheral.find("colonyIntegrator")
local monitor = peripheral.wrap("top")
-- local warehouse = peripheral.find("minecolonies:warehouse")

if monitor ~= nil then
    monitor.clear()
end

local buildings = nil
local citizens = nil
local requests = nil
local research = nil
local visitors = nil

function RefreshColonyInfo()
    buildings = colony.getBuildings()
    visitors = colony.getVisitors()
    
    if visitors == nil then
        visitors = 0
    end
    -- research = colony.getResearch()
    -- WriteToFile(json.encode(citizens), "citizens.json", "w")
    if monitor == nil then DisplayLatestColonyInfo() else displayLatestColonyInfoInMonitor() end
end

function WriteToFile(input, fileName, mode)
    local file = io.open(fileName, mode)
    io.output(file)
    io.write(input)
    io.close(file)
end

function DisplayOutOfRangeWarning()
    term.setBackgroundColor(colors.red) -- Set the background colour to black.
    term.clear()                        -- Paint the entire display with the current background colour.
    term.setCursorPos(0, 10)
    PrintWithFormat("&0!!!!!  OUT  OF  RANGE  !!!!")
end


function PrintWithFormat(...)
    local s = "&1"
    for k, v in ipairs(arg) do
        s = s .. v
    end
    s = s .. "&0"
    
    local fields = {}
    local lastcolor, lastpos = "0", 0
    for pos, clr in s:gmatch "()&(%x)" do
        table.insert(fields, { s:sub(lastpos + 2, pos - 1), lastcolor })
        lastcolor, lastpos = clr, pos
    end
    
    for i = 2, #fields do
        term.setTextColor(2 ^ (tonumber(fields[i][2], 16)))
        -- monitor.write(fields[i][1])
    end
end

------------------------CONSOLE-----------------
function DisplayLatestColonyInfo()
    term.setBackgroundColor(colors.black) -- Set the background colour to black.
    term.clear()                          -- Paint the entire display with the current background colour.
    term.setCursorPos(1, 1)
    
    -- local warehouseStats = colonylib.GetWarehouse()
    PrintWithFormat("&3", colony.getColonyName(), "(id:", colony.getColonyID() .. ")")
    print("==========================")
    
    PrintWithFormat("&0")
    
    print("Style: ", colony.getColonyStyle())
    print("Happiness:", string.format("%.2f", ((colony.getHappiness() * 10) / 10)), "/ 10")
    print("Citizens: ", colony.amountOfCitizens(), "/", colony.maxOfCitizens(), "|", colonylib.GetUnemployedCitizens())
    print("Visitors: ", #visitors, "~", colonylib.GetCheapVisitors())
    print("Buildings: ", #buildings, "~", colonylib.GetConstructionCount())
    print("Avg Bld. Lvl: ", colonylib.GetAverageBuildingLevel().avg, "/", colonylib.GetAverageBuildingLevel().total)
    
    -- local warehouseVal = string.format("%.2f",((warehouseStats.percentUsed * 10) / 10)) .. "% used"
    -- print("Warehouse Use: ", string.format("%.2f", ((warehouseStats.percentUsed * 10) / 10)) .. "%")
    
    
    -- print("Research:", getResearchedCount(), "/", #research)
    
    print()
    print()
    PrintWithFormat("&e!!!!!!!   Alerts   !!!!!!!")
    print("==========================")
    PrintWithFormat("&0")
    
    if colony.isUnderAttack() then
        PrintWithFormat("&e")
        print("- Colony under attack!")
        PrintWithFormat("&0")
    end
    
    local ibc, idleBuilders = colonylib.GetIdleBuilders()
    if colonylib.GetIdleBuilders() > 0 then
        PrintWithFormat("&4")
        print("-", ibc, "idle builders")
        for bni, bn in pairs(idleBuilders) do
            print("  -", bn)
        end
        PrintWithFormat("&0")
    end
    
    if colony.amountOfCitizens() + 2 >= colony.maxOfCitizens() then
        PrintWithFormat("&6")
        print("-", colony.maxOfCitizens() - colony.amountOfCitizens(), "open beds")
        PrintWithFormat("&0")
    end
    
    if colonylib.GetOpenRequestsCount() > 0 then
        PrintWithFormat("&4")
        print("-", getOpenRequestsCount(), "open requests")
        PrintWithFormat("&0")
    end
    
    if colonylib.GetGuardedBuildingsCount() < #buildings then
        PrintWithFormat("&4")
        print("-", #buildings - colonylib.GetGuardedBuildingsCount(), "unguarded buildings")
        PrintWithFormat("&0")
    end
    
    if colony.getHappiness() <= 8.5 then
        PrintWithFormat("&3")
        print("- Happiness is low:", string.format("%.2f", ((colony.getHappiness() * 10) / 10)))
        PrintWithFormat("&0")
    end
    
    local unstaffedBuildings, totalUnstaffed = colonylib.GetUnstaffedBuldingTypes()
    if totalUnstaffed > 0 then
        PrintWithFormat("&e")
        print("-", totalUnstaffed, "unstaffed buildings")
        for type, count in pairs(unstaffedBuildings) do
            print("  -", count, type)
        end
        PrintWithFormat("&0")
    end
    -- if colony.mourning then print("- Recent death") end
end

--------------------MONITOR---------------------
function RightJustify(input, line)
    monitor.setCursorPos(monitor.getSize() - string.len(input), line)
end

function displayLatestColonyInfoInMonitor()
    local line = 1
    monitor.setTextScale(1)
    monitor.clear()
    monitor.setCursorPos(1, line)
    monitor.setTextColor(8)
    monitor.write(colony.getColonyName())
    
    local colonyIdMsg = "id: " .. colony.getColonyID()
    monitor.setCursorPos(monitor.getSize() - string.len(colonyIdMsg), line)
    monitor.write("id:" .. colony.getColonyID())
    
    line = line + 1
    monitor.setCursorPos(1, line)
    monitor.write("=============================")
    
    line = line + 2
    monitor.setCursorPos(1, line)
    monitor.setTextColor(1)
    monitor.write("Style")
    RightJustify(colony.getColonyStyle(), line)
    monitor.write(colony.getColonyStyle())
    
    line = line + 1
    monitor.setCursorPos(1, line)
    monitor.setTextColor(1)
    monitor.write("Happiness")
    local happyValue = string.format("%.2f", ((colony.getHappiness() * 10) / 10)) .. " / 10"
    RightJustify(happyValue, line)
    monitor.write(happyValue)
    
    line = line + 1
    monitor.setCursorPos(1, line)
    monitor.setTextColor(1)
    monitor.write("Citizens")
    local citizenValues = tostring(colony.amountOfCitizens() ..
    " / " .. colony.maxOfCitizens() .. " | " .. colonylib.GetUnemployedCitizens())
    RightJustify(citizenValues, line)
    monitor.write(citizenValues)
    
    line = line + 1
    monitor.setCursorPos(1, line)
    monitor.setTextColor(1)
    monitor.write("Buildings")
    local buildingValues = tostring(#buildings .. " ~ " .. colonylib.GetConstructionCount())
    RightJustify(buildingValues, line)
    monitor.write(buildingValues)
    
    line = line + 1
    monitor.setCursorPos(1, line)
    monitor.setTextColor(1)
    monitor.write("Avg Bld Lvl")
    local moreBuildingValues = tostring(colonylib.GetAverageBuildingLevel().avg .. " / " .. colonylib.GetAverageBuildingLevel().total)
    RightJustify(moreBuildingValues, line)
    monitor.write(moreBuildingValues)
    
    
    line = line + 1
    monitor.setCursorPos(1, line)
    monitor.setTextColor(1)
    monitor.write("Visitors")
    local visitorValue = tostring(#visitors .. " ~ " .. colonylib.GetCheapVisitors())
    RightJustify(visitorValue, line)
    monitor.write(visitorValue)
    
    line = line + 3
    monitor.setCursorPos(1, line)
    monitor.setTextColor(16384)
    monitor.write("!!!!!!!!   Alerts   !!!!!!!!!")
    line = line + 1
    monitor.setCursorPos(1, line)
    monitor.write("=============================")
    line = line + 1
    
    if colony.isUnderAttack() then
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(16384)
        monitor.write("- Colony under attack!")
    end
    
    local ibc, idleBuilders = colonylib.GetIdleBuilders()
    if colonylib.GetIdleBuilders() > 0 then
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(16)
        monitor.write("- " .. ibc .. " idle builders")
        for bni, bn in pairs(idleBuilders) do
            line = line + 1
            monitor.setCursorPos(1, line)
            monitor.write("  - " .. bn)
        end
    end
    
    if colony.amountOfCitizens() + 2 >= colony.maxOfCitizens() then
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(64)
        monitor.write("- " .. colony.maxOfCitizens() - colony.amountOfCitizens() .. " open beds")
    end
    
    if colonylib.GetOpenRequestsCount() > 0 then
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(1)
        monitor.write("- " .. colonylib.GetOpenRequestsCount() .. " open requests")
    end
    
    if colonylib.GetGuardedBuildingsCount() < #buildings then
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(16)
        monitor.write("- " .. #buildings - colonylib.GetGuardedBuildingsCount() .. " unguarded buildings")
    end
    
    if colony.getHappiness() <= 8.5 then
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(8)
        monitor.write("- Happiness is low: " .. string.format("%.2f", ((colony.getHappiness() * 10) / 10)))
    end
    
    local unstaffedBuildings, totalUnstaffed = colonylib.GetUnstaffedBuldingTypes()
    if totalUnstaffed > 0 then
        line = line + 1
        monitor.setCursorPos(1, line)
        monitor.setTextColor(16384)
        monitor.write("- " .. totalUnstaffed .. " unstaffed buildings")
        for type, count in pairs(unstaffedBuildings) do
            line = line + 1
            monitor.setCursorPos(1, line)
            monitor.write("  - " .. count .. " " .. type)
        end
    end
    -- -- if colony.mourning then print("- Recent death") end
end


function Main()
    -- colonylib.GetWarehouse()
    if colony.isInColony() then
        RefreshColonyInfo()
    else
        DisplayOutOfRangeWarning()
    end
    return true
end

print('Starting colony stats board...')
while true do
    Main()
    -- pcall(Main)
    sleep(REFRESH_TIME)
end
