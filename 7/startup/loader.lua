

local local_modem = "bottom"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))



shell.openTab("data_output")
shell.openTab("colony_monitor")


sleep(120)
shell.openTab("colony_sc_provider")
