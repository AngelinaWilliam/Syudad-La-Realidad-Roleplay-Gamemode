#define MAX_GAS_PUMPS 100
#define COLOR_DARKBLUE    (0x1394BFFF)
#define COLOR_EMOTE			0xC2A2DAAA
new FuelTypeAfterRefuel[MAX_VEHICLES+1];

enum pumPlayerInfo
{
	pumpID,
	pumpExists,
	pumpBusiness,
	Float:pumpPos[4],
	PetrolFuel,
	DieselFuel,
	pumpObject,
	Text3D:pumpText3D
};
new PumPlayerInfo[MAX_GAS_PUMPS][pumPlayerInfo];

Pump_Nearest(playerid)
{
    for (new i = 0; i != MAX_GAS_PUMPS; i ++) if (PumPlayerInfo[i][pumpExists] && IsPlayerInRangeOfPoint(playerid, 4.0, PumPlayerInfo[i][pumpPos][0], PumPlayerInfo[i][pumpPos][1], PumPlayerInfo[i][pumpPos][2]) && PumPlayerInfo[i][pumpExists]) {
        return i;
    }
    return -1;
}


Pump_GetFreeID()
{
	for (new i = 0; i < MAX_GAS_PUMPS; i ++) if (!PumPlayerInfo[i][pumpExists]) {
	    return i;
	}
	return -1;
}

Pump_Delete(pumpid)
{
	if (pumpid != -1 && PumPlayerInfo[pumpid][pumpExists])
	{
        format(queryBuffer, sizeof(queryBuffer), "DELETE FROM `pumps` WHERE `pumpID` = '%d'", PumPlayerInfo[pumpid][pumpID]);
        mysql_tquery(connectionID, queryBuffer);

        if (IsValidDynamic3DTextLabel(PumPlayerInfo[pumpid][pumpText3D]))
		    DestroyDynamic3DTextLabel(PumPlayerInfo[pumpid][pumpText3D]);

		if (IsValidDynamicObject(PumPlayerInfo[pumpid][pumpObject]))
		    DestroyDynamicObject(PumPlayerInfo[pumpid][pumpObject]);

		foreach (new i : Player) if (PlayerInfo[i][pGasPump] == pumpid) {
		    StopRefilling(i);
		}
	    PumPlayerInfo[pumpid][pumpExists] = false;
	    PumPlayerInfo[pumpid][PetrolFuel] = 0;
	    PumPlayerInfo[pumpid][DieselFuel] = 0;
	}
	return 1;
}

Pump_Create(playerid, bizid)
{
    static
	    Float:x,
	    Float:y,
	    Float:z,
		Float:angle,
		string[64],
		id = -1;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		if ((id = Pump_GetFreeID()) != -1)
  		{
	        x += 5.0 * floatsin(-angle, degrees);
	        y += 5.0 * floatcos(-angle, degrees);

			PumPlayerInfo[id][pumpExists] = true;
			PumPlayerInfo[id][pumpBusiness] = bizid;
			PumPlayerInfo[id][pumpPos][0] = x;
			PumPlayerInfo[id][pumpPos][1] = y;
			PumPlayerInfo[id][pumpPos][2] = z;
			PumPlayerInfo[id][pumpPos][3] = angle;
            PumPlayerInfo[id][PetrolFuel] = 2000;
            PumPlayerInfo[id][DieselFuel] = 2000;
			PumPlayerInfo[id][pumpObject] = CreateDynamicObject(1676, x, y, z, 0.0, 0.0, angle);

			format(string, sizeof(string), "INSERT INTO `pumps` (`ID`) VALUES(%d)", BusinessInfo[bizid][bID]);
			mysql_tquery(connectionID, string, "OnPumpCreated", "d", id);
			return id;
		}
	}
	return -1;
}

Pump_Refresh(pumpid)
{
	if (pumpid != -1 && PumPlayerInfo[pumpid][pumpExists])
	{
	    static
	        string[128];

        if (IsValidDynamic3DTextLabel(PumPlayerInfo[pumpid][pumpText3D]))
            DestroyDynamic3DTextLabel(PumPlayerInfo[pumpid][pumpText3D]);

		if (IsValidDynamicObject(PumPlayerInfo[pumpid][pumpObject]))
		    DestroyDynamicObject(PumPlayerInfo[pumpid][pumpObject]);


	    format(string, sizeof(string), "[Gas Pump: %d]\n"GREY"Petrol Fuel Left: "WHITE"%d liters\n"YELLOW"Diesel Fuel Left: "WHITE"%d liters", pumpid, PumPlayerInfo[pumpid][PetrolFuel], PumPlayerInfo[pumpid][DieselFuel]);
		PumPlayerInfo[pumpid][pumpText3D] = CreateDynamic3DTextLabel(string, COLOR_DARKBLUE, PumPlayerInfo[pumpid][pumpPos][0], PumPlayerInfo[pumpid][pumpPos][1], PumPlayerInfo[pumpid][pumpPos][2], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
        PumPlayerInfo[pumpid][pumpObject] = CreateDynamicObject(1676, PumPlayerInfo[pumpid][pumpPos][0], PumPlayerInfo[pumpid][pumpPos][1], PumPlayerInfo[pumpid][pumpPos][2], 0.0, 0.0, PumPlayerInfo[pumpid][pumpPos][3]);
	}
	return 1;
}

Pump_Save(pumpid)
{
    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE `pumps` SET `pumpPosX` = '%.4f', `pumpPosY` = '%.4f', `pumpPosZ` = '%.4f', `pumpPosA` = '%.4f', `petrolFuel` = '%d', `dieselFuel` = '%d' WHERE `ID` = '%d' AND `pumpID` = '%d'",
        PumPlayerInfo[pumpid][pumpPos][0],
        PumPlayerInfo[pumpid][pumpPos][1],
        PumPlayerInfo[pumpid][pumpPos][2],
        PumPlayerInfo[pumpid][pumpPos][3],
        PumPlayerInfo[pumpid][PetrolFuel],
        PumPlayerInfo[pumpid][DieselFuel],
        BusinessInfo[PumPlayerInfo[pumpid][pumpBusiness]][bID],
        PumPlayerInfo[pumpid][pumpID]
    );
    return mysql_tquery(connectionID, queryBuffer);
}


stock Business_RemovePumps(bizid)
{
	if (BusinessInfo[bizid][bExists] && BusinessInfo[bizid][bType] == BUSINESS_STORE)
	{
	    static
	        string[32];

	    foreach (new i : Player) if (PlayerInfo[i][pRefuel] != INVALID_VEHICLE_ID && PlayerInfo[i][pGasStation] == bizid)
	    {
	        StopRefilling(i);
	    }
		for (new i = 0; i != MAX_GAS_PUMPS; i ++) if (PumPlayerInfo[i][pumpExists] && PumPlayerInfo[i][pumpBusiness] == bizid)
		{
  			DestroyDynamicObject(PumPlayerInfo[i][pumpObject]);
			DestroyDynamic3DTextLabel(PumPlayerInfo[i][pumpText3D]);

		    PumPlayerInfo[i][pumpExists] = 0;
		    PumPlayerInfo[i][PetrolFuel] = 0;
		    PumPlayerInfo[i][DieselFuel] = 0;
		}
		format(string, sizeof(string), "DELETE FROM `pumps` WHERE `ID` = '%d'", BusinessInfo[bizid][bID]);
		mysql_tquery(connectionID, string);
	}
	return 1;
}

forward OnPumpCreated(pumpid);
public OnPumpCreated(pumpid)
{
    PumPlayerInfo[pumpid][pumpID] = cache_insert_id(connectionID);
	Pump_Save(pumpid);

	return 1;
}

CMD:createpump(playerid, params[])
{
	static id, bizid = -1;

    if (PlayerInfo[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", bizid))
	{
        SM(playerid, COLOR_GREY, "USAGE: /createpump [business id]");
        return 1;
    }

	if ((bizid < 0 || bizid >= MAX_BUSINESSES) || !BusinessInfo[bizid][bExists])
	    return SendErrorMessage(playerid, "You have specified an invalid business ID.");

	if (BusinessInfo[bizid][bType] != BUSINESS_STORE)
	    return SendErrorMessage(playerid, "This business is not a gas station!");

    if (GetPlayerInterior(playerid) > 0 || GetPlayerVirtualWorld(playerid) > 0)
		return SendErrorMessage(playerid, "You can only create gas pumps outside interiors.");

	id = Pump_Create(playerid, bizid);

	if (id == -1)
	    return SendErrorMessage(playerid, "The business has reached the limit for gas pumps.");

	SendServerMessage(playerid, "You have successfully created gas pump ID: %d.", id);
	EditDynamicObject(playerid, PumPlayerInfo[id][pumpObject]);
	PlayerInfo[playerid][pEditPump] = id;
	return 1;
}

CMD:destroypump(playerid, params[])
{
	static
	    id = 0;

    if (PlayerInfo[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroypump [pump id]");

	if ((id < 0 || id >= MAX_GAS_PUMPS) || !PumPlayerInfo[id][pumpExists])
	    return SendErrorMessage(playerid, "Invalid pump ID.");

	Pump_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed pump ID: %d.", id);
	return 1;
}

CMD:setpump(playerid, params[])
{
	static
	    id = 0,
		amount;

    if (PlayerInfo[playerid][pAdmin] < 5)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "dd", id, amount))
	    return SendSyntaxMessage(playerid, "/setpump [pump id] [fuel amount]");

	if ((id < 0 || id >= MAX_GAS_PUMPS) || !PumPlayerInfo[id][pumpExists])
	    return SendErrorMessage(playerid, "Invalid pump ID.");


	PumPlayerInfo[id][DieselFuel] = amount;
	PumPlayerInfo[id][PetrolFuel] = amount;

	Pump_Refresh(id);
	Pump_Save(id);

	SendServerMessage(playerid, "You have set the fuel to %d for pump ID: %d.", amount, id);
	return 1;
}
