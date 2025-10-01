stock IsPlayerUsingDetonatorCrasher(playerid)
{
	new bool:player_have_sachel = false, weapons[13][2];
	for (new i = 0; i <= 12; i++)
	{
		GetPlayerWeaponData(playerid, i, weapons[i][0], weapons[i][1]);
		
		if(weapons[i][0] == WEAPON_SATCHEL)
			player_have_sachel = true;
			
		if(weapons[i][0] == WEAPON_BOMB && player_have_sachel == false)
		{
			return 1;
		}
	}
	return 0;
}

public OnPlayerUpdate(playerid)
{
	if(IsPlayerUsingDetonatorCrasher(playerid))
	{
        SendMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s was automatically kick by %s, Reason: Weapon Crasher", GetRPName(playerid), SERVER_ANTICHEAT);
		Kick(playerid);
    }
    #if defined Crasher_OnPlayerUpdate
		return Crasher_OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate Crasher_OnPlayerUpdate
#if defined Crasher_OnPlayerUpdate
	forward Crasher_OnPlayerUpdate(playerid);
#endif