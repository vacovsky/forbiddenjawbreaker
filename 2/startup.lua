sleep(120)

local_modem = "back"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))

shell.openTab("botany_pots")
