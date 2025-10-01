/* ** Includes ** */
/* ** Definitions ** */
#if !defined MAX_CLASSES
	#define MAX_CLASSES 			( 300 )
#endif

#if !defined AC_MAX_WEAPONS
	#define AC_MAX_WEAPONS 			( 55 )
#endif

/* ** Variables ** */
enum E_CLASS_DATA {
	E_WEAPONS[ 3 ]
};

static stock
	bool: p_PlayerHasWeapon 		[ MAX_PLAYERS ] [ AC_MAX_WEAPONS char ],
	p_SelectedClassID 				[ MAX_PLAYERS ],
	p_PlayerWeaponUpdateTime 		[ MAX_PLAYERS ],
	p_CurrentArmedWeapon 			[ MAX_PLAYERS char ]
;

/* ** Callback Hooks ** */
public OnPlayerConnect( playerid ) {
	if ( 0 <= playerid < MAX_PLAYERS ) {
		for ( new i = 0; i < AC_MAX_WEAPONS; i++ ) {
			p_PlayerHasWeapon[ playerid ] { i } = false;
		}
	}
	
	#if defined AC_WH_OnPlayerConnect
		return AC_WH_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}	

#if defined OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AC_WH_OnPlayerConnect
#if defined AC_WH_OnPlayerConnect
	forward AC_WH_OnPlayerConnect(playerid);
#endif

public OnPlayerDeath( playerid, killerid, reason )
{
	if ( 0 <= playerid < MAX_PLAYERS ) {
		p_PlayerWeaponUpdateTime[ playerid ] = GetTickCount( ) + 2000;
	}
	#if defined AC_WH_OnPlayerDeath
		return AC_WH_OnPlayerDeath(playerid, killerid, reason);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath AC_WH_OnPlayerDeath
#if defined AC_WH_OnPlayerDeath
	forward AC_WH_OnPlayerDeath(playerid, killerid, reason);
#endif

public OnPlayerSpawn( playerid )
{
	if ( 0 <= playerid < MAX_PLAYERS )
	{
		p_PlayerWeaponUpdateTime[ playerid ] = GetTickCount( ) + 2000;
	}
	#if defined AC_WH_OnPlayerSpawn
		return AC_WH_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn AC_WH_OnPlayerSpawn
#if defined AC_WH_OnPlayerSpawn
	forward AC_WH_OnPlayerSpawn(playerid);
#endif

public OnPlayerStateChange( playerid, newstate, oldstate )
{
	if ( 0 <= playerid < MAX_PLAYERS )
	{
		if( newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER )
		{
			switch ( GetVehicleModel( GetPlayerVehicleID( playerid ) ) )
			{
				case 457:
					p_PlayerHasWeapon[ playerid ] { 2 } = true;

				case 592, 577, 511, 512, 520, 593, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469, 539:
					p_PlayerHasWeapon[ playerid ] { 46 } = true;

				case 596, 597, 598, 599:
					p_PlayerHasWeapon[ playerid ] { 25 } = true;
			}
		}
   	}
	#if defined AC_WH_OnPlayerStateChange
		return AC_WH_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange AC_WH_OnPlayerStateChange
#if defined AC_WH_OnPlayerStateChange
	forward AC_WH_OnPlayerStateChange(playerid, newstate, oldstate);
#endif

public OnPlayerExitVehicle( playerid, vehicleid )
{
	if ( 0 <= playerid < MAX_PLAYERS )
	{
		switch( GetVehicleModel( vehicleid ) ) // Weapon Hacks - credits to wups
		{
			case 457:
				p_PlayerHasWeapon[ playerid ] { 2 } = true;

			case 592, 577, 511, 512, 520, 593, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469, 539:
				p_PlayerHasWeapon[ playerid ] { 46 } = true;

			case 596, 597, 598, 599:
				p_PlayerHasWeapon[ playerid ] { 25 } = true;
		}
	}
	#if defined AC_WH_OnPlayerExitVehicle
		return AC_WH_OnPlayerExitVehicle(playerid, vehicleid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerExitVehicle
	#undef OnPlayerExitVehicle
#else
	#define _ALS_OnPlayerExitVehicle
#endif
#define OnPlayerExitVehicle AC_WH_OnPlayerExitVehicle
#if defined AC_WH_OnPlayerExitVehicle
	forward AC_WH_OnPlayerExitVehicle(playerid, vehicleid);
#endif

public OnPlayerKeyStateChange( playerid, newkeys, oldkeys )
{
	if( !IsPlayerNPC( playerid ) )
	{
		if ( ( newkeys & KEY_FIRE ) && AC_IsPlayerSpawned( playerid ) ) {
			new iWeapon = GetPlayerWeapon( playerid );
			new iTickCount = GetTickCount( );

			if ( iTickCount > p_PlayerWeaponUpdateTime[ playerid ] && 0 <= iWeapon < AC_MAX_WEAPONS )
			{
				if( !p_PlayerHasWeapon[ playerid ] { iWeapon } && ( iWeapon != 0 && iWeapon != 40 ) && ! ( IsPlayerInAnyVehicle( playerid ) && p_CurrentArmedWeapon{ playerid } != iWeapon ) ) {
					CallLocalFunction( "OnPlayerCheatDetected", "ddd", playerid, CHEAT_WEAPON, iWeapon );
					// printf("[weapon] %d seems to weapon hack (weapon id %d).", playerid, iWeapon );
				}
			}
		}
	}
	#if defined AC_WH_OnPlayerKeyStateChange
		return AC_WH_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange AC_WH_OnPlayerKeyStateChange
#if defined AC_WH_OnPlayerKeyStateChange
	forward AC_WH_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

/* ** Function Hooks ** */
// Function Hook (GivePlayerWeapon)

stock AC_GivePlayerWeapon( playerid, weaponid, ammo )
{
	p_PlayerWeaponUpdateTime[ playerid ] = GetTickCount( ) + 2000;

	if( 0 <= weaponid < AC_MAX_WEAPONS ) {
		p_PlayerHasWeapon[ playerid ] { weaponid } = true;
		p_CurrentArmedWeapon{ playerid } = weaponid;
	}
    return GivePlayerWeapon( playerid, weaponid, ammo );
}

#if defined _ALS_GivePlayerWeapon
    #undef GivePlayerWeapon
#else
    #define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon AC_GivePlayerWeapon

// Function Hook (SetPlayerArmedWeapon)

stock AC_SetPlayerArmedWeapon( playerid, weaponid )
{
	if ( 0 <= weaponid <= AC_MAX_WEAPONS && p_CurrentArmedWeapon{ playerid } != weaponid ) {
		p_PlayerWeaponUpdateTime[ playerid ] = GetTickCount( ) + 2000;
		p_CurrentArmedWeapon{ playerid } = weaponid;
	}
    return SetPlayerArmedWeapon( playerid, weaponid );
}

#if defined _ALS_SetPlayerArmedWeapon
    #undef SetPlayerArmedWeapon
#else
    #define _ALS_SetPlayerArmedWeapon
#endif
#define SetPlayerArmedWeapon AC_SetPlayerArmedWeapon

// Function Hook (ResetPlayerWeapons)

stock AC_ResetPlayerWeapons( playerid )
{
	p_PlayerWeaponUpdateTime[ playerid ] = GetTickCount( ) + 2000;

	for ( new i = 0; i < AC_MAX_WEAPONS; i++ )
		p_PlayerHasWeapon[ playerid ] { i } = false;

    return ResetPlayerWeapons( playerid );
}

#if defined _ALS_ResetPlayerWeapons
    #undef ResetPlayerWeapons
#else
    #define _ALS_ResetPlayerWeapons
#endif
#define ResetPlayerWeapons AC_ResetPlayerWeapons

// Function Hook (SetSpawnInfo)

stock WH_SetSpawnInfo( playerid, team, skin, Float: x, Float: y, Float: z, Float: Angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo )
{
	if ( weapon1 != -1 && weapon1 < AC_MAX_WEAPONS ) p_PlayerHasWeapon[ playerid ] { weapon1 } = true;
	if ( weapon2 != -1 && weapon2 < AC_MAX_WEAPONS ) p_PlayerHasWeapon[ playerid ] { weapon2 } = true;
	if ( weapon3 != -1 && weapon3 < AC_MAX_WEAPONS ) p_PlayerHasWeapon[ playerid ] { weapon3 } = true;

    return SetSpawnInfo( playerid, team, skin, x, y, z, Angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo );
}

#if defined _ALS_SetSpawnInfo
    #undef SetSpawnInfo
#else
    #define _ALS_SetSpawnInfo
#endif
#define SetSpawnInfo WH_SetSpawnInfo