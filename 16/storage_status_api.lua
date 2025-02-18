
local whi = require 'lib/whi'

while true do
    local id, message = rednet.receive("storage_status_api")
    if message == 'item_count_map' then
        print(id .. ':', message)
        rednet.send(id, whi.ItemCountMap())
    end
end