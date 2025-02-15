local net = require 'lib/network'

-- CONFIGURATION SECTION
local POWER_BANK = '_capacitor_bank_'
local MOTOR_DIRECTION = "top"
local POLLING_INTERVAL = 3
local GEN_STATE = false

function GeneratorController()
    local data = {
        energy_capacity = 0,
        energy_stored = 0
    }
    for _, batt in pairs(net.ListMatchingDevices(POWER_BANK)) do
        local powerPeripheral = peripheral.wrap(batt)
        data.energy_capacity = data.energy_capacity + powerPeripheral.getEnergyCapacity()
        data.energy_stored = data.energy_stored + powerPeripheral.getEnergy()
    end

    if data.energy_capacity / 2 > data.energy_stored then
        redstone.setOutput(MOTOR_DIRECTION, true)
        if not GEN_STATE then
            print("Generator activated", data.energy_stored, data.energy_capacity)
        end
        GEN_STATE = true
    else
        if GEN_STATE then
            redstone.setOutput(MOTOR_DIRECTION, false)
            print("Generator deactivated", data.energy_stored, data.energy_capacity)
        end
        GEN_STATE = false
    end
end


while true do
    if not pcall(GeneratorController) then print('GeneratorController() failed to complete') end
    sleep(POLLING_INTERVAL)
end