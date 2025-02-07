-- Specific to colony integrator
local colony = require "lib/col"
local tsdb = require 'lib/tsdb'

local WAIT_SECONDS = 120

--------------------------

print("Beginning monitor loop.")

local loopCounter = 0

while true do
    loopCounter = loopCounter + 1
    print("Loop " .. loopCounter .. " started.")
    local last = colony.GetStatusOfAttachedDevices()

    tsdb.WriteOutput("ForbiddenJawbreaker:MerlinsButthair", "colony", last, "colony.json")

    print("Loop " .. loopCounter .. " finished. Next pass in " .. WAIT_SECONDS .. " seconds.")
    sleep(WAIT_SECONDS)
end
