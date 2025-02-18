-- startup.lua
sleep(120)
local local_modem = "back"
rednet.open(local_modem)
rednet.host("storage_client", ("%s"):format(os.getComputerID()))


shell.openTab("fuel_generators")
shell.openTab("powered_furnace_attendant")
-- shell.openTab("lava_bucket")





-- shell.openTab("honey_power")
-- shell.openTab("gene_collector")
-- shell.openTab("mycelial_generator")

-- shell.openTab("hive_collector")
-- shell.openTab("honey_depositer")
-- shell.openTab("hive_manager")

-- shell.openTab("fuge_loader")
-- shell.openTab("fuge_unloader")

-- shell.openTab("honey_spout_filler")
-- shell.openTab("breeder_power_fuel")
