// Anti Car Jack Protection 

static carjack_timer[MAX_PLAYERS] = {-1, ...};

public OnPlayerConnect(playerid)
{
	KillTimer( carjack_timer[playerid] );
	carjack_timer[playerid] = -1;
	
	#if defined AC_CJ_OnPlayerConnect
		return AC_CJ_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AC_CJ_OnPlayerConnect
#if defined AC_CJ_OnPlayerConnect
	forward AC_CJ_OnPlayerConnect(playerid);
#endif

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(GetVehicleDriver(vehicleid) != INVALID_PLAYER_ID && !ispassenger && !pData[playerid][pKicked])
	{
		GameTextForPlayer(playerid, "~r~NO CARJACKING", 5000, 3);

		TogglePlayerControllable(playerid, false);
		ClearAnimations(playerid, 1);
		KillTimer(carjack_timer[playerid]);
		carjack_timer[playerid] = SetTimerEx("UnfreezeCarjacker", 5000, false, "d", playerid);
		return 1;
	}
	
	#if defined AC_CJ_OnPlayerEnterVehicle
		return AC_CJ_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerEnterVehicle
	#undef OnPlayerEnterVehicle
#else
	#define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle AC_CJ_OnPlayerEnterVehicle
#if defined AC_CJ_OnPlayerEnterVehicle
	forward AC_CJ_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

forward UnfreezeCarjacker(playerid);
public UnfreezeCarjacker(playerid)
{
	TogglePlayerControllable(playerid, true);
	KillTimer(carjack_timer[playerid]);
	carjack_timer[playerid] = -1;
	return 1;
}