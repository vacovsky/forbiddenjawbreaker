local net = require 'lib/network'

-- CONFIGURATION SECTION
local POWER_BANK = '_capacitor_bank_'
local MOTOR_DIRECTION = "top"
local POLLING_INTERVAL = 30
local GEN_STATE = true
local BATTERY_MODIFIER = 0.9

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

    -- print("Current Power", data.energy_stored, data.energy_capacity)


    if data.energy_capacity * BATTERY_MODIFIER > data.energy_stored then
        if not GEN_STATE then
            print("Generator activated", data.energy_stored, data.energy_capacity)
            GEN_STATE = true
        end
        redstone.setOutput(MOTOR_DIRECTION, true)
    else
        if GEN_STATE then
            print("Generator deactivated", data.energy_stored, data.energy_capacity)
            GEN_STATE = false
        end
        redstone.setOutput(MOTOR_DIRECTION, false)
    end
end

print("Starting GENERATOR_CONTROLLER")
while true do
    if not pcall(GeneratorController) then print('GeneratorController() failed to complete') end
    sleep(POLLING_INTERVAL)
end