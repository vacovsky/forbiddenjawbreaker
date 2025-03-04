local json = require "lib/json"
local vars = require "lib/constants"

local combs_source = 'enderstorage:ender_chest_1'

function ListCentrifuges()
    local fuge_list = {}
    local peripherals = peripheral.getNames()
    for _, attached_peripheral in pairs(peripherals) do
        if string.find(attached_peripheral, vars.fuges) then
            fuge_list[#fuge_list + 1] = attached_peripheral
        end
    end
    return fuge_list
end

while true do
    local combsMoved = 0
    for _, fuge in pairs(ListCentrifuges()) do
        local pfuge = peripheral.wrap(fuge)
        local pcombsrc = peripheral.wrap(combs_source)
        for slot, item in pairs(pcombsrc.list()) do
            if string.find(item.name, 'productivebees:') then
                pfuge.pullItems(combs_source, slot)
            end
        end
    end

    if combsMoved > 0 then print('Tranferred', combsMoved, 'combs') end
    sleep(5)
end
