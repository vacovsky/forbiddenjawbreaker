local pudding = require "pudding"

colony = peripheral.wrap("back")

citizens = colony.getCitizens()

citizen_name = "Kehlani"

for _, citizen in pairs(citizens) do
    if string.find(citizen.name, citizen_name) then
        pudding.printTable(citizen, "fffff")
        l = citizen.location
        print(l.x, l.y, l.z)
        for k, v in pairs(citizen.work) do
            print(k,v)
        end
    end
end
