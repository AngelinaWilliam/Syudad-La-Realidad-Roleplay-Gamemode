// -----------------------------------------------------------------------------
            /*  ---------------- BACKPACK DEFINES ----------------- */
#define 		MAX_BACKPACKS               2000
#define 		MAX_STOREGUN                9  /* Array starts on 0 */
#define         DIALOG_EDITMAINBACKPACK     6000
#define         DIALOG_EDITITEMS            6001
#define         DIALOG_CHANGESIZE        	6002
#define         DIALOG_BACKPACKMENU         6005 // For Player Dialog /mybackpack or /mybp
#define         DIALOG_ACTIONBACKPACKMENU   6006
#define         DIALOG_PUTAKEITEMS   		6007
	/*     Limit Item Types       */
#define 		LIMIT_CASH 					0
#define 		LIMIT_POT 					1
#define 		LIMIT_CRACK 				2
#define 		LIMIT_MATS 					3
#define 		LIMIT_GUN 					4
#define 		LIMIT_AMMO					5
    /*         Item Types        */
#define 		BITEM_CASH 					1
#define 		ITEM_POT  					2
#define 		ITEM_CRACK					3
#define 		ITEM_MATS 					4
#define 		ITEM_GUNS 					5
#define 		ITEM_AMMO 					6
	/*         Edit Types        */
#define         TYPE_OWNER                  1
#define         TYPE_CASH                  	2
#define         TYPE_POT                    3
#define         TYPE_CRACK                 	4
#define         TYPE_MATS                   5
#define         TYPE_GUN1                  	6
#define         TYPE_GUN2                   7
#define         TYPE_GUN3                  	8
#define         TYPE_GUN4                   9
#define         TYPE_GUN5                   10
#define         TYPE_GUN6                   11
#define         TYPE_GUN7                   12
#define         TYPE_GUN8                   13
// ---------


enum sInfo
{
	sBackpackCreated,
	sBackpackOwner,
	sBackpackOwnerName[MAX_PLAYER_NAME],
	sBackpackSize,
	sAttached,
	sObj,
	Float:sPos[3],
	sVirtualWorld,
	sInteriorWorld,
	sCash,
	sPot,
	sCrack,
	sMats,
	sGun[MAX_STOREGUN],
	sAmmo[MAX_STOREGUN],
};
new BackpackInfo[MAX_BACKPACKS][sInfo];
new const onhandlimit[] = { 1000000, 50, 50, 50000};
new sbackpacklimit[] = { 3000000, 70, 70, 100000, 3};
new mbackpacklimit[] = { 5000000, 100,  100, 200000, 5};
new lbackpacklimit[] = { 8000000, 150, 150, 300000, 8};
new countplayerbackpacks[MAX_PLAYERS];
new backpackid[MAX_PLAYERS];
new storagetype[][] = { "Pocket", "Small Backpack", "Medium Backpack", "Large Backpack"};

// LoadBackpacks(playerid)
// Description: Load the backpacks of the server
stock LoadBackpacks() {
    for(new i = 0; i < MAX_BACKPACKS; i++) {
		BackpackInfo[i][sBackpackOwner] = -1;
		BackpackInfo[i][sBackpackSize] = 0;
		format(BackpackInfo[i][sBackpackOwnerName], MAX_PLAYER_NAME, "Nobody");
		BackpackInfo[i][sAttached] = 0;
		BackpackInfo[i][sPos][0] = 0.0;
		BackpackInfo[i][sPos][1] = 0.0;
		BackpackInfo[i][sPos][2] = 0.0;
		BackpackInfo[i][sVirtualWorld] = -1;
		BackpackInfo[i][sInteriorWorld] = -1;
		BackpackInfo[i][sCash] = 0;
		BackpackInfo[i][sPot] = 0;
		BackpackInfo[i][sCrack] = 0;
		BackpackInfo[i][sMats] = 0;
		for(new weaponid; weaponid<MAX_STOREGUN; weaponid++) {
			BackpackInfo[i][sGun][weaponid] = 0;
			BackpackInfo[i][sAmmo][weaponid] = 0;
		}
    }
    mysql_new_query(connectionID, "SELECT * FROM `playerbackpack`", true, "OnLoadBackpacks", "i", SENDDATA_THREAD);
}
stock SaveBackpacks() {
    new string[2048];
	for(new i = 0; i < MAX_BACKPACKS; i++) {
		if(BackpackInfo[i][sBackpackCreated]) {
			format(string, sizeof(string), "UPDATE `playerbackpack` SET \
			    `BackpackCreated`=%d, \
				`BackpackOwner`=%d, \
				`BackpackOwnerName`='%s', \
				`BackpackSize`=%d, \
				`Attached`=%d, \
				`PosX`=%f, \
				`PosY`=%f, \
				`PosZ`=%f, \
				`VirtualWorld`=%d, \
				`InteriorWorld`=%d, \
				`Cash`=%d, \
				`Pot`=%d, \
				`Crack`=%d, \
				`Mats`=%d,",
				BackpackInfo[i][sBackpackCreated],
				BackpackInfo[i][sBackpackOwner],
				g_mysql_ReturnEscaped(BackpackInfo[i][sBackpackOwnerName], connectionID),
				BackpackInfo[i][sBackpackSize],
				BackpackInfo[i][sAttached],
				BackpackInfo[i][sPos][0],
				BackpackInfo[i][sPos][1],
				BackpackInfo[i][sPos][2],
				BackpackInfo[i][sVirtualWorld],
				BackpackInfo[i][sInteriorWorld],
				BackpackInfo[i][sCash],
				BackpackInfo[i][sPot],
				BackpackInfo[i][sCrack],
				BackpackInfo[i][sMats]
			);
			for(new weaponid; weaponid<MAX_STOREGUN; weaponid++) {
			    if(weaponid == MAX_STOREGUN-1) {
				    format(string, sizeof(string), "%s \
	  					`Gun%d`=%d, `Ammo%d`=%d WHERE `ID` = %d",
						string,
						weaponid,
						BackpackInfo[i][sGun][weaponid],
						weaponid,
						BackpackInfo[i][sAmmo][weaponid],
						i+1
					);
				}
				else {
				    format(string, sizeof(string), "%s \
	  					`Gun%d`=%d, `Ammo%d`=%d,",
						string,
						weaponid,
						BackpackInfo[i][sGun][weaponid],
						weaponid,
						BackpackInfo[i][sAmmo][weaponid]
					);
				}
			}
			mysql_new_query(connectionID, string, false, "OnQueryFinished", "i", SENDDATA_THREAD);
		}
	}
	return 1;
}

stock SaveBackpack(i) {
	if(i == MAX_BACKPACKS+1) return 1;
	new string[2000];
	format(string, sizeof(string), "UPDATE `playerbackpack` SET \
	    `BackpackCreated`=%d, \
		`BackpackOwner`=%d, \
		`BackpackOwnerName`='%s', \
		`BackpackSize`=%d, \
		`Attached`=%d, \
		`PosX`=%f, \
		`PosY`=%f, \
		`PosZ`=%f, \
		`VirtualWorld`=%d, \
		`InteriorWorld`=%d, \
		`Cash`=%d, \
		`Pot`=%d, \
		`Crack`=%d, \
		`Mats`=%d,",
		BackpackInfo[i][sBackpackCreated],
		BackpackInfo[i][sBackpackOwner],
		g_mysql_ReturnEscaped(BackpackInfo[i][sBackpackOwnerName], connectionID),
		BackpackInfo[i][sBackpackSize],
		BackpackInfo[i][sAttached],
		BackpackInfo[i][sPos][0],
		BackpackInfo[i][sPos][1],
		BackpackInfo[i][sPos][2],
		BackpackInfo[i][sVirtualWorld],
		BackpackInfo[i][sInteriorWorld],
		BackpackInfo[i][sCash],
		BackpackInfo[i][sPot],
		BackpackInfo[i][sCrack],
		BackpackInfo[i][sMats]
	);
	for(new weaponid; weaponid<MAX_STOREGUN; weaponid++) {
	    if(weaponid == MAX_STOREGUN-1) {
		    format(string, sizeof(string), "%s \
					`Gun%d`=%d, `Ammo%d`=%d WHERE `ID` = %d",
				string,
				weaponid,
				BackpackInfo[i][sGun][weaponid],
				weaponid,
				BackpackInfo[i][sAmmo][weaponid],
				i+1
			);
		}
		else {
		    format(string, sizeof(string), "%s \
					`Gun%d`=%d, `Ammo%d`=%d,",
				string,
				weaponid,
				BackpackInfo[i][sGun][weaponid],
				weaponid,
				BackpackInfo[i][sAmmo][weaponid]
			);
		}
	}
	mysql_new_query(connectionID, string, false, "OnQueryFinished", "i", SENDDATA_THREAD);
	return 1;

}
forward OnLoadBackpacks();
public OnLoadBackpacks()
{
    new i, rows, fields, szField[24], tmp[128];
	cache_get_data(rows, fields, connectionID);
	while(i < rows)
	{
	    cache_get_field_content(i, "BackpackCreated", tmp, connectionID); BackpackInfo[i][sBackpackCreated] = strval(tmp);
		cache_get_field_content(i, "BackpackOwner", tmp, connectionID); BackpackInfo[i][sBackpackOwner] = strval(tmp);
		cache_get_field_content(i, "BackpackOwnerName", BackpackInfo[i][sBackpackOwnerName], connectionID, MAX_PLAYER_NAME);
		cache_get_field_content(i, "BackpackSize", tmp, connectionID); BackpackInfo[i][sBackpackSize] = strval(tmp);
		cache_get_field_content(i, "Attached", tmp, connectionID); BackpackInfo[i][sAttached] = strval(tmp);
		cache_get_field_content(i, "PosX", tmp, connectionID); BackpackInfo[i][sPos][0] = floatstr(tmp);
		cache_get_field_content(i, "PosY", tmp, connectionID); BackpackInfo[i][sPos][1] = floatstr(tmp);
		cache_get_field_content(i, "PosZ", tmp, connectionID); BackpackInfo[i][sPos][2] = floatstr(tmp);
		cache_get_field_content(i, "VirtualWorld", tmp, connectionID); BackpackInfo[i][sVirtualWorld] = strval(tmp);
		cache_get_field_content(i, "InteriorWorld", tmp, connectionID); BackpackInfo[i][sInteriorWorld] = strval(tmp);
		cache_get_field_content(i, "Cash", tmp, connectionID); BackpackInfo[i][sCash] = strval(tmp);
		cache_get_field_content(i, "Pot", tmp, connectionID); BackpackInfo[i][sPot] = strval(tmp);
		cache_get_field_content(i, "Crack", tmp, connectionID); BackpackInfo[i][sCrack] = strval(tmp);
		cache_get_field_content(i, "Mats", tmp, connectionID); BackpackInfo[i][sMats] = strval(tmp);
		for(new weaponid; weaponid<MAX_STOREGUN; weaponid++) 
		{
            format(szField, sizeof(szField), "Gun%d", weaponid);
            format(szField, sizeof(szField), "Ammo%d", weaponid);
			cache_get_field_content(i, szField, tmp, connectionID);
			BackpackInfo[i][sGun][weaponid] = strval(tmp);
			BackpackInfo[i][sAmmo][weaponid] = strval(tmp);
		}
		if(BackpackInfo[i][sBackpackCreated] == 1 && BackpackInfo[i][sAttached] != 1) {
			switch(BackpackInfo[i][sBackpackSize]) {
		        case 1: BackpackInfo[i][sObj] = CreateDynamicObject(3026, BackpackInfo[i][sPos][0], BackpackInfo[i][sPos][1], BackpackInfo[i][sPos][2], -90, 0, 90, BackpackInfo[i][sVirtualWorld], BackpackInfo[i][sInteriorWorld], -1, .streamdistance = 100.0), SetDynamicObjectMaterial(BackpackInfo[i][sObj],0, -1, "none", "none", 0xFF00FF00);
			    case 2: BackpackInfo[i][sObj] = CreateDynamicObject(3026, BackpackInfo[i][sPos][0], BackpackInfo[i][sPos][1], BackpackInfo[i][sPos][2], -90, 0, 90, BackpackInfo[i][sVirtualWorld], BackpackInfo[i][sInteriorWorld], -1, .streamdistance = 100.0), SetDynamicObjectMaterial(BackpackInfo[i][sObj],0, -1, "none", "none", 0xFFFF0000);
			    case 3: BackpackInfo[i][sObj] = CreateDynamicObject(3026, BackpackInfo[i][sPos][0], BackpackInfo[i][sPos][1], BackpackInfo[i][sPos][2], -90, 0, 90, BackpackInfo[i][sVirtualWorld], BackpackInfo[i][sInteriorWorld], -1, .streamdistance = 100.0), SetDynamicObjectMaterial(BackpackInfo[i][sObj],0, -1, "none", "none", 0xFF0000FF);
			}
		}
		i++;
	}
	if(i > 0) printf("[Backpacks] %d Backpacks rehashed/loaded.", i);
	else printf("[Backpacks] Failed to load any Backpacks.");
	return 1;
}
stock ShowBackpackActionChoice(playerid) {
	switch(GetPVarInt(playerid, "Listitem_Backpack")) {
	    case 0: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Cash\nTake Cash", "Choose", "Back");
		case 1: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weed\nTake Weed", "Choose", "Back");
		case 2: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Cocaine\nTake Cocaine", "Choose", "Back");
		case 3: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Materials\nTake Materials", "Choose", "Back");
		case 4: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 1\nTake Weapon from slot 1", "Choose", "Back");
		case 5: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 2\nTake Weapon from slot 2", "Choose", "Back");
		case 6: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 3\nTake Weapon from slot 3", "Choose", "Back");
		case 7: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 4\nTake Weapon from slot 4", "Choose", "Back");
		case 8: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 5\nTake Weapon from slot 5", "Choose", "Back");
		case 9: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 6\nTake Weapon from slot 6", "Choose", "Back");
		case 10: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 7\nTake Weapon from slot 7", "Choose", "Back");
		case 11: ShowPlayerDialog(playerid, DIALOG_ACTIONBACKPACKMENU, DIALOG_STYLE_LIST, "Put/Take Items in your Backpack", "Put Weapon to slot 8\nTake Weapon from slot 8", "Choose", "Back");
	}
	return 1;
}
stock ShowPlayerBackpack(playerid)
{
	new stringex[2000], index = GetPlayerBackpackID(playerid),title[64];
	if(!IsBackpackEquipped(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You don't have any Backpack Equipped");
    format(stringex,sizeof(stringex),
		"Items:\tInformation:\n\
		Cash:\t$%s \n\
		Weed:\t%sg \n\
		Cocaine:\t%sg \n\
		Mats:\t%s\n",
		number_format(BackpackInfo[index][sCash]),
		number_format(BackpackInfo[index][sPot]),
		number_format(BackpackInfo[index][sCrack]),
		number_format(BackpackInfo[index][sMats])
	);
	if(BackpackInfo[index][sBackpackSize] == 1) {
		format(stringex,sizeof(stringex),
			"%s\
			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s",
			stringex,
			GetWeaponNameEx(BackpackInfo[index][sGun][0]),
			GetWeaponNameEx(BackpackInfo[index][sGun][1]),
			GetWeaponNameEx(BackpackInfo[index][sGun][2])
		);
	}
	else if(BackpackInfo[index][sBackpackSize] == 2) {
		format(stringex,sizeof(stringex),
			"%s\
			Gun:\t%s \n\
			Gun:\t%s \n\
   			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s",
			stringex,
			GetWeaponNameEx(BackpackInfo[index][sGun][0]),
			GetWeaponNameEx(BackpackInfo[index][sGun][1]),
			GetWeaponNameEx(BackpackInfo[index][sGun][2]),
			GetWeaponNameEx(BackpackInfo[index][sGun][3]),
			GetWeaponNameEx(BackpackInfo[index][sGun][4])
		);
	}
	else if(BackpackInfo[index][sBackpackSize] == 3) {
		format(stringex,sizeof(stringex),
			"%s\
			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s \n\
			Gun:\t%s",
			stringex,
			GetWeaponNameEx(BackpackInfo[index][sGun][0]),
			GetWeaponNameEx(BackpackInfo[index][sGun][1]),
			GetWeaponNameEx(BackpackInfo[index][sGun][2]),
			GetWeaponNameEx(BackpackInfo[index][sGun][3]),
			GetWeaponNameEx(BackpackInfo[index][sGun][4]),
			GetWeaponNameEx(BackpackInfo[index][sGun][5]),
			GetWeaponNameEx(BackpackInfo[index][sGun][6]),
			GetWeaponNameEx(BackpackInfo[index][sGun][7])
		);
	}
	format(title,sizeof(title), "{FFFFFF}My %s (ID: %d) Information", GetBackpackSize(index),index);
	ShowPlayerDialog(playerid, DIALOG_BACKPACKMENU, DIALOG_STYLE_TABLIST_HEADERS, title, stringex, "Choose", "Close");
	return 1;
}
stock ShowEditBackpackDialog(playerid, index) {
    new stringex[2000];
    format(stringex,sizeof(stringex),
		"Name\tInformations\t\n" \
	    "Backpack Owner:\t%s \n" \
     	"Size:\t%s \n" \
		"Cash:\t$%s \n" \
		"Weed:\t%sg \n" \
		"Cocaine:\t%sg \n" \
		"Mats:\t%s\n",
    	GetBackpackOwner(index),
    	GetBackpackSize(index),
		number_format(BackpackInfo[index][sCash]),
		number_format(BackpackInfo[index][sPot]),
		number_format(BackpackInfo[index][sCrack]),
		number_format(BackpackInfo[index][sMats])
	);
	if(BackpackInfo[index][sBackpackSize] == 1) {
		format(stringex,sizeof(stringex),
			"%s" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s",
			stringex,
			GetWeaponNameEx(BackpackInfo[index][sGun][0]),
			GetWeaponNameEx(BackpackInfo[index][sGun][1]),
			GetWeaponNameEx(BackpackInfo[index][sGun][2])
		);
	}
	else if(BackpackInfo[index][sBackpackSize] == 2) {
		format(stringex,sizeof(stringex),
			"%s" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s",
			stringex,
			GetWeaponNameEx(BackpackInfo[index][sGun][0]),
			GetWeaponNameEx(BackpackInfo[index][sGun][1]),
			GetWeaponNameEx(BackpackInfo[index][sGun][2]),
			GetWeaponNameEx(BackpackInfo[index][sGun][3]),
			GetWeaponNameEx(BackpackInfo[index][sGun][4])
		);
	}
	else if(BackpackInfo[index][sBackpackSize] == 3) {
		format(stringex,sizeof(stringex),
			"%s" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s \n" \
			"Gun:\t%s",
			stringex,
			GetWeaponNameEx(BackpackInfo[index][sGun][0]),
			GetWeaponNameEx(BackpackInfo[index][sGun][1]),
			GetWeaponNameEx(BackpackInfo[index][sGun][2]),
			GetWeaponNameEx(BackpackInfo[index][sGun][3]),
			GetWeaponNameEx(BackpackInfo[index][sGun][4]),
			GetWeaponNameEx(BackpackInfo[index][sGun][5]),
			GetWeaponNameEx(BackpackInfo[index][sGun][6]),
			GetWeaponNameEx(BackpackInfo[index][sGun][7])
		);
	}
	if(!BackpackInfo[index][sAttached] && BackpackInfo[index][sBackpackOwner] == -1) strcat(stringex, "\nEdit Position");
	strcat(stringex, "\nDelete Backpack");
	new title[64];
	format(title,sizeof(title), "Backpack ID (%d) Information", index);
	if(PlayerInfo[playerid][pAdmin] == 7) ShowPlayerDialog(playerid, DIALOG_EDITMAINBACKPACK, DIALOG_STYLE_TABLIST_HEADERS, title, stringex, "Edit", "Close");
	else ShowPlayerDialog(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, title, stringex, "Close", "");
	SetPVarInt(playerid, "BackpackID", index);
	return 1;
}

stock GetBackpackSize(id, color = 1) {
	new string[64];
	if(color)
	{
		switch(BackpackInfo[id][sBackpackSize]) {
			case 1: format(string,sizeof(string), "{00FF00}Small Backpack{FFFFFF}");
			case 2: format(string,sizeof(string), "{FF0000}Medium Backpack{FFFFFF}");
			case 3: format(string,sizeof(string), "{0000FF}Large Backpack{FFFFFF}");
		}
	}
	else
	{
	    switch(BackpackInfo[id][sBackpackSize]) {
			case 1: format(string,sizeof(string), "Small Backpack");
			case 2: format(string,sizeof(string), "Medium Backpack");
			case 3: format(string,sizeof(string), "Large Backpack");
		}
	}
	return string;
}
stock GetBackpackOwner(id) {
	new string[100];
	if(BackpackInfo[id][sBackpackOwner] != -1) format(string,sizeof(string), "[SQLID:%d] - %s",BackpackInfo[id][sBackpackOwner], BackpackInfo[id][sBackpackOwnerName]);
	else if(BackpackInfo[id][sBackpackOwner] == -1) format(string,sizeof(string), "Nobody");
	return string;
}
stock DropBackpack(playerid) {
    new id = GetPlayerBackpackID(playerid), string[128];
	if(IsBackpackEquipped(playerid)) {
	    if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
	    format(string, sizeof(string), " Player %s has Drop the %s (ID: %d)", GetPlayerNameEx(playerid),GetPlayerStorageType(playerid), id);
        //////Log("logs/backpack.log", string);
		BackpackInfo[id][sAttached] = 0;
		BackpackInfo[id][sBackpackOwner] = -1;
		GetPlayerPos(playerid, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2]);
		BackpackInfo[id][sPos][2] = (BackpackInfo[id][sPos][2] - 1.0);
        BackpackInfo[id][sVirtualWorld] = GetPlayerVirtualWorld(playerid);
        BackpackInfo[id][sInteriorWorld] = GetPlayerInterior(playerid);
        format(BackpackInfo[id][sBackpackOwnerName], MAX_PLAYER_NAME, "Nobdy");
        SaveBackpack(id);
		switch(BackpackInfo[id][sBackpackSize]) {
		    case 1: BackpackInfo[id][sObj] = CreateDynamicObject(3026, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2], -90, 0, 90, BackpackInfo[id][sVirtualWorld], BackpackInfo[id][sInteriorWorld], -1, 200.0), SetDynamicObjectMaterial(BackpackInfo[id][sObj],0, -1, "none", "none", 0xFF00FF00);
		    case 2: BackpackInfo[id][sObj] = CreateDynamicObject(3026, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2], -90, 0, 90, BackpackInfo[id][sVirtualWorld], BackpackInfo[id][sInteriorWorld], -1, 200.0), SetDynamicObjectMaterial(BackpackInfo[id][sObj],0, -1, "none", "none", 0xFFFF0000);
		    case 3: BackpackInfo[id][sObj] = CreateDynamicObject(3026, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2], -90, 0, 90, BackpackInfo[id][sVirtualWorld], BackpackInfo[id][sInteriorWorld], -1, 200.0), SetDynamicObjectMaterial(BackpackInfo[id][sObj],0, -1, "none", "none", 0xFF0000FF);
		}
		backpackid[playerid] = MAX_BACKPACKS+1;
		ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_In", 4.0, 0, 0, 0, 0, 0, 1);
		return 1;
	}
	return 1;
}
stock IsAnyBackpackNear(playerid) {
    for(new id; id<MAX_BACKPACKS; id++) {
	    if(BackpackInfo[id][sBackpackCreated] && !BackpackInfo[id][sAttached] && IsPlayerInRangeOfPoint(playerid, 5, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2]) && GetPlayerInterior(playerid) == BackpackInfo[id][sInteriorWorld] && GetPlayerVirtualWorld(playerid) == BackpackInfo[id][sVirtualWorld]) {
			return 1;
		}
	}
	return 0;
}
stock IsPlayerNearBackpack(playerid) {
    for(new id; id<MAX_BACKPACKS; id++) {
	    if(BackpackInfo[id][sBackpackCreated] && BackpackInfo[id][sAttached] != 1 && BackpackInfo[id][sBackpackOwner] == -1) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2]) && GetPlayerInterior(playerid) == BackpackInfo[id][sInteriorWorld] && GetPlayerVirtualWorld(playerid) == BackpackInfo[id][sVirtualWorld]) {
				return id;
			}
		}
	}
	return MAX_BACKPACKS+1;

}

stock BackpackLimit(size,type) {
	switch(size) {
		case 1:{
		    switch(type){
				case LIMIT_CASH: return sbackpacklimit[LIMIT_CASH];
				case LIMIT_POT: return sbackpacklimit[LIMIT_POT];
				case LIMIT_CRACK: return sbackpacklimit[LIMIT_CRACK];
				case LIMIT_MATS: return sbackpacklimit[LIMIT_MATS];
				case LIMIT_GUN: return sbackpacklimit[LIMIT_GUN];
			}
		}
		case 2:{
		    switch(type){
				case LIMIT_CASH: return mbackpacklimit[LIMIT_CASH];
				case LIMIT_POT: return mbackpacklimit[LIMIT_POT];
				case LIMIT_CRACK: return mbackpacklimit[LIMIT_CRACK];
				case LIMIT_MATS: return mbackpacklimit[LIMIT_MATS];
				case LIMIT_GUN: return mbackpacklimit[LIMIT_GUN];
			}
		}
		case 3: {
		    switch(type){
				case LIMIT_CASH: return lbackpacklimit[LIMIT_CASH];
				case LIMIT_POT: return lbackpacklimit[LIMIT_POT];
				case LIMIT_CRACK: return lbackpacklimit[LIMIT_CRACK];
				case LIMIT_MATS: return lbackpacklimit[LIMIT_MATS];
				case LIMIT_GUN: return lbackpacklimit[LIMIT_GUN];
			}
		}
	}
	return -1;
}


stock EquipeBackpack(playerid, id) {
	new string[128];
    if(!BackpackInfo[id][sAttached]) {
        format(string, sizeof(string), " Player %s has Pickup the %s (ID: %d)", GetPlayerNameEx(playerid),storagetype[BackpackInfo[id][sBackpackSize]], id);
        //////Log("logs/backpack.log", string);
        DestroyDynamicObject(BackpackInfo[id][sObj]);
        BackpackInfo[id][sPos][0] = 0.0;
		BackpackInfo[id][sPos][1] = 0.0;
		BackpackInfo[id][sPos][2] = 0.0;
		BackpackInfo[id][sVirtualWorld] = -1;
		BackpackInfo[id][sInteriorWorld] = -1;
		format(BackpackInfo[id][sBackpackOwnerName], MAX_PLAYER_NAME, GetPlayerNameEx(playerid));
		if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
	    switch(BackpackInfo[id][sBackpackSize]) {
		    case 1: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.152, -0.069, 0, 0, 0, 0, 1, 1);
		    case 2: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.152, -0.069, 0, 0, 0, 0, 1, 1);
		    case 3: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
		}
		BackpackInfo[id][sBackpackOwner] = GetPlayerSQLId(playerid);
		BackpackInfo[id][sAttached] = 1;
		backpackid[playerid] = id;
		SaveBackpack(id);
		return 1;
	}
	else SendClientMessageEx(playerid, COLOR_GREY, "An Error occur when attempting to equip the Backpack");
	return 1;
}
stock IsBackpackEquipped(playerid) {
	if(GetPlayerBackpackID(playerid) != MAX_BACKPACKS+1) return 1;
	else return 0;
}
stock GetPlayerBackpackID(playerid) return backpackid[playerid];

stock LoadPlayerBackpack(playerid) {
    for(new i; i < MAX_BACKPACKS; i++) {
		if(BackpackInfo[i][sBackpackCreated] && BackpackInfo[i][sBackpackOwner] == GetPlayerSQLId(playerid) && BackpackInfo[i][sAttached] == 1) {
		    if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
		    switch(BackpackInfo[i][sBackpackSize]) {
			    case 1: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.152, -0.069, 0, 0, 0, 0, 1, 1);
			    case 2: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.152, -0.069, 0, 0, 0, 0, 1, 1);
			    case 3: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062);
			}
			backpackid[playerid] = i;
			i = MAX_BACKPACKS+1;
		}
	}
	return 1;
}
stock GetPlayerStorageType(playerid) {
	new id = GetPlayerBackpackID(playerid);
	new string[32];
	format(string,sizeof(string), "%s",storagetype[BackpackInfo[id][sBackpackSize]]);
	return string;
}
stock g_mysql_ReturnEscaped(unEscapedString[], connectionHandle)
{
	new EscapedString[256];
	mysql_real_escape_string(unEscapedString, EscapedString, connectionHandle);
	return EscapedString;
}

stock GetPlayerSQLId(playerid)
{
	return PlayerInfo[playerid][pID];
}
stock ABroadCast(hColor, szMessage[], iLevel) {
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pAdmin] >= iLevel) {
			SendClientMessageEx(i, hColor, szMessage);
		}
	}
	return 1;
}
stock IsRoleplayWeapon(weaponid) {
	switch(weaponid) {
		case 1..3,5..8,10..16,22..34: return 1;
	}
	return 0;
}

stock GetPlayerNameExt(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

CMD:backpackhelp(playerid) {
    new string[3000];
    //strcat(string, "{FFFF00}Developed by ToiletDuck");
    strcat(string, "\n{FF00FF}Information:{FFFFFF}");
    strcat(string, "\nThere are Three types of Backpack.\t{00FF00}Small Backpack {FF0000}Medium Backpack {0000FF}Large Backpack{FFFFFF}");
    strcat(string, "\n\n{FF8000}<Backpacks>/<Pocket> Sizes and Capacity:{FFFFFF}");
    strcat(string, "\n\n\n>>> {00FF00}Small Backpack Storage Capacity{FFFFFF} <<<");
    format(string, sizeof(string), "%s\n\t" \
         "-Maximum Cash that can be stored: {00FFFF}$%s Cash{FFFFFF}\n\t" \
         "-Maximum Weed that can be stored: {00FFFF}%sg Weed{FFFFFF}\n\t" \
         "-Maximum Cocaine that can be stored: {00FFFF}%sg Cocaine{FFFFFF}\n\t" \
         "-Maximum Materials that can be stored: {00FFFF}%s Materials{FFFFFF}\n\t" \
         "-Maximum Weapons that can be stored: {00FFFF}3 Weapons{FFFFFF}",
         string,
         number_format(sbackpacklimit[LIMIT_CASH]),
         number_format(sbackpacklimit[LIMIT_POT]),
         number_format(sbackpacklimit[LIMIT_CRACK]),
         number_format(sbackpacklimit[LIMIT_MATS])
    );
    strcat(string, "\n\n>>> {FF0000}Medium Backpack Storage Capacity{FFFFFF} <<<");
    format(string, sizeof(string), "%s\n\t" \
         "-Maximum Cash that can be stored: {00FFFF}$%s Cash{FFFFFF}\n\t" \
         "-Maximum Weed that can be stored: {00FFFF}%sg Weed{FFFFFF}\n\t" \
         "-Maximum Cocaine that can be stored: {00FFFF}%sg Cocaine{FFFFFF}\n\t" \
         "-Maximum Materials that can be stored: {00FFFF}%s Materials{FFFFFF}\n\t" \
         "-Maximum Weapons that can be stored: {00FFFF}5 Weapons{FFFFFF}",
         string,
         number_format(mbackpacklimit[LIMIT_CASH]),
         number_format(mbackpacklimit[LIMIT_POT]),
         number_format(mbackpacklimit[LIMIT_CRACK]),
         number_format(mbackpacklimit[LIMIT_MATS])
    );
    strcat(string, "\n\n>>> {0000FF}Large Backpack Storage Capacity{FFFFFF} <<<");
    format(string, sizeof(string), "%s\n\t" \
         "-Maximum Cash that can be stored: {00FFFF}$%s Cash{FFFFFF}\n\t" \
         "-Maximum Weed that can be stored: {00FFFF}%sg Weed{FFFFFF}\n\t" \
         "-Maximum Cocaine that can be stored: {00FFFF}%sg Cocaine{FFFFFF}\n\t" \
         "-Maximum Materials that can be stored: {00FFFF}%s Materials{FFFFFF}\n\t" \
         "-Maximum Weapons that can be stored: {00FFFF}8 Weapons{FFFFFF}",
         string,
         number_format(lbackpacklimit[LIMIT_CASH]),
         number_format(lbackpacklimit[LIMIT_POT]),
         number_format(lbackpacklimit[LIMIT_CRACK]),
         number_format(lbackpacklimit[LIMIT_MATS])
    );
    strcat(string, "\n\n{9ACD32}Commands List:{FFFFFF}");
    strcat(string, "\n/mybackpack\t/pickbackpack");
    if(PlayerInfo[playerid][pAdmin] > 3) strcat(string, "\n{FF3080}Admin Commands List:{FFFFFF}\n/gotobp\t/bpnear\t/bpstatus\t/createbackpack\t/checkbp");
    strcat(string, "\n\n\n{FFFFFF}Notice:\n\t{FF8000} This only a Version 1 so expect more changes in the System :) Have fun enjoy the updates!");
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "** {007FFF}Dynamic Backpack System Version 1 of "#SERVER_NAME"{FFFFFF} **", string, "Like", "");
    return 1;
}

CMD:mybp(playerid) return callcmd::mybackpack(playerid);
CMD:mybackpack(playerid) {
    if(GetPVarType(playerid, "ge_Participant")) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot do this right now!");
    if(!IsBackpackEquipped(playerid)) return SendClientMessageEx(playerid, COLOR_RED, "You dont have any backpack Equipped");

    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pPaintball] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJailTime] > 0 || GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are unable to use your backpack at the moment.");
    }
    new rpstring[128];
    new id = GetPlayerBackpackID(playerid);
    if(!IsPlayerInAnyVehicle(playerid))
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
        ApplyAnimation(playerid,"BOMBER","BOM_Plant_Crouch_Out",4.1,0,0,0,1,0,1);
        format(rpstring, sizeof(rpstring), "put their %s on the ground and opens it", GetPlayerStorageType(playerid));
        callcmd::me(playerid, rpstring);
        switch(BackpackInfo[id][sBackpackSize]) {
            case 1: SetPlayerAttachedObject(playerid, 9, 3026, 8, 0.595996, 0.061999, -0.293000, -156.600006, 168.399993, -51.000000, 1, 1, 1, 0xFF00FF00, 0xFF00FF00);
            case 2: SetPlayerAttachedObject(playerid, 9, 3026, 8, 0.595996, 0.061999, -0.293000, -156.600006, 168.399993, -51.000000, 1, 1, 1, 0xFFFF0000, 0xFFFF0000);
            case 3: SetPlayerAttachedObject(playerid, 9, 3026, 8, 0.595996, 0.061999, -0.293000, -156.600006, 168.399993, -51.000000, 1, 1, 1, 0xFF0000FF, 0xFF0000FF);
        }

    }
    else {
        format(rpstring, sizeof(rpstring), "Put their %s onto their Lap and opens it", GetPlayerStorageType(playerid));
        callcmd::me(playerid, rpstring);
    }
    ShowPlayerBackpack(playerid);
    return 1;
}

CMD:gotobp(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 5)
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
//  if(AdminOnDuty[playerid] != true && PlayerInfo[playerid][pAdmin] < GENERAL_MANAGER)
//      return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin. To access your admin commands you must be on-duty. Type /aduty to go on-duty.");
    new index, string[128];
    if(sscanf(params, "d", index)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /gotobp [Backpack ID]");
    if(!BackpackInfo[index][sBackpackCreated]) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Backpack ID");
    if(BackpackInfo[index][sBackpackOwner] != -1 && BackpackInfo[index][sAttached]) return SendClientMessageEx(playerid, COLOR_GREY, "Backpack is already owned and equipped by someone");
    if(BackpackInfo[index][sPos][0] == 0.0) return SendClientMessageEx(playerid, COLOR_GREY, "An error occur while teleporting to a Backpack");
    SetPlayerInterior(playerid, BackpackInfo[index][sInteriorWorld]);
    SetPlayerPos(playerid, BackpackInfo[index][sPos][0], BackpackInfo[index][sPos][1], BackpackInfo[index][sPos][2]+1.0);
    PlayerInfo[playerid][pInterior] = BackpackInfo[index][sInteriorWorld];
    SetPlayerVirtualWorld(playerid, BackpackInfo[index][sVirtualWorld]);
    PlayerInfo[playerid][pWorld] = BackpackInfo[index][sVirtualWorld];
    if(BackpackInfo[index][sVirtualWorld] != 0 || BackpackInfo[index][sInteriorWorld] != 0)
    format(string,sizeof(string), "Backpack Informations: %s (ID: %d) | Backpack VW: %d | Backpack Int: %d", GetBackpackSize(index),index ,BackpackInfo[index][sVirtualWorld], BackpackInfo[index][sInteriorWorld]);
    SendClientMessageEx(playerid, COLOR_WHITE, string);
    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);
    return 1;
}
CMD:bpnear(playerid, params[]) {
    if(PlayerInfo[playerid][pAdmin] < 5)
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
//  if(AdminOnDuty[playerid] != true && PlayerInfo[playerid][pAdmin] < GENERAL_MANAGER)
//      return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin. To access your admin commands you must be on-duty. Type /aduty to go on-duty.");
    SendClientMessageEx(playerid, COLOR_RED, "* Listing all Dynamic Backpacks within 30 meters of you...");
    for(new i, string[128]; i < MAX_BACKPACKS; i++)
    {
        if(BackpackInfo[i][sBackpackCreated] && !BackpackInfo[i][sAttached] && BackpackInfo[i][sBackpackOwner] == -1)
        {
            if(IsPlayerInRangeOfPoint(playerid, 30, BackpackInfo[i][sPos][0], BackpackInfo[i][sPos][1], BackpackInfo[i][sPos][2]))
            {
                format(string, sizeof(string), " Backpack ID: %d | Backpack Size %s | %f Distance | Backpack VW: %d | Backpack Int: %d ", i, GetBackpackSize(i), GetPlayerDistanceFromPoint(playerid, BackpackInfo[i][sPos][0], BackpackInfo[i][sPos][1], BackpackInfo[i][sPos][2]), BackpackInfo[i][sVirtualWorld], BackpackInfo[i][sInteriorWorld]);
                SendClientMessageEx(playerid, COLOR_WHITE, string);
            }
        }
    }
    return 1;
}
CMD:checkbp(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 5)
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
//  if(AdminOnDuty[playerid] != true && PlayerInfo[playerid][pAdmin] < GENERAL_MANAGER)
//      return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin. To access your admin commands you must be on-duty. Type /aduty to go on-duty.");
    new giveplayerid;
    if(sscanf(params, "u", giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /checkbp [playerid]");
    if(!IsPlayerConnected(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player isn't connected");
    if(!IsBackpackEquipped(giveplayerid)) return SendClientMessageEx(playerid, COLOR_GREY, "That player dosn't have any backpack equipped!");
    new bpID = GetPlayerBackpackID(giveplayerid);
    new xparams[MAX_PLAYER_NAME];
    format(xparams, sizeof(xparams), "%d", bpID);
    callcmd::bpstatus(playerid, xparams);
    return 1;
}
CMD:bpstatus(playerid, params[]) {

    if(PlayerInfo[playerid][pAdmin] < 5)
        return SendClientMessageEx(playerid, COLOR_GREY, "You are not authorized to use this command.");
//  if(AdminOnDuty[playerid] != true && PlayerInfo[playerid][pAdmin] < GENERAL_MANAGER)
//      return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin. To access your admin commands you must be on-duty. Type /aduty to go on-duty.");
    new string[128], index;
    if(sscanf(params, "d", index)){
        new count = 0;
        for(new x = 0; x<MAX_BACKPACKS; x++) {
            if(BackpackInfo[x][sBackpackCreated]) {
                count++;
            }
        }
        SendClientMessageEx(playerid, COLOR_GREY, " USAGE: /bpstatus [id]   ( To List info of a certain backpack )");
        format(string,sizeof(string), " * There are (%d) Backpacks have been created In Game, Backpack ID starts on '0'", count);
        SendClientMessageEx(playerid, COLOR_WHITE,string);
        return 1;
    }
    if(!BackpackInfo[index][sBackpackCreated]) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Backpack ID!");
    ShowEditBackpackDialog(playerid, index);
    return 1;
}
CMD:createbackpack(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 7)
        return 0;

//  if(AdminOnDuty[playerid] != true && PlayerInfo[playerid][pAdmin] < GENERAL_MANAGER)
    //  return SendClientMessage(playerid,COLOR_WHITE, "You're not on-duty as admin. To access your admin commands you must be on-duty. Type /aduty to go on-duty.");
    new giveplayerid, bsize, bpsize[32], string[128];
    if(!strcmp(params, "player", true, 6)) {
        if(sscanf(params,"s[24]ud" , params, giveplayerid, bsize)) {
             SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createbackpack player [playerid] [backpacksize]");
             SendClientMessageEx(playerid, COLOR_GREY, "Available Size: ( 1 - Small Backpack | 2 - Medium Backpack | 3 - Large Backpack )");
             return 1;
        }
        if(bsize < 1 || bsize > 3) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Backpack Size!");
        if(IsPlayerConnected(giveplayerid)) {
            switch(bsize){
                case 1: format(bpsize,sizeof(bpsize), "Small Backpack");
                case 2: format(bpsize,sizeof(bpsize), "Medium Backpack");
                case 3: format(bpsize,sizeof(bpsize), "Large Backpack");
            }
            //if(AdminOnDuty[giveplayerid] == true) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot create/give backpack to On Duty admin!");
            new bpID = GetPlayerBackpackID(giveplayerid);
            if(IsBackpackEquipped(giveplayerid) && BackpackInfo[bpID][sBackpackSize] == bsize){
                format(string,sizeof(string), "Player %s has already a %s!",GetPlayerNameEx(giveplayerid), GetPlayerStorageType(giveplayerid));
                SendClientMessageEx(playerid, COLOR_GREY, string);
                return 1;
            }
            else if(IsBackpackEquipped(giveplayerid) && BackpackInfo[bpID][sBackpackSize] != bsize) {
                format(string, sizeof(string), "AdmcCmd: %s has setted %s's %s to %s [ID:%d]", GetPlayerNameEx(playerid), GetPlayerNameEx(giveplayerid) ,GetPlayerStorageType(giveplayerid),bpsize,bpID);
                ABroadCast(COLOR_LIGHTRED,string,2);
                ////Log("logs/admin.log", string);
                format(string,sizeof(string), "* Admin %s has setted your %s to %s", GetPlayerNameEx(playerid), GetPlayerStorageType(giveplayerid), bpsize);
                SendClientMessageEx(giveplayerid, COLOR_AQUA, string);
                BackpackInfo[bpID][sBackpackSize] = bsize;
                SaveBackpack(bpID);
                LoadPlayerBackpack(giveplayerid);
                return 1;
            }
            else if(!IsBackpackEquipped(giveplayerid) && bpID == MAX_BACKPACKS+1)
            {
                new query[230];
                for(new index = 0; index<MAX_BACKPACKS; index++) {
                    if(BackpackInfo[index][sBackpackCreated] != 1) {
                        BackpackInfo[index][sBackpackCreated] = 1;
                        BackpackInfo[index][sBackpackSize] = bsize;
                        BackpackInfo[index][sBackpackOwner] = GetPlayerSQLId(giveplayerid);
                        format(BackpackInfo[index][sBackpackOwnerName], MAX_PLAYER_NAME, GetPlayerNameEx(giveplayerid));
                        if(IsPlayerAttachedObjectSlotUsed(giveplayerid, 9)) RemovePlayerAttachedObject(giveplayerid, 9);

                        switch(bsize) {
                            case 1: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.152, -0.069, 0, 0, 0, 0, 1, 1), format(bpsize,sizeof(bpsize), "Small Backpack");
                            case 2: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.152, -0.069, 0, 0, 0, 0, 1, 1), format(bpsize,sizeof(bpsize), "Medium Backpack");
                            case 3: SetPlayerAttachedObject(playerid, 9, 3026, 1, -0.254999, -0.109, -0.022999, 10.6, -1.20002, 3.4, 1.265, 1.242, 1.062), format(bpsize,sizeof(bpsize), "Large Backpack");
                        }
                        BackpackInfo[index][sAttached] = 1;
                        backpackid[giveplayerid] = index;
                        format(query,sizeof(query) , "SELECT * FROM `playerbackpack` WHERE `ID` = %d",index+1);
                        mysql_new_query(connectionID,query , true, "OnCreateDynamics", "iiii", index,1,0,0);
                        format(string, sizeof(string), "AdmcCmd: %s has given %s's a %s [ID: %d]", GetPlayerNameEx(playerid) ,GetPlayerNameEx(giveplayerid),bpsize,index);
                        ABroadCast(COLOR_LIGHTRED,string,2);
                        //////Log("logs/admin.log", string);
                        format(string,sizeof(string), "* Admin %s has given you a %s ", GetPlayerNameEx(playerid), GetPlayerStorageType(giveplayerid));
                        SendClientMessageEx(giveplayerid, COLOR_AQUA, string);
                        index = MAX_BACKPACKS;
                        return 1;
                    }
                }
            }
        }
        else SendClientMessageEx(playerid, COLOR_GREY, "Invalid Player ID!");
    }
    else if(!strcmp(params, "ground", true, 6)) {
        if(sscanf(params,"s[24]d" , params, bsize)) {
             SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createbackpack ground [backpacksize]");
             SendClientMessageEx(playerid, COLOR_GREY, "Available Size: ( 1 - Small Backpack | 2 - Medium Backpack | 3 - Large Backpack )");
             return 1;
        }
        if(bsize < 1 || bsize > 3) return SendClientMessageEx(playerid, COLOR_GREY, "Invalid Backpack Size!");
        if(IsAnyBackpackNear(playerid)) return SendClientMessageEx(playerid, COLOR_GREY, "You cannot create a Backpack on Ground when there are Backpacks near to you");
        switch(bsize){
            case 1: format(bpsize,sizeof(bpsize), "Small Backpack");
            case 2: format(bpsize,sizeof(bpsize), "Medium Backpack");
            case 3: format(bpsize,sizeof(bpsize), "Large Backpack");
        }
        for(new id = 0; id<MAX_BACKPACKS; id++) {
            new query[230];
            if(BackpackInfo[id][sBackpackCreated] != 1) {
                BackpackInfo[id][sBackpackCreated] = 1;
                BackpackInfo[id][sBackpackSize] = bsize;
                GetPlayerPos(playerid, BackpackInfo[id][sPos][0],BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2]);
                BackpackInfo[id][sPos][2] = (BackpackInfo[id][sPos][2] - 1.0);
                BackpackInfo[id][sVirtualWorld] = GetPlayerVirtualWorld(playerid);
                BackpackInfo[id][sInteriorWorld] = GetPlayerInterior(playerid);
                switch(bsize) {
                    case 1: BackpackInfo[id][sObj] = CreateDynamicObject(3026, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2], -90, 0, 90, BackpackInfo[id][sVirtualWorld], BackpackInfo[id][sInteriorWorld], -1, 200.0), SetDynamicObjectMaterial(BackpackInfo[id][sObj],0, -1, "none", "none", 0xFF00FF00);
                    case 2: BackpackInfo[id][sObj] = CreateDynamicObject(3026, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2], -90, 0, 90, BackpackInfo[id][sVirtualWorld], BackpackInfo[id][sInteriorWorld], -1, 200.0), SetDynamicObjectMaterial(BackpackInfo[id][sObj],0, -1, "none", "none", 0xFFFF0000);
                    case 3: BackpackInfo[id][sObj] = CreateDynamicObject(3026, BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2], -90, 0, 90, BackpackInfo[id][sVirtualWorld], BackpackInfo[id][sInteriorWorld], -1, 200.0), SetDynamicObjectMaterial(BackpackInfo[id][sObj],0, -1, "none", "none", 0xFF0000FF);
                }
                format(query,sizeof(query) , "SELECT * FROM `playerbackpack` WHERE `ID` = %d",id+1);
                mysql_new_query(connectionID,query , true, "OnCreateDynamics", "iiii", id,1,0,0);
                format(string, sizeof(string), "AdmcCmd: %s has created a %s [ID: %d] (%f, %f, %f) Virtual World: %d Interior: %d", GetPlayerNameEx(playerid) ,bpsize, id ,BackpackInfo[id][sPos][0], BackpackInfo[id][sPos][1], BackpackInfo[id][sPos][2],BackpackInfo[id][sVirtualWorld], BackpackInfo[id][sInteriorWorld]);
                ABroadCast(COLOR_LIGHTRED,string,2);
            //  ////Log("logs/admin.log", string);
                id = MAX_BACKPACKS;
                return 1;
            }
        }
    }
    else SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /createbackpack [player/ground]");
    return 1;
}

forward OnCreateDynamics(index, type, biztype, gate); // Type ( 1 - House | 2 - Business | 3 - Gate | 4 - Backpack)
public OnCreateDynamics(index, type, biztype, gate)
{
    new rows, fields;
    cache_get_data(rows, fields, connectionID);
    if(rows) {
        switch(type) {
            case 1: SaveBackpack(index);
        }

    }
    else {
        switch(type) {
            case 1: {
                mysql_new_query(connectionID, "INSERT INTO `playerbackpack` (`BackpackCreated`) VALUES ('1')", false, "SENDDATA_THREAD", "i", SENDDATA_THREAD);
                SaveBackpack(index);
            }
        }
    }
    return 1;
}
CMD:pickbackpack(playerid, params[])
{
    new id = IsPlayerNearBackpack(playerid);
    if(id != MAX_BACKPACKS+1) {
        if(!IsBackpackEquipped(playerid)) {
            EquipeBackpack(playerid, id);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has pickup a %s and Equips it.", GetPlayerNameEx(playerid),GetPlayerStorageType(playerid));
            return 1;
        }
        else SendClientMessageEx(playerid, COLOR_GREY, "You already have one backpack equipped");
    }
    return 1;
}
