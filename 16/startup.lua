-- startup.lua
local local_modem = "back"
local ender_modem = "top"

-- -- start rednet
rednet.host("storage_status_api", ("%s"):format(os.getComputerID()))
rednet.open(ender_modem)
-- rednet.open(local_modem)

-- -- start services
shell.openTab("storage_status_api")

