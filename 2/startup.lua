-- turn on rednet
sleep(120)

local local_modem = "bottom"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))

-- run services
local kiosk_id = shell.openTab("kiosk")
shell.openTab("empty_kiosk")
-- switch focus
shell.switchTab(kiosk_id)
