// Anti-RapidFire 
// Credits to Lorenc 

static stock
	p_RapidFireTickCount			[ MAX_PLAYERS ],
	p_RapidFireShots				[ MAX_PLAYERS char ]
;

static stock rapid_GetTickDiff(newtick, oldtick)
{
	if(oldtick < 0 && newtick >= 0)
	{
		return newtick - oldtick;
	}
	else if(oldtick >= 0 && newtick < 0 || oldtick > newtick)
	{
		return (cellmax - oldtick + 1) - (cellmin - newtick);
	}
	return newtick - oldtick;
}

public OnPlayerDisconnect( playerid, reason ) {
	if ( 0 <= playerid < MAX_PLAYERS ) {
		p_RapidFireShots{ playerid } = 0;
	}
	#if defined AC_RAPID_OnPlayerDisconnect
		return AC_RAPID_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect AC_RAPID_OnPlayerDisconnect
#if defined AC_RAPID_OnPlayerDisconnect
	forward AC_RAPID_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerWeaponShot( playerid, weaponid, hittype, hitid, Float: fX, Float: fY, Float: fZ )
{
	if ( ! ( 22 <= weaponid <= 34 ) && weaponid != 38 ) {
		return 0;
	}

	if ( ! p_RapidFireTickCount[ playerid ] ) p_RapidFireTickCount[ playerid ] = GetTickCount( );
	else
	{
		new iInterval = GetTickCount();
	
		if ( ( rapid_GetTickDiff(iInterval, p_RapidFireTickCount[playerid]) <= 35 && ( weaponid != 38 && weaponid != 28 && weaponid != 32 ) ) || ( iInterval <= 370 && ( weaponid == 34 || weaponid == 33 ) ) )
		{
			if ( p_RapidFireShots{ playerid } ++ >= 5 ) {
				CallLocalFunction( "OnPlayerCheatDetected", "ddd", playerid, CHEAT_RAPIDFIRE, weaponid );
		    	return 0;
			}
		}
		else
		{
			p_RapidFireShots{ playerid } = 0;
		}

		p_RapidFireTickCount[ playerid ] = GetTickCount( );
	}
	
	#if defined AC_RAPID_OnPlayerWeaponShot
		return AC_RAPID_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerWeaponShot
	#undef OnPlayerWeaponShot
#else
	#define _ALS_OnPlayerWeaponShot
#endif
#define OnPlayerWeaponShot AC_RAPID_OnPlayerWeaponShot
#if defined AC_RAPID_OnPlayerWeaponShot
	forward AC_RAPID_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float: fX, Float: fY, Float: fZ);
#endif