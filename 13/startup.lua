-- startup.lua
-- storage_controller
local constants = require "lib/constants"
local bm = require "lib/bm"

local local_modem = "top"
local internal_modem = "back"
local display_name = "monitor_2"

-- start rednet
rednet.host("storage_controller", ("%s"):format(os.getComputerID()))
rednet.open(local_modem)

-- start services
print("starting returns_service")
shell.openTab("returns_service", internal_modem)
print("bm.init() start")
bm.init()
print("bm.init() end")
shell.openTab("request_router", internal_modem)
shell.openTab("display_service", display_name)
shell.openTab("warehouse_scoreboard", display_name)
