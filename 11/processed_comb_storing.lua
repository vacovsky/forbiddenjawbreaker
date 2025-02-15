local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"
local sc = require "lib/sc"

local processed_outputs = 'enderstorage:ender_chest_10'

function CollectProcessedItems()
    local itemsMoved = 0
    local src = peripheral.wrap(processed_outputs)
    for slot, item in pairs(src.list()) do
        itemsMoved = itemsMoved + sc.push(processed_outputs, slot)
        -- itemsMoved = itemsMoved + whi.DepositInAnyWarehouse(processed_outputs, slot)
    end

    if itemsMoved > 0 then print(itemsMoved, 'xferred') end
end

while true do
    -- if not pcall(CollectProcessedItems) then print('CollectProcessedItems() failed to complete') end
    pcall(CollectProcessedItems)
    sleep(1)
end
