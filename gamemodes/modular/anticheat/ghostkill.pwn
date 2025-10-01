new accumulatedKills[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
	accumulatedKills[playerid] = 0;
	#if defined AC_GK_OnPlayerConnect
		return AC_GK_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AC_GK_OnPlayerConnect
#if defined AC_GK_OnPlayerConnect
	forward AC_GK_OnPlayerConnect(playerid);
#endif

public OnPlayerDeath(playerid, killerid, reason)
{
	if(0 <= killerid < MAX_PLAYERS)
	{
		if(killerid != INVALID_PLAYER_ID)
		{
			accumulatedKills[killerid] ++;
		}
	}
	
	#if defined AC_GK_OnPlayerDeath
		return AC_GK_OnPlayerDeath(playerid, killerid, reason);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath AC_GK_OnPlayerDeath
#if defined AC_GK_OnPlayerDeath
	forward AC_GK_OnPlayerDeath(playerid, killerid, reason);
#endif