#define FUEL_NONE   0
#define FUEL_GASOLINA   1
#define FUEL_DIESEL   2

new sgstr[256];
#define SendClientMessageF(%1,%2,%3) SendClientMessage(%1, %2, (format(sgstr, sizeof(sgstr), %3), sgstr))
enum E_VEHICLE_CORE_DATA
{
	bool:vdata_windows,
	vdata_seatcount,
	vdata_fueltype,
	vdata_trunklimit
}

new CoreVehicleData[212][E_VEHICLE_CORE_DATA] =
{
	//Windows  	Seats 	Fuel Type   	Trunk Limit
	{true,		4,		FUEL_DIESEL,	5}, //Landstalker
	{true,		2,		FUEL_GASOLINA,	4}, //Bravura
	{true,		2,		FUEL_GASOLINA,	3}, //Buffalo
	{true,		2,		FUEL_DIESEL,	0}, //Linerunner
	{true,		4,		FUEL_GASOLINA,	5}, //Perenial
	{true,		4,		FUEL_GASOLINA,	4}, //Sentinel
	{true,		1,		FUEL_DIESEL,	0}, //Dumper
	{true,		2,		FUEL_DIESEL,	8}, //Firetruck
	{true,		2,		FUEL_DIESEL,	8}, //Trashmaster
	{true,		4,		FUEL_GASOLINA,	4}, //Stretch
	{true,		2,		FUEL_GASOLINA,	3}, //Manana
	{true,		2,		FUEL_GASOLINA,	2}, //Infernus
	{true,		2,		FUEL_GASOLINA,	3}, //Voodoo
	{true,		4,		FUEL_DIESEL,	10}, //Pony
	{true,		2,		FUEL_DIESEL,	10}, //Mule
	{true,		2,		FUEL_GASOLINA,	2}, //Cheetah
	{true,		4,		FUEL_DIESEL,	8}, //Ambulance
	{true,		2,		FUEL_GASOLINA,	10}, //Leviathan
	{true,		4,		FUEL_GASOLINA,	9}, //Moonbeam
	{true,		2,		FUEL_GASOLINA,	4}, //Esperanto
	{true,		4,		FUEL_GASOLINA,	3}, //Taxi
	{true,		4,		FUEL_GASOLINA,	3}, //Washington
	{true,		2,		FUEL_DIESEL,	6}, //Bobcat
	{true,		2,		FUEL_DIESEL,	8}, //Mr Whoopee
	{false,		2,		FUEL_DIESEL,	1}, //BF Injection
	{true,		1,		FUEL_GASOLINA,	0}, //Hunter
	{true,		4,		FUEL_GASOLINA,	3}, //Premier
	{true,		4,		FUEL_DIESEL,	9}, //Enforcer
	{true,		4,		FUEL_DIESEL,	9}, //Securicar
	{true,		2,		FUEL_GASOLINA,	2}, //Banshee
	{false,		1,		FUEL_GASOLINA,	0}, //Predator
	{false,		8,		FUEL_DIESEL,	8}, //Bus
	{false,		1,		FUEL_DIESEL,	0}, //Rhino
	{true,		2,		FUEL_DIESEL,	10}, //Barracks
	{true,		2,		FUEL_GASOLINA,	2}, //Hotknife
	{false,		1,		FUEL_NONE,		10}, //Artigo Trailer
	{true,		2,		FUEL_GASOLINA,	3}, //Previon
	{false,		8,		FUEL_DIESEL,	8}, //Coach
	{true,		4,		FUEL_GASOLINA,	3}, //Cabbie
	{true,		2,		FUEL_GASOLINA,	3}, //Stallion
	{true,		4,		FUEL_DIESEL,	9}, //Rumpo
	{false,		1,		FUEL_GASOLINA,	0}, //RC Bandit
	{true,		2,		FUEL_GASOLINA,	8}, //Romero
	{true,		2,		FUEL_DIESEL,	0}, //Packer
	{true,		2,		FUEL_DIESEL,	7}, //Monster
	{true,		4,		FUEL_GASOLINA,	4}, //Admiral
	{false,		1,		FUEL_GASOLINA,	0}, //Squallo
	{true,		2,		FUEL_GASOLINA,	0}, //Seasparrow
	{false,		1,		FUEL_GASOLINA,	1}, //Pizzaboy
	{false,		1,		FUEL_GASOLINA,	0}, //Tram
	{false,		1,		FUEL_NONE,		10}, //Artigo Trailer 2
	{true,		2,		FUEL_GASOLINA,	2}, //Turismo
	{false,		1,		FUEL_GASOLINA,	0}, //Speeder
	{false,		1,		FUEL_GASOLINA,	0}, //Reefer
	{false,		1,		FUEL_GASOLINA,	0}, //Tropic
	{true,		2,		FUEL_DIESEL,	10}, //Flatbed
	{true,		2,		FUEL_DIESEL,	10}, //Yankee
	{false,		2,		FUEL_GASOLINA,	1}, //Caddy
	{true,		4,		FUEL_GASOLINA,	4}, //Solair
	{true,		4,		FUEL_DIESEL,	8}, //Berkley's RC Van
	{true,		2,		FUEL_GASOLINA,	0}, //Skimmer
	{false,		1,		FUEL_GASOLINA,	1}, //PCJ-600
	{false,		1,		FUEL_GASOLINA,	1}, //Faggio
	{false,		1,		FUEL_GASOLINA,	1}, //Freeway
	{false,		1,		FUEL_GASOLINA,	0}, //RC Baron
	{false,		1,		FUEL_GASOLINA,	0}, //RC Raider
	{true,		4,		FUEL_GASOLINA,	3}, //Glendale
	{true,		4,		FUEL_GASOLINA,	3}, //Oceanic
	{false,		1,		FUEL_GASOLINA,	1}, //Sanchez
	{true,		2,		FUEL_GASOLINA,	0}, //Sparrow
	{true,		4,		FUEL_DIESEL,	7}, //Patriot
	{false,		2,		FUEL_GASOLINA,	1}, //Quad
	{false,		1,		FUEL_GASOLINA,	0}, //Coastguard
	{false,		1,		FUEL_GASOLINA,	0}, //Dinghy
	{true,		2,		FUEL_GASOLINA,	3}, //Hermes
	{true,		2,		FUEL_GASOLINA,	2}, //Sabre
	{false,		1,		FUEL_GASOLINA,	0}, //Rustler
	{true,		2,		FUEL_GASOLINA,	2}, //ZR-350
	{true,		2,		FUEL_DIESEL,	5}, //Walton
	{true,		4,		FUEL_DIESEL,	4}, //Regina
	{true,		2,		FUEL_GASOLINA,	2}, //Comet
	{false,		1,		FUEL_NONE,		0}, //BMX
	{true,		4,		FUEL_DIESEL,	10}, //Burrito
	{true,		3,		FUEL_DIESEL,	9}, //Camper
	{false,		1,		FUEL_GASOLINA,	0}, //Marquis
	{false,		1,		FUEL_GASOLINA,	0}, //Baggage
	{false,		1,		FUEL_DIESEL,	0}, //Dozer
	{true,		4,		FUEL_GASOLINA,	5}, //Maverick
	{true,		2,		FUEL_GASOLINA,	4}, //SAN News Maverick
	{true,		2,		FUEL_DIESEL,	4}, //Rancher
	{true,		4,		FUEL_DIESEL,	7}, //FBI Rancher
	{true,		2,		FUEL_GASOLINA,	3}, //Virgo
	{true,		4,		FUEL_GASOLINA,	3}, //Greenwood
	{false,		1,		FUEL_GASOLINA,	0}, //Jetmax
	{false,		2,		FUEL_GASOLINA,	2}, //Hotring Racer
	{true,		2,		FUEL_DIESEL,	4}, //Sandking
	{true,		2,		FUEL_GASOLINA,	3}, //Blista Compact
	{true,		4,		FUEL_GASOLINA,	5}, //Police Maverick
	{true,		4,		FUEL_DIESEL,	8}, //Boxville
	{true,		2,		FUEL_DIESEL,	8}, //Benson
	{true,		2,		FUEL_DIESEL,	2}, //Mesa
	{false,		1,		FUEL_GASOLINA,	0}, //RC Goblin
	{false,		2,		FUEL_GASOLINA,	2}, //Hotring Racer
	{false,		2,		FUEL_GASOLINA,	2}, //Hotring Racer
	{false,		2,		FUEL_GASOLINA,	3}, //Bloodring Banger
	{true,		2,		FUEL_DIESEL,	4}, //Rancher
	{true,		2,		FUEL_GASOLINA,	2}, //Super GT
	{true,		4,		FUEL_GASOLINA,	4}, //Elegant
	{true,		2,		FUEL_DIESEL,	10}, //Journey
	{false,		1,		FUEL_NONE,		0}, //Bike
	{false,		1,		FUEL_NONE,		0}, //Mountain Bike
	{true,		2,		FUEL_GASOLINA,	0}, //Beagle
	{true,		1,		FUEL_GASOLINA,	0}, //Cropduster
	{true,		1,		FUEL_GASOLINA,	0}, //Stuntplane
	{true,		2,		FUEL_DIESEL,	0}, //Tanker
	{true,		2,		FUEL_DIESEL,	0}, //Roadtrain
	{true,		4,		FUEL_GASOLINA,	3}, //Nebula
	{true,		2,		FUEL_GASOLINA,	3}, //Majestic
	{true,		2,		FUEL_GASOLINA,	3}, //Buccaneer
	{false,		1,		FUEL_GASOLINA,	0}, //Shamal
	{false,		1,		FUEL_GASOLINA,	0}, //Hydra
	{false,		2,		FUEL_GASOLINA,	1}, //FCR-900
	{false,		2,		FUEL_GASOLINA,	1}, //NRG-500
	{false,		2,		FUEL_GASOLINA,	1}, //Cop Bike HPV1000
	{true,		2,		FUEL_DIESEL,	0}, //Cement Truck
	{true,		2,		FUEL_DIESEL,	0}, //Towtruck
	{true,		2,		FUEL_GASOLINA,	2}, //Fortune
	{true,		2,		FUEL_GASOLINA,	2}, //Cadrona
	{true,		2,		FUEL_DIESEL,	6}, //FBI Truck
	{true,		4,		FUEL_GASOLINA,	3}, //Willard
	{false,		1,		FUEL_DIESEL,	0}, //Forklift
	{false,		1,		FUEL_DIESEL,	0}, //Tractor
	{true,		1,		FUEL_DIESEL,	0}, //Combine Harvester
	{true,		2,		FUEL_GASOLINA,	3}, //Feltzer
	{true,		2,		FUEL_GASOLINA,	4}, //Remington
	{true,		2,		FUEL_DIESEL,	4}, //Slamvan
	{true,		2,		FUEL_GASOLINA,	3}, //Blade
	{false,		1,		FUEL_DIESEL,	0}, //Freight (Train)
	{false,		1,		FUEL_DIESEL,	0}, //Brownstreak (Train)
	{false,		1,		FUEL_GASOLINA,	0}, //Vortex
	{true,		4,		FUEL_GASOLINA,	3}, //Vincent
	{true,		2,		FUEL_GASOLINA,	2}, //Bullet
	{true,		2,		FUEL_GASOLINA,	3}, //Clover
	{true,		2,		FUEL_DIESEL,	5}, //Sadler
	{true,		2,		FUEL_DIESEL,	10}, //Firetruck LA
	{true,		2,		FUEL_GASOLINA,	3}, //Hustler
	{true,		4,		FUEL_GASOLINA,	3}, //Intruder
	{true,		4,		FUEL_GASOLINA,	3}, //Primo
	{false,		2,		FUEL_GASOLINA,	10}, //Cargobob
	{true,		2,		FUEL_GASOLINA,	3}, //Tampa
	{true,		4,		FUEL_GASOLINA,	3}, //Sunrise
	{true,		4,		FUEL_GASOLINA,	3}, //Merit
	{true,		2,		FUEL_DIESEL,	6}, //Utility Van
	{false,		1,		FUEL_GASOLINA,	8}, //Nevada
	{true,		2,		FUEL_DIESEL,	6}, //Yosemite
	{true,		2,		FUEL_GASOLINA,	2}, //Windsor
	{true,		2,		FUEL_DIESEL,	5}, //Monster "A"
	{true,		2,		FUEL_DIESEL,	5}, //Monster "B"
	{true,		2,		FUEL_GASOLINA,	3}, //Uranus
	{true,		2,		FUEL_GASOLINA,	3}, //Jester
	{true,		4,		FUEL_GASOLINA,	4}, //Sultan
	{true,		4,		FUEL_GASOLINA,	4}, //Stratum
	{true,		2,		FUEL_GASOLINA,	3}, //Elegy
	{false,		2,		FUEL_GASOLINA,	10}, //Raindance
	{false,		1,		FUEL_GASOLINA,	0}, //RC Tiger
	{true,		2,		FUEL_GASOLINA,	3}, //Flash
	{true,		4,		FUEL_GASOLINA,	3}, //Tahoma
	{true,		4,		FUEL_GASOLINA,	3}, //Savanna
	{false,		1,		FUEL_GASOLINA,	0}, //Bandito
	{false,		1,		FUEL_NONE,		0}, //Freight Flat Trailer (Train)
	{false,		4,		FUEL_NONE,		0}, //Streak Trailer (Train)
	{false,		1,		FUEL_GASOLINA,	0}, //Kart
	{false,		1,		FUEL_DIESEL,	0}, //Mower
	{true,		2,		FUEL_DIESEL,	8}, //Dune
	{true,		1,		FUEL_DIESEL,	0}, //varrerer
	{true,		2,		FUEL_GASOLINA,	3}, //Broadway
	{true,		2,		FUEL_GASOLINA,	3}, //Tornado
	{false,		1,		FUEL_GASOLINA,	8}, //AT400
	{true,		2,		FUEL_DIESEL,	0}, //DFT-30
	{true,		4,		FUEL_DIESEL,	5}, //Huntley
	{true,		4,		FUEL_GASOLINA,	4}, //Stafford
	{false,		1,		FUEL_GASOLINA,	1}, //BF-400
	{true,		4,		FUEL_DIESEL,	7}, //Newsvan
	{true,		1,		FUEL_GASOLINA,	0}, //Tug
	{false,		1,		FUEL_NONE,		0}, //Petrol Trailer
	{true,		4,		FUEL_GASOLINA,	3}, //Emperor
	{false,		2,		FUEL_GASOLINA,	1}, //Wayfarer
	{true,		2,		FUEL_GASOLINA,	2}, //Euros
	{true,		2,		FUEL_DIESEL,	5}, //Hotdog
	{true,		2,		FUEL_GASOLINA,	3}, //Club
	{false,		1,		FUEL_NONE,		0}, //Freight Box Trailer (Train)
	{false,		1,		FUEL_NONE,		10}, //Artigo Trailer 3
	{false,		1,		FUEL_GASOLINA,	10}, //Andromada
	{true,		2,		FUEL_GASOLINA,	2}, //Dodo
	{false,		1,		FUEL_GASOLINA,	0}, //RC Cam
	{false,		1,		FUEL_GASOLINA,	0}, //Launch
	{true,		4,		FUEL_GASOLINA,	4}, //Police Car (LSPD)
	{true,		4,		FUEL_GASOLINA,	4}, //Police Car (SFPD)
	{true,		4,		FUEL_GASOLINA,	4}, //Police Car (LVPD)
	{true,		2,		FUEL_DIESEL,	5}, //Police Ranger
	{true,		2,		FUEL_GASOLINA,	3}, //Picador
	{false,		2,		FUEL_DIESEL,	5}, //S.W.A.T.
	{true,		2,		FUEL_GASOLINA,	2}, //Alpha
	{true,		2,		FUEL_GASOLINA,	2}, //Phoenix
	{true,		4,		FUEL_GASOLINA,	3}, //Glendale Shit
	{true,		4,		FUEL_GASOLINA,	4}, //Sadler Shit
	{false,		1,		FUEL_NONE,		0}, //Baggage Trailer "A"
	{false,		1,		FUEL_NONE,		0}, //Baggage Trailer "B"
	{false,		1,		FUEL_NONE,		0}, //Tug Stairs Trailer
	{true,		4,		FUEL_DIESEL,	8}, //Boxville
	{false,		1,		FUEL_NONE,		0}, //Farm Trailer
	{false,		1,		FUEL_NONE,		0} //Utility Trailer
};

stock GetVehicleFuelType(vehicleid)
{
	new model2 = GetVehicleModel(vehicleid);
	if(model2 == 0) return 0;

	return CoreVehicleData[model2-400][vdata_fueltype];
}

CMD:einfo(playerid, params[])
{
	if(!PlayerInfo[playerid][pLogged]) return true;

	new VehID = GetPlayerVehicleID(playerid);
	if(VehID == 0 || !VehicleHasEngine(VehID)) return SCM(playerid, COLOR_LIGHTRED, "You must be in a vehicle with an engine.");

	new fueltype[20];
	switch(GetVehicleFuelType(VehID))
	{
		case FUEL_NONE: fueltype = "None";
		case FUEL_GASOLINA: fueltype = "Petrol";
		case FUEL_DIESEL: fueltype = "Diesel";
	}

	SendClientMessageF(playerid,COLOR_WHITE, "[%s] Fuel Type: {38B0DE}%s", GetVehicleName(VehID), fueltype);
	return true;
}

stock VehicleHasTrunk(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	if(model == 0) return 0;

	new value = CoreVehicleData[model-400][vdata_trunklimit];
	if(value == 0) return false;
	return true;
}
