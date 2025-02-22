local whi = require "lib/whi"
local net = require "lib/network"
local sc = require 'lib/sc'


local avanced_composter_input = 'sophisticatedstorage:chest_94'
local input_item = 'minecraft:wheat_seeds'

function LoadComposter()
    -- add compostable items
    local input_count = 0
    input_count = input_count + sc.pull(input_item, 64, true, avanced_composter_input)
    if input_count > 0 then print(input_count, 'inputs') end
end

while true do
    if not pcall(LoadComposter) then print('LoadComposter() failed to complete') end
    -- LoadComposter()
    sleep(15)
end