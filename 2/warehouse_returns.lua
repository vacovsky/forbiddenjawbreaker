local DROPBOX = 'minecraft:barrel_2'

local whi = require 'lib/whi'
local var = require 'lib/constants'

function ReturnWares()
    dropbox = peripheral.wrap(DROPBOX)
    count = 0
    for slot, item in pairs(dropbox.list()) do
        count = count + whi.DepositInAnyWarehouse(DROPBOX, slot)
        print('Returned', count, 'items')
    end
    return true
end

print('Starting automated warehouse return system...')
while true do
    -- if not pcall(ReturnWares) then print('ReturnWares() failed to complete') end
    ReturnWares()
    sleep(120)
end