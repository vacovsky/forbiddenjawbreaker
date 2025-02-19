sleep(120)

local local_modem = "back"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))


shell.openTab("source_stone_imbuer")
shell.openTab("ars_guard_provisioner")
