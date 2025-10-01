MysqlConnection()
{
/*
   // Cipher - 25/03/21 - Inactive Flusher

    // vehicles
    mysql_tquery(connectionID, "DELETE t1 FROM vehicles AS t1 LEFT JOIN users AS t2 ON t2.uid = t1.ownerid WHERE t2.lastlogin < NOW() - INTERVAL 31 DAY", "OnServerFlushInactive", "d", 1);

    // houses
    mysql_tquery(connectionID, "DELETE t1 FROM houses AS t1 LEFT JOIN users AS t2 ON t2.uid = t1.ownerid WHERE t2.lastlogin < NOW() - INTERVAL 31 DAY", "OnServerFlushInactive", "d", 2);

    // clothings
    mysql_tquery(connectionID, "DELETE t1 FROM clothing AS t1 LEFT JOIN users AS t2 ON t2.uid = t1.uid WHERE t2.lastlogin < NOW() - INTERVAL 31 DAY", "OnServerFlushInactive", "d", 3);

    // inventory
    mysql_tquery(connectionID, "DELETE t1 FROM inventory AS t1 LEFT JOIN users AS t2 ON t2.uid = t1.uid WHERE t2.lastlogin < NOW() - INTERVAL 31 DAY", "OnServerFlushInactive", "d", 3);

    // user accounts
    mysql_tquery(connectionID, "DELETE FROM users WHERE lastlogin < NOW() - INTERVAL 31 DAY", "OnServerFlushInactive", "d", 4);

*/

    mysql_tquery(connectionID, "TRUNCATE TABLE shots");
    mysql_tquery(connectionID, "SELECT * FROM houses", "OnQueryFinished", "ii", THREAD_LOAD_HOUSES, 0);
    mysql_tquery(connectionID, "SELECT * FROM `vendors`", "OnQueryFinished", "ii", THREAD_LOAD_VENDORS, 0);
    mysql_tquery(connectionID, "SELECT  * FROM garages", "OnQueryFinished", "ii", THREAD_LOAD_GARAGES, 0);
    mysql_tquery(connectionID, "SELECT  * FROM graffiti", "Graffiti_Load", "");
    mysql_tquery(connectionID, "SELECT * FROM businesses", "OnQueryFinished", "ii", THREAD_LOAD_BUSINESSES, 0);
    mysql_tquery(connectionID, "SELECT * FROM entrances", "OnQueryFinished", "ii", THREAD_LOAD_ENTRANCES, 0);
    mysql_tquery(connectionID, "SELECT * FROM factions", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONS, 0);
    mysql_tquery(connectionID, "SELECT * FROM factionranks", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONRANKS, 0);
    mysql_tquery(connectionID, "SELECT * FROM factionskins", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONSKINS, 0);
    mysql_tquery(connectionID, "SELECT * FROM factionpay", "OnQueryFinished", "ii", THREAD_LOAD_FACTIONPAY, 0);
    mysql_tquery(connectionID, "SELECT * FROM divisions", "OnQueryFinished", "ii", THREAD_LOAD_DIVISIONS, 0);
    mysql_tquery(connectionID, "SELECT * FROM vehicles WHERE ownerid = 0", "OnQueryFinished", "ii", THREAD_LOAD_VEHICLES, 0);
    mysql_tquery(connectionID, "SELECT * FROM gangs", "OnQueryFinished", "ii", THREAD_LOAD_GANGS, 0);
    mysql_tquery(connectionID, "SELECT * FROM gangranks", "OnQueryFinished", "ii", THREAD_LOAD_GANGRANKS, 0);
    mysql_tquery(connectionID, "SELECT * FROM gangskins", "OnQueryFinished", "ii", THREAD_LOAD_GANGSKINS, 0);
    mysql_tquery(connectionID, "SELECT * FROM `dropped`", "Dropped_Load", "");
    mysql_tquery(connectionID, "SELECT * FROM actors", "OnQueryFinished", "ii", THREAD_LOAD_ACTORS, 0);
    mysql_tquery(connectionID, "SELECT * FROM speedcameras", "Speed_Load", "");
    mysql_tquery(connectionID, "SELECT * FROM safezones", "LoadSafezones", "");
    mysql_tquery(connectionID, "SELECT * FROM locations", "LoadLocation", "");
    mysql_tquery(connectionID, "SELECT * FROM `gates`", "Gate_Load", "");
    mysql_tquery(connectionID, "SELECT * FROM turfs", "OnQueryFinished", "ii", THREAD_LOAD_TURFS, 0);
    mysql_tquery(connectionID, "SELECT * FROM `rp_dealercars`", "OnLoadDealershipCars");
    mysql_tquery(connectionID, "SELECT * FROM `factionlockers`", "OnQueryFinished", "ii", THREAD_LOAD_LOCKERS, 0);
    mysql_tquery(connectionID, "SELECT * FROM `object`", "OnLoadObjects");
    mysql_tquery(connectionID, "SELECT * FROM `rp_atms`", "OnQueryFinished", "ii", THREAD_LOAD_ATMS, 0);
    mysql_tquery(connectionID, "SELECT * FROM pumps", "OnQueryFinished", "ii", THREAD_LOAD_GAS_PUMPS, 0);
    mysql_tquery(connectionID, "SELECT * FROM mapicons", "OnQueryFinished", "ii", THREAD_LOAD_MAP_ICONS, 0);
    mysql_tquery(connectionID, "SELECT * FROM `lands`", "OnQueryFinished", "ii", THREAD_LOAD_LANDS, 0);
    mysql_tquery(connectionID, "SELECT * FROM `landobjects`", "OnQueryFinished", "ii", THREAD_LOAD_LANDOBJECTS, 0);
    mysql_tquery(connectionID, "SELECT * FROM `rp_furniture`", "OnLoadFurniture");
    mysql_tquery(connectionID, "SELECT * FROM `publicgarage`", "Garage_Load", "");
    mysql_tquery(connectionID, "SELECT * FROM `crates`", "Crate_Load", "");
}

Halloween()
{
    #if defined HALLOWEEN

    // init
    HalloweenData[DropTimeLeft] = GIFT_INTERVAL;
    HalloweenData[EventTimer] = SetTimer("Halloween_GiftDrop", 1000, true);

    for(new i; i < MAX_GIFT_BOXES; i++)
    {
        GiftBoxData[i][GiftBoxPickup] = GiftBoxData[i][GiftBoxTimer] = -1;
        GiftBoxData[i][GiftBoxLabel] = Text3D: -1;
    }

    for(new i; i < MAX_PUMPKINS; i++)
    {
        PumpkinData[i][PumpkinPickup] = PumpkinData[i][PumpkinTimer] = -1;
        PumpkinData[i][PumpkinLabel] = Text3D: -1;
    }
 
    #endif
}


WeaponConfig()
{
    SetWeather(gWeather);
    EnableStuntBonusForAll(0);
//    UsePlayerPedAnims();
    DisableInteriorEnterExits();
    AllowInteriorWeapons(0);
    ManualVehicleEngineAndLights();
    SetDamageFeed(false);
    SetDamageSounds(1, 1);
    SetVehicleUnoccupiedDamage(false);
    SetVehiclePassengerDamage(true);
    ShowNameTags(1);
    SetNameTagDrawDistance(10.0);
//  HeadShotSystem = true;
    return 1;
}

StreamerVehicles()
{
    forkliftVehicles[0] = AddStaticVehicleEx(530, 2778.5310, -2425.0867, 13.3935, 0.0000, 6, 6, 600); // forklift 1
    forkliftVehicles[1] = AddStaticVehicleEx(530, 2778.6404, -2410.1257, 13.4024, 180.0000, 6, 6, 600); // forklift 2
    forkliftVehicles[2] = AddStaticVehicleEx(530, 2787.8252, -2425.3438, 13.3990, 0.0000, 6, 6, 600); // forklift 3
    forkliftVehicles[3] = AddStaticVehicleEx(530, 2788.1560, -2410.3755, 13.3962, 180.0000, 6, 6, 600); // forklift 4
    forkliftVehicles[4] = AddStaticVehicleEx(530, 2795.1589, -2425.3408, 13.3954, 0.0000, 6, 6, 600); // forklift 5
    forkliftVehicles[5] = AddStaticVehicleEx(530, 2795.1826, -2409.9617, 13.3972, 180.0000, 6, 6, 600); // forklift 6

    sweeperVehicles[0] = AddStaticVehicleEx(574, 2187.6636, -1975.8738, 13.3012, 180.0000, 26, 26, 300); // sweeper 1
    sweeperVehicles[1] = AddStaticVehicleEx(574, 2184.9255, -1975.8738, 13.3029, 180.0000, 26, 26, 300); // sweeper 2
    sweeperVehicles[2] = AddStaticVehicleEx(574, 2181.8672, -1975.8738, 13.3005, 180.0000, 26, 26, 300); // sweeper 3
    sweeperVehicles[3] = AddStaticVehicleEx(574, 2179.0005, -1975.8738, 13.2679, 180.0000, 26, 26, 300); // sweeper 4

    // Rent Vehicles
    rentcar[0] = CreateVehicle(571,1615.8827, -1105.4458, 23.3604, -3.0000,13,13,-1); // Faggio 122
    rentcar[1] = CreateVehicle(571,1613.5627, -1105.3844, 23.3604, -3.0000,14,14,-1); // Faggio 123
    rentcar[2] = CreateVehicle(571,1611.3231, -1105.3204, 23.3604, -3.0000,1,2,-1); // Faggio 124
    rentcar[3] = CreateVehicle(571,1609.1455, -1105.1982, 23.3604, -3.0000,2,1,-1); // Faggio 125
    rentcar[4] = CreateVehicle(571,1607.7803, -1102.2043, 23.3604, -3.0000,1,3,-1); // Faggio 126
    rentcar[5] = CreateVehicle(571,1610.4779, -1102.4005, 23.3604, -3.0000,3,1,-1); // Faggio 127
    rentcar[6] = CreateVehicle(571,1613.3635, -1102.6672, 23.3604, -3.0000,10,10,-1); // Faggio 128
    rentcar[7] = CreateVehicle(571,1616.1350, -1102.8173, 23.3604, -3.0000,12,12,-1); // Faggio 129

    // Job Vehicles (Main)
    pizzaVehicles[0] = AddStaticVehicleEx(448, 2097.8396, -1792.2556, 12.9978, 90.0000, 3, 6, 300); // bike 1
    pizzaVehicles[1] = AddStaticVehicleEx(448, 2097.8396, -1794.0065, 12.9978, 90.0000, 3, 6, 300); // bike 2
    pizzaVehicles[2] = AddStaticVehicleEx(448, 2097.8396, -1795.7574, 12.9978, 90.0000, 3, 6, 300); // bike 3
    pizzaVehicles[3] = AddStaticVehicleEx(448, 2097.8396, -1797.5083, 12.9978, 90.0000, 3, 6, 300); // bike 4
    pizzaVehicles[4] = AddStaticVehicleEx(448, 2097.8396, -1799.2592, 12.9978, 90.0000, 3, 6, 300); // bike 5
    pizzaVehicles[5] = AddStaticVehicleEx(448, 2097.8396, -1801.0101, 12.9978, 90.0000, 3, 6, 300); // bike 6

    // Trailers to Attach with the Tractor
    FarmerTrailers[0] = AddStaticVehicleEx(610, -56.4196, 91.5382, 2.7113, -110.0000, 1, 1, 300);
    FarmerTrailers[1] = AddStaticVehicleEx(610, -57.3179, 88.7185, 2.7113, -110.0000, 1, 1, 300);
    FarmerTrailers[2] = AddStaticVehicleEx(610, -58.2931, 85.9590, 2.7113, -110.0000, 1, 1, 300);
    FarmerTrailers[3] = AddStaticVehicleEx(610, -60.3994, 79.9987, 2.7113, -110.0000, 1, 1, 300);
    FarmerTrailers[4] = AddStaticVehicleEx(610, -61.3913, 77.2875, 2.7113, -110.0000, 1, 1, 300);
    FarmerTrailers[5] = AddStaticVehicleEx(610, -62.2931, 74.6321, 2.7113, -110.0000, 1, 1, 300);


    // Tractor
    FarmerVehicles[0] = AddStaticVehicleEx(531, -53.1162, 90.4464, 3.3746, -110.0000, 1, 1, 300);
    FarmerVehicles[1] = AddStaticVehicleEx(531, -54.2064, 87.7073, 3.3746, -110.0000, 1, 1, 300);
    FarmerVehicles[2] = AddStaticVehicleEx(531, -55.1513, 84.9444, 3.3746, -110.0000, 1, 1, 300);
    FarmerVehicles[3] = AddStaticVehicleEx(531, -57.2420, 79.0167, 3.3746, -110.0000, 1, 1, 300);
    FarmerVehicles[4] = AddStaticVehicleEx(531, -58.1903, 76.2955, 3.3746, -110.0000, 1, 1, 300);
    FarmerVehicles[5] = AddStaticVehicleEx(531, -59.1874, 73.6146, 3.3746, -110.0000, 1, 1, 300);


    // Harvester
    HarvestVehicles[0] = AddStaticVehicleEx(532, -21.7231, 88.8074, 4.5185, 70.0000, 1, 1, 300);
    HarvestVehicles[1] = AddStaticVehicleEx(532, -25.3051, 79.3420, 4.5185, 70.0000, 1, 1, 300);
    HarvestVehicles[2] = AddStaticVehicleEx(532, -28.8506, 70.3914, 4.5185, 70.0000, 1, 1, 300);
    HarvestVehicles[3] = AddStaticVehicleEx(532, -32.6084, 60.6587, 4.5185, 70.0000, 1, 1, 300);


    // FoodPanda
    foodVehicles[0] = AddStaticVehicleEx(586, 978.7726, -1308.4243, 12.9222, 0.0000, 5, 1, 300); // bike 1
    foodVehicles[1] = AddStaticVehicleEx(586, 984.3414, -1308.1840, 12.9222, 0.0000, 5, 1, 300); // bike 2
    foodVehicles[2] = AddStaticVehicleEx(586, 1008.2693, -1308.2881, 12.9222, 0.0000, 5, 1, 300); // bike 3
    foodVehicles[3] = AddStaticVehicleEx(586, 1002.0175, -1308.2839, 12.9222, 0.0000, 5, 1, 300); // bike 4
    foodVehicles[4] = AddStaticVehicleEx(586, 989.5507, -1308.3434, 12.9222, 0.0000, 5, 1, 300); // bike 5
    foodVehicles[5] = AddStaticVehicleEx(586, 996.0358, -1308.3828, 12.9222, 3.0000, 5, 1, 300); // bike 6

    courierVehicles[0] = AddStaticVehicleEx(498, 1787.5144, -2024.0779, 13.4865, -178.8600, 11, 11, 300); // mule
    courierVehicles[1] = AddStaticVehicleEx(498, 1792.6925, -2024.2432, 13.4865, -178.8600, 11, 11, 300); // mule
    courierVehicles[2] = AddStaticVehicleEx(498, 1797.8663, -2024.1129, 13.4865, -178.8600, 11, 11, 300); // mule
    courierVehicles[3] = AddStaticVehicleEx(498, 1807.7712, -2033.3390, 13.5128, 89.3400, 11, 11, 300); // boxville
    courierVehicles[4] = AddStaticVehicleEx(498, 1807.5942, -2038.8160, 13.5128, 89.3400, 11, 11, 300); // boxville
    courierVehicles[5] = AddStaticVehicleEx(498, 1807.5728, -2044.4001, 13.5128, 89.3400, 11, 11, 300); // boxville
    courierVehicles[6] = AddStaticVehicleEx(498, 1807.5408, -2049.9885, 13.5128, 89.3400, 11, 11, 300); // boxville

    taxiVehicles[0] = AddStaticVehicleEx(438, 1775.6141, -1860.0100, 13.2745, 269.2006, 6, 1, 300); // taxi 1
    taxiVehicles[1] = AddStaticVehicleEx(438, 1763.0121, -1860.0037, 13.2723, 271.2998, 6, 1, 300); // taxi 2
    taxiVehicles[2] = AddStaticVehicleEx(438, 1748.9358, -1859.9502, 13.2721, 270.3943, 6, 1, 300); // taxi 3
    taxiVehicles[3] = AddStaticVehicleEx(438, 1734.6754, -1859.9305, 13.2740, 270.5646, 6, 1, 300); // taxi 4

    // Driving Test (Main)
    testVehicles[0] = AddStaticVehicleEx(445, 1280.5974, -1795.9840, 13.2733, 180.0000, 1, 1, 10); // test car 1
    testVehicles[1] = AddStaticVehicleEx(445, 1276.2882, -1796.0579, 13.2776,181.8796, 1, 1, 10); // test car 2
    testVehicles[2] = AddStaticVehicleEx(445, 1271.8486, -1796.2174, 13.2694,182.5803, 1, 1, 10); // test car 3
    testVehicles[3] = AddStaticVehicleEx(445, 1267.1357, -1796.2031, 13.2980,181.5889, 1, 1, 10); // test car 4
    testVehicles[4] = AddStaticVehicleEx(445, 1262.5736, -1796.3016, 13.3016,180.8420, 1, 1, 10); // test car 5


    garbageVehicles[0] = AddStaticVehicleEx(408,2450.0818,-2117.0393,14.0948,359.3405,-1,-1,300); // Garbage 1
    garbageVehicles[1] = AddStaticVehicleEx(408,2456.0059,-2117.0317,14.0978,359.8398,-1,-1,300); // Garbage 2
    garbageVehicles[2] = AddStaticVehicleEx(408,2461.9404,-2116.9187,14.1033,1.3363,-1,-1,300); // Garbage 3
    garbageVehicles[3] = AddStaticVehicleEx(408,2467.7634,-2116.7227,14.1018,0.6403,-1,-1,300); // Garbage 4
    garbageVehicles[4] = AddStaticVehicleEx(408,2474.4385,-2116.6218,14.0943,2.2394,-1,-1,300); // Garbage 5
    garbageVehicles[5] = AddStaticVehicleEx(408,2480.3513,-2116.6707,14.0944,359.6030,-1,-1,300); // Garbage 6

    return 1;
}


StreamerGate()
{
    new string[255];
    // SANews Broadcast
    SANews3DText = CreateDynamic3DTextLabel(string,COLOR_GREY, 632.7400, -14.2350, 1108.2181, 5.0);
    UpdateSANewsBroadcast();

    gPDDoors[0] = CreateDynamicObject(1495, -1647.7126, 689.2911, 1007.7568,   0.00000, 0.00000, 89.7601);
    gPDDoors[1] = CreateDynamicObject(1567, -1643.7992, 688.4844, 1007.7234,   0.00000, 0.00000, 0.00000);
    gPDDoors[2] = CreateDynamicObject(1567, -1640.6097, 691.5563, 1007.7234,   0.00000, 0.00000, 0.0000);

    gPDDoors[3] = CreateDynamicObject(1567, -1640.6268, 703.5986, 1007.7234,   0.00000, 0.00000, 0.0000);
    gPDDoors[4] = CreateDynamicObject(1567, -1647.7246, 702.0438, 1007.7234,   0.00000, 0.00000, 89.7600);
    gPDDoors[5] = CreateDynamicObject(1495, -1648.3091, 701.5599, 1000.8059,   0.00000, 0.00000, 0.0000);
    gPDDoors[6] = CreateDynamicObject(1495, -1654.6777, 701.6064, 1000.8059,   0.00000, 0.00000, 0.0000);
    gPDDoors[7] = CreateDynamicObject(1567, 2040.5555, -2028.5852, 867.2506,   0.00000, 0.00000, 89.5800);


    gPrisonCells[0] = CreateDynamicObject(19302,2031.4131, -2037.9917, 868.4713,0.00000000,0.00000000,89.3400);
    gPrisonCells[1] = CreateDynamicObject(19302, -2390.525878, 2100.514892, 753.848327, 0.000000, 0.000000, 90.000000);
    gPrisonCells[2] = CreateDynamicObject(19302, -2390.525878, 2102.235839, 753.848327, 0.000000, 0.000000, 270.000000);
    gPrisonCells[3] = CreateDynamicObject(19302, -2390.525878, 2097.195800, 753.848327, 0.000000, 0.000000, 270.000000);
    gPrisonCells[4] = CreateDynamicObject(19302, -2390.525878, 2095.455078, 753.848327, 0.000000, 0.000000, 90.000000);
    gPrisonCells[5] = CreateDynamicObject(19302, -2390.525878, 2092.125488, 753.848327, 0.000000, 0.000000, 270.000000);
    gPrisonCells[6] = CreateDynamicObject(19302, -2390.525878, 2090.401367, 753.848327, 0.000000, 0.000000, 90.000000);
    gPrisonCells[7] = CreateDynamicObject(19302, -2396.139160, 2090.401367, 753.848327, 0.000000, 0.000000, 90.000000);
    gPrisonCells[8] = CreateDynamicObject(19302, -2396.148925, 2092.125488, 753.848327, 0.000000, 0.000000, 270.000000);
    gPrisonCells[9] = CreateDynamicObject(19302, -2396.139160, 2095.441406, 753.848327, 0.000000, 0.000000, 90.000000);
    gPrisonCells[10] = CreateDynamicObject(19302, -2396.148925, 2097.175781, 753.848327, 0.000000, 0.000000, 270.000000);
    gPrisonCells[11] = CreateDynamicObject(19302, -2396.139160, 2100.511474, 753.848327, 0.000000, 0.000000, 90.000000);
    gPrisonCells[12] = CreateDynamicObject(19302, -2396.148925, 2102.256591, 753.848327, 0.000000, 0.000000, 270.000000);
    
    
    return 1;
}


Textdraws()
{	
    Border5 = CreateDynamicObject(968,51.067,-1286.589,13.659,0.000,-90.200,-54.806);
    Border6 = CreateDynamicObject(968,71.514,-1305.882,12.010,0.000,-89.399,-49.406);
    Border7 = CreateDynamicObject(968,514.546,468.370,18.759,0.000,90.000,38.485);
    Border8 = CreateDynamicObject(968,525.827,477.249,18.799,0.000,90.000,217.985);
    Border9 = CreateDynamicObject(968,-159.520,371.172,11.722,0.000,90.000,166.787);
    Border0 = CreateDynamicObject(968,-173.392,374.704,11.722,0.000,90.000,344.634);
    Border4 = CreateDynamicObject(968,55.194,-1522.403,4.809,0.000,-90.000,89.192);
    Border3 = CreateDynamicObject(968,53.587,-1541.730,4.809,0.000,-90.000,263.597);
    Border1 = CreateDynamicObject(968, 1813.34851, 813.63531, 10.66680,   0.00000, 270.00000, 0.00000);
    Border2 = CreateDynamicObject(968, 1780.06458, 802.22620, 10.66680,   0.00000, 270.00000, 900.00000);

    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 52.789,-1538.231,5.003,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 56.351,-1526.141,4.884,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 1809.4454,811.5417,10.8997,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 1783.6510,803.8441,11.0599,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 50.1882,-1282.9015,14.0709,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 68.1923,-1304.1959,12.4487,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 517.2233,472.0292,18.9297,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, 523.5045,473.5910,18.9297,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, -169.2154,374.7297,12.0781,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);
    CreateDynamic3DTextLabel("Before you enter you need "GREEN"$250"GREY" to pass this gate\n"SVRCLR"(( Press 'N' to open the toll gate. ))",COLOR_GREY, -163.9199,370.8330,12.0781,15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 30.0);

    CreateDynamic3DTextLabel("[Impound Lots]\n{FFFFFF}type '/impound' to impound a vehicle.", COLOR_YELLOW, 1073.0363, -2301.3181, 12.4084, 10.0);
    CreateDynamic3DTextLabel("[Impound Lots]\n{FFFFFF}type '/impound' to impound a vehicle.", COLOR_YELLOW, 1185.7825,-1625.9136,13.5911, 10.0);


    CreateDynamic3DTextLabel("[VIP Locker]\n{FFFFFF}Type /viplocker to open the locker\nType '/viptoys' to view available toys\nType /getboombox to get free boombox.", COLOR_YELLOW, 2787.1292, 2390.5754, 1240.3785, 10.0);
    CreateDynamic3DTextLabel("[Hospital Charts]\n{FFFFFF}Press 'N' to view charts..", COLOR_YELLOW, 1240.7098,-1281.7479,1061.1492, 2.0);
    CreateDynamic3DTextLabel("[Mechanic Charts]\n{FFFFFF}Press 'N' to view charts..", COLOR_YELLOW, 2885.1248,-1950.3918,11.1224, 2.0);

    CreateDynamic3DTextLabel("[Exchange Booth]\n{FFFFFF}Press 'N' to exchange your tiki.", COLOR_GREEN, -771.2367, 1443.3539, 13.2803, 10.0);
    CreateDynamicPickup(1276, 1, -771.2367, 1443.3539, 13.2803);

    CreateDynamic3DTextLabel("[Quest Booth]\n{FFFFFF}Take a quest here!\nPress 'N' to take", COLOR_GREEN, -771.0532, 1438.3182, 13.2803, 10.0);
    CreateDynamicPickup(1277, 1, -771.0532, 1438.3182, 13.2803);

    CreateDynamic3DTextLabel("[Hunger Games]\n{FFFFFF}Comingsoon!", COLOR_GREEN, -770.9543, 1433.6057, 13.2803, 10.0);
    CreateDynamicPickup(1239, 1, 2942.5483,-1448.6559,10.7773);

    CreateDynamic3DTextLabel("[Hunger Games]\n{FFFFFF}Comingsoon!", COLOR_GREEN, -770.8950, 1429.1313, 13.2803, 10.0);
    CreateDynamicPickup(1239, 1, 2939.8535,-1411.3993,10.7673);

    
    
    return 1;
}
//textlabel important
TextLabels()
{
    new string[255];

    CreateDynamic3DTextLabel("Front Desk", -1, 2885.7515,2100.5857,1000.6995, 5.0);
    pdCheckpoint = CreateDynamicCP(2885.7515,2100.5857,1000.6995, 1.5); //CreateDynamicPickup(1581,

    CreateDynamic3DTextLabel("City Hall", COLOR_WHITE, 1481.0503,-1772.2484,18.7958, 5.0);
    cityhallext = CreateDynamicPickup(1314, 1, 1481.0503,-1772.2484,18.7958);

    cityhallint = CreateDynamicPickup(1314, 1, 2670.1819,-611.5929,-71.6501);


    CreateDynamic3DTextLabel("Mulholland Bank", COLOR_BLUE, 1461.6748, -1010.3104, 26.4148, 5.0);
    bankext = CreateDynamicPickup(1314, 1, 1461.6748, -1010.3104, 26.4148);

    bankint = CreateDynamicPickup(1314, 1, 1667.3536, -995.3700, 683.6913, .worldid = 3, .interiorid = 5);


    gVIPHealth = CreateDynamicPickup(1240, 1, 2788.3967, 2407.9819, 1239.9403, .worldid = 2, .interiorid = 2);
    gVIPArmor = CreateDynamicPickup(1242, 1, 2786.6594, 2405.5471, 1239.9403, .worldid = 2, .interiorid = 2);

    CreateDynamic3DTextLabel("Casino", COLOR_WHITE, 1022.4454, -1121.2244, 23.3861, 5.0);
    casinoext = CreateDynamicPickup(1314, 1, 1022.4454, -1121.2244, 23.3861);

    casinoint = CreateDynamicPickup(1314, 1, 2019.2524, 1017.8654, 996.5874);

    CreateDynamic3DTextLabel("Fort CarsonPrison", SERVER_COLOR, 252.1568, 1389.6388, 10.9491, 5.0);
    cellext = CreateDynamicPickup(1314, 1, 252.1568, 1389.6388, 10.9491);

    cellint = CreateDynamicPickup(1314, 1, 2005.5079, -2055.7124, 868.1882);

    CreateDynamic3DTextLabel("Licensing department", COLOR_BLUE, 1219.2590, -1812.1093, 16.5938, 5.0);
    dmvext = CreateDynamicPickup(1581, 1, 1219.2590, -1812.1093, 16.5938);

    dmvint = CreateDynamicPickup(1581, 1, 2887.5691, 2117.4280, 1000.6995);

    CreateDynamic3DTextLabel("Type /getmats to purchase material packages", COLOR_YELLOW,2096.0740, -1885.7511, 12.8862+0.5,8.0); //GETMATS - LS
    CreateDynamicPickup(1230, 23, 2096.0740, -1885.7511, 12.8862, -1, -1); // Materials Pickup - LS

    CreateDynamic3DTextLabel("Loading Dock\n"SVRCLR"(( Type '/loadtruck' and pick a load to begin delivery. ))", COLOR_GREY, 1766.9261,-2048.9807,13.835, 10.0);
    CreateDynamicPickup(1239, 1, 1766.9261,-2048.9807,13.835);

    CreateDynamic3DTextLabel("Drivers Test\nCost: $5000\nType '/taketest' to begin\nType /registervehicle\n"GREEN"Price:$8,500\n"WHITE"/getcinsure to get insurance.", COLOR_GREY, 2885.3699,2113.4053,1000.6995, 10.0);
    CreateDynamicPickup(1581, 1, 2885.3699,2113.4053,1000.6995);

    CreateDynamic3DTextLabel("Cityhall Desks\nType '/buylevel and '/upgrade' to upgrade\n/signcheck to claim your paycheck. ", COLOR_GREY, 2704.0796, -597.2493, -71.8642, 10.0);
    CreateDynamicPickup(1239, 1, 2704.0796, -597.2493, -71.8642);


    CreateDynamic3DTextLabel("Meth Cookoff\n> Requires Ephedrine <\n"SVRCLR"(( Type '/cookmeth' to begin cooking. ))", COLOR_GREY, 333.5727, 1121.8536, 1083.8903, 10.0);
    CreateDynamicPickup(1577, 1, 333.5727, 1121.8536, 1083.8903);

    CreateDynamic3DTextLabel("Stove\n"SVRCLR"Type "TWEET"'/cook'"WHITE" to cook.", COLOR_GREY, 1282.4260, -1302.3300, 12.9674, 10.0);
    CreateDynamicPickup(1239, 1, 1282.4260, -1302.3300, 12.9674);

    CreateDynamic3DTextLabel("Ela's Burger\n"SVRCLR"Type "TWEET"'/order'"WHITE" to order.", COLOR_GREY, 1279.0321, -1289.7448, 13.0558, 10.0);
    CreateDynamicPickup(1239, 1, 1279.0321, -1289.7448, 13.0558);

    CreateDynamic3DTextLabel("Bank\n"SVRCLR"(( Type '/bankhelp' for more help. ))", COLOR_GREY, 1667.4260, -972.6691, 683.6873, 10.0);
    CreateDynamicPickup(1239, 1, 1667.4260, -972.6691, 683.6873);

    gSeedsStockText = CreateDynamic3DTextLabel("Drug House\nStock: 100\n"SVRCLR"/getdrug [seeds, Ephedrine, Crack] [amount]", COLOR_GREY, 308.2195, 1120.5073, 1083.7147, 10.0);
    CreateDynamicPickup(1578, 1, 308.2195, 1120.5073, 1083.7147);

    gParachutes[0] = CreateDynamicPickup(371, 1, 1542.9038, -1353.0352, 329.4744); // Star tower
    gParachutes[1] = CreateDynamicPickup(371, 1, 315.9415, 1010.6052, 1953.0031); // Andromada interior

    for(new i = 0; i < sizeof(jobLocations); i ++)
    {
//      format(string, sizeof(string), "/join\nto become a %s.", jobLocations[i][jobName]);
        format(string, sizeof string, "{33CCFF}Job Point ({FFFFFF}ID: %i{33CCFF})\n\nName: {FFFFFF}%s\n{33CCFF}Press {FFFFFF}'N' {33CCFF}to obtain the job.", i, jobLocations[i][jobName]);
        //CreateDynamicPickup(1239, 1, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ]);
        CreateDynamic3DTextLabel(string, COLOR_YELLOW, jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], 10.0, .testlos = 1, .streamdistance = 10.0);
        CreateDynamicMapIcon(jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], 56, 0, .style = MAPICON_GLOBAL);
        CreateActor(jobLocations[i][jobActor], jobLocations[i][jobX], jobLocations[i][jobY], jobLocations[i][jobZ], jobLocations[i][actorangle]);
    }
    for(new i = 0; i < sizeof(comservpoint); i ++)
    {
        //CreateDynamicPickup(19132, 1, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2]);
        CreateDynamic3DTextLabel("Community Service\nType "WHITE"'/clean'"TWEET" to start cleaning.", COLOR_TWEET, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2], 10.0);
    }

    for(new i = 0; i < sizeof(atmMachines); i ++)
    {
        CreateDynamicObject(19324, atmMachines[i][atmX], atmMachines[i][atmY], atmMachines[i][atmZ], 0.0, 0.0, atmMachines[i][atmA]);
        CreateDynamic3DTextLabel("ATM Machine\nType "YELLOW"'/atm'"RED" to login.", COLOR_RED, atmMachines[i][atmX], atmMachines[i][atmY], atmMachines[i][atmZ] + 0.4, 10.0);
    }
    for(new i = 0; i < sizeof(g_RepairShops); i ++)
    {
        CreateDynamicPickup(1239, 1, g_RepairShops[i][0], g_RepairShops[i][1], g_RepairShops[i][2]);
        CreateDynamic3DTextLabel("Repair Shop\n"WHITE"Cost: $5,000\n"GREY"Type '/enter' to repair your vehicle.", COLOR_AQUA, g_RepairShops[i][0], g_RepairShops[i][1], g_RepairShops[i][2], 20.0);
    }   
    for (new i = 0; i < sizeof(arrBoothPositions); i ++) {
        CreateDynamic3DTextLabel("[Shooting Range]\n{FFFFFF}Press 'F' to use this booth.", COLOR_AQUA, arrBoothPositions[i][0], arrBoothPositions[i][1], arrBoothPositions[i][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 7);
    }

    for(new i = 0; i < sizeof(mdc_coordinates); i ++)
    {
        CreateDynamic3DTextLabel("Type '"GREEN"/mdc"WHITE"' to login.", COLOR_WHITE, mdc_coordinates[i][0], mdc_coordinates[i][1], mdc_coordinates[i][2], 5.0);
    }
    CreatePickup(1239, 23, 1433.0181,-962.2107,36.3097, -1); // Pickup Point (LA)
    CreateDynamic3DTextLabel("[Brinks Depot]\n"WHITE"Type /loadcar to start",COLOR_GLOBAL,1433.0181,-962.2107,36.3097+0.6,10.0); // Pickup Point (LA)

    CreateDynamic3DTextLabel("You can play by typing\n'/dicebet'",COLOR_WHITE,2017.6475,-2036.6041,868.2566+0.5,4.0);// Stolen Car Chop Shop (AP)
    CreatePickup(1239,23,2017.6475,-2036.6041,868.2566,-1); // AP Chop Shop

    CreateDynamic3DTextLabel("((type '/offerboxing' to have a match.))",COLOR_WHITE,226.2609, 1409.2863, 9.9794+0.5,4.0);// Stolen Car Chop Shop (AP)
    CreatePickup(1239,23,226.2609, 1409.2863, 9.9794,-1); // AP Chop Shop

    CreateDynamic3DTextLabel("Butcher\nGet some meat here.\nType '/meat' to trigger.", COLOR_YELLOW, 959.3203,2136.8330,1011.0234, 5.0); // 2
	CreateDynamicPickup(1239, 1, 959.3203,2136.8330,1011.0234);

	CreateDynamic3DTextLabel("Butcher\nProcess the meat.", COLOR_YELLOW, 944.1274,2127.6245,1011.0234, 5.0); // 2
	CreateDynamicPickup(1239, 1, 944.1274,2127.6245,1011.0234);

	CreateDynamic3DTextLabel("Butcher\nDrop the meat.", COLOR_YELLOW, 960.8361,2118.1741,1011.0303, 5.0); // 2
	CreateDynamicPickup(1239, 1, 960.8361,2118.1741,1011.0303);

    CreateDynamic3DTextLabel(""TEAL"Black Market"WHITE" \nPress "ORANGE"N"WHITE" to purchase",COLOR_WHITE,-491.4169, -194.4184, 78.3137+0.5,4.0);//
    CreatePickup(1239,23,-491.4169, -194.4184, 78.3137,-1);

    for(new i = 0; i < sizeof(lumberPositions); i ++)
    {
        CreateDynamic3DTextLabel(""TEAL"Tree\nType "WHITE"'/chop'"TEAL" to begin", COLOR_WHITE, lumberPositions[i][0], lumberPositions[i][1], lumberPositions[i][2], 25.0);
    }

    for(new i = 0; i < sizeof(minerPositions); i ++)
    {
        CreateDynamicPickup(18634, 1, minerPositions[i][0], minerPositions[i][1], minerPositions[i][2]);
        CreateDynamic3DTextLabel("Press 'n' to begin mining.", COLOR_WHITE, minerPositions[i][0], minerPositions[i][1], minerPositions[i][2], 25.0);
    }
    for(new i = 0; i < sizeof(surgeryPositions); i ++)
    {
        //CreateDynamicPickup(18634, 1, surgeryPositions[i][0], surgeryPositions[i][1], surgeryPositions[i][2]);
        CreateDynamic3DTextLabel("Operation Room"WHITE"\nType "RED"/surgery'"WHITE" to begin the operation.", SERVER_COLOR, surgeryPositions[i][0], surgeryPositions[i][1], surgeryPositions[i][2], 25.0);
    }
    for(new i = 0; i < sizeof(tunePositions); i ++)
    {
        CreateDynamic3DTextLabel(""LIGHTRED"Type "WHITE"'/tune'"LIGHTRED" to tune the vehicle\nType "WHITE" '/upgradevehicle' "LIGHTRED"to upgrade the vehicle.", COLOR_LIGHTRED, tunePositions[i][0], tunePositions[i][1], tunePositions[i][2], 8.0);
    }
    for(new i = 0; i < sizeof(staticEntrances); i ++)
    {
        format(string, sizeof(string), "{afafaf}[{FFEC8B}%s{afafaf}]\nPress '{ff0000}F{afafaf}' to enter.", staticEntrances[i][eName]);

        CreateDynamicPickup(19132, 1, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ]);
        CreateDynamic3DTextLabel(string, COLOR_GREY1, staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ], 10.0);

        if(staticEntrances[i][eMapIcon])
        {
            CreateDynamicMapIcon(staticEntrances[i][ePosX], staticEntrances[i][ePosY], staticEntrances[i][ePosZ], staticEntrances[i][eMapIcon], 0);
        }
    }
    for(new i = 0; i < sizeof(staticEntrances); i ++)
    {

        CreateDynamicPickup(19132, 1, staticEntrances[i][eIntX], staticEntrances[i][eIntY], staticEntrances[i][eIntZ]);
        CreateDynamic3DTextLabel("{afafaf}]nPress '{ff0000}F{afafaf}' to exit.", COLOR_GREY1, staticEntrances[i][eIntX], staticEntrances[i][eIntY], staticEntrances[i][eIntZ], 10.0);
    }



    for(new i = 0; i < sizeof(arrestPoints); i ++)
    {
        CreateDynamic3DTextLabel("Arrest\n"SVRCLR"(( Type '/arrest' to arrest a suspect. ))", COLOR_GREY, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2], 7.0);
        CreateDynamicPickup(1247, 1, arrestPoints[i][0], arrestPoints[i][1], arrestPoints[i][2]);
    }

    CreateDynamic3DTextLabel("Garbage Pickup\n/garbage\nto begin delivery.", COLOR_YELLOW, 2449.1167,-2090.1445,13.5469, 10.0);
    CreateDynamicPickup(1239, 1, 2449.1167,-2090.1445,13.5469);

    CreateDynamic3DTextLabel("Paintball Arena"WHITE"\nType "YELLOW"'/enter'"WHITE" to join", COLOR_RED, 1310.1249, -1367.0505, 13.3225, 5.0);
    CreateDynamicPickup(1254, 1, 1310.1249, -1367.0505, 13.3225);

    for(new i = 0; i < sizeof(warehousepoint); i ++)
    {
        //CreateDynamicPickup(19132, 1, comservpoint[i][0], comservpoint[i][1], comservpoint[i][2]);
        CreateDynamic3DTextLabel(""LIGHTRED"Packaging Area"WHITE"\nPress "GREY"'N'"WHITE" to start packaging.", COLOR_WHITE, warehousepoint[i][0], warehousepoint[i][1], warehousepoint[i][2], 10.0);
    }
    CreateDynamic3DTextLabel("Hospital Desk\nPress 'N' to purchase medicine", COLOR_DOCTOR, 1256.1206,-1282.0250,1061.1492, 5.0);
    CreateDynamicPickup(1240, 1, 1256.1206,-1282.0250,1061.1492);
    return 1;
}

DynamicTextLables()
{
    mysql_tquery(connectionID, "SELECT * FROM `textlabels`", "LoadDynamicLabel", "i", 0);
}

Actors()
{


    HalloweenActor[0] = CreateActor(129,1002.6102,-2098.0527,13.1199,334.4673); //
    ApplyActorAnimation(HungerGamesActor[0], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    Create3DTextLabel("Welcome to my nightmare,\n i think you're going to like it.", COLOR_PURPLE, 1002.6102,-2098.0527,13.1199, 8.0, 0, 0);

    HalloweenActor[1] = CreateActor(33,1006.6181,-2063.6802,13.0994,247.9239); //
    ApplyActorAnimation(HalloweenActor[1], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    Create3DTextLabel("No one escapes from life alive!", COLOR_PURPLE, 1006.6181,-2063.6802,13.0994, 8.0, 0, 0);

    HalloweenActor[2] = CreateActor(296,952.4057,-2033.4866,8.0538,171.5049); //
    ApplyActorAnimation(HalloweenActor[2], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    Create3DTextLabel("Candy Shop"WHITE"\nPress 'n' to exchange.", COLOR_PURPLE, 952.4057,-2033.4866,8.0538, 8.0, 0, 0);

   // Tiki
    HungerGamesActor[0] = CreateActor(289,2937.7498,-1466.7856,10.9127,256.9633); //
    ApplyActorAnimation(HungerGamesActor[0], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

   // Quest
    HungerGamesActor[1] = CreateActor(296,2938.7754,-1457.3912,10.8638,260.0967); //
    ApplyActorAnimation(HungerGamesActor[1], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

   // Van ACTORS
    HungerGamesActor[2] = CreateActor(273,2939.7883,-1448.2098,10.8159,260.7234); //
    ApplyActorAnimation(HungerGamesActor[2], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

   // Van ACTORS
    HungerGamesActor[3] = CreateActor(272,2937.2346,-1411.1954,10.8139,264.6923); //
    ApplyActorAnimation(HungerGamesActor[3], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);


   // Van ACTORS
    HungerGamesActor[4] = CreateActor(262,2936.4697,-1401.2681,10.8227,269.6013); //
    ApplyActorAnimation(HungerGamesActor[4], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

   // Van ACTORS
    HungerGamesActor[5] = CreateActor(240,2935.7339,-1391.0114,10.8285,272.2124); //
    ApplyActorAnimation(HungerGamesActor[5], "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    return 1;
}

Timers()
{

    // Timers
    SetTimer("MinuteTimer", 60000, true);
    SetTimer("SecondTimer", 1000, true);
    SetTimer("FuelTimer", 75000, true);
    SetTimer("InjuredTimer", 5000, true);
    SetTimerEx("RandomFire", 7200000, true, "i", 1);
    SetTimer("UpdateSpeedo", 1000, true);
    SetTimer("ShowHelp", 1000 * 30 * 2, true); // Random Message
    SetTimer("UpdateCarRadars", 300, true);
    SetTimer("RefuelCheck", 10000, true);
    SetTimer("RefuelCheck2", 10000, true);
    SetTimer("Notifications", 5000, true);
    SetTimer("RobberyCountdown", 1000, true);
    SetTimer("CookingTime", 1000, true);
    speedotimer = SetTimer("Speedometer", 555, true);
    // Misc
    LoadServerInfo();
    RefreshTime();
    ResetEvent();
    ResetRobbery();
    LoadSettings();
    return 1;
}
