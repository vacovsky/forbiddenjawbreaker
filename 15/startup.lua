-- startup.lua

-- sleep(120)

local local_modem = "back"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))


shell.openTab("bullet_maker")
shell.openTab("nuggie_maker")
shell.openTab("advanced_composter")
