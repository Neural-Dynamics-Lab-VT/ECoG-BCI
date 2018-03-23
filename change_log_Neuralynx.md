#CHANGE LOG
###03.22.2018
1. Changed the ATLAS.cfg file in the configuration file.
	-> dataIP = 192.168.3.101 (previously 192.168.3.100)
	-> This was done because we changed the actual physical port in the CPU. Since the previous slot was assigned to 192.168.3.100, we could not assign the same IP to the new port, hence we selected the other IP address for the other port.
	
	** As soon as you change the slot for the network card, it is assigned a random address, so we have to manually go to network properties and make sure the HardwareIP (Atlas subsystem IP) and the DataIP(Network Card) would be in the same subnet mask, hence we have to use the 192.168.3.XXX address and the approproate subnet mask 255.255.255.0.
	
	TODO:: We have to check if the slot is damaged or if there was some issue in the network card itself.
