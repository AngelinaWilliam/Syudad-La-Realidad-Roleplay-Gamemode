/* ** Definitions ** */
#define AC_DEFAULT_TEAM				( 1337 )

/* ** Variables ** */
enum E_PLAYER_HITPOINTS
{
	Float: E_POINTS, 		E_UPDATE_TIME, 				E_UPDATE_FAIL,
	bool: E_SYNCED
};

static const
	s_ValidDamageGiven[] = {
		1, // 0 - Fist
		1, // 1 - Brass knuckles
		1, // 2 - Golf club
		1, // 3 - Nitestick
		0, // 4 - Knife
		1, // 5 - Bat
		1, // 6 - Shovel
		1, // 7 - Pool cue
		1, // 8 - Katana
		1, // 9 - Chainsaw
		1, // 10 - Dildo
		1, // 11 - Dildo 2
		1, // 12 - Vibrator
		1, // 13 - Vibrator 2
		1, // 14 - Flowers
		1, // 15 - Cane
		0, // 16 - Grenade
		0, // 17 - Teargas
		0, // 18 - Molotov
		0, // 19 - Vehicle M4 (custom)
		0, // 20 - Vehicle minigun
		0, // 21
		1, // 22 - Colt 45
		1, // 23 - Silenced
		1, // 24 - Deagle
		1, // 25 - Shotgun
		1, // 26 - Sawed-off
		1, // 27 - Spas
		1, // 28 - UZI
		1, // 29 - MP5
		1, // 30 - AK47
		1, // 31 - M4
		1, // 32 - Tec9
		1, // 33 - Cuntgun
		1, // 34 - Sniper
		0, // 35 - Rocket launcher
		0, // 36 - Heatseeker
		0, // 37 - Flamethrower
		1, // 38 - Minigun
		0, // 39 - Satchel
		0, // 40 - Detonator
		1, // 41 - Spraycan
		1, // 42 - Fire extinguisher
		0, // 43 - Camera
		0, // 44 - Night vision
		0, // 45 - Infrared
		1, // 46 - Parachute
		0, // 47 - Fake pistol
		0, // 48 - Pistol whip (custom)
		0, // 49 - Vehicle
		0, // 50 - Helicopter blades
		0, // 51 - Explosion
		0, // 52 - Car park (custom)
		0, // 53 - Drowning
		0  // 54 - Splat
	}
;

static stock
	Float: p_PlayerArmour 			[ MAX_PLAYERS ] [ E_PLAYER_HITPOINTS ],
	Float: p_LastDamageIssued		[ MAX_PLAYERS ],
	p_LastTookDamage 				[ MAX_PLAYERS ],
	p_LastDamageIssuer 				[ MAX_PLAYERS ] = { INVALID_PLAYER_ID, ... },
	p_LastWeaponIssuer 				[ MAX_PLAYERS ],
	p_LastDeath						[ MAX_PLAYERS ],
	p_DeathSpam						[ MAX_PLAYERS char ]
;

// Function (AC_UpdateKillerData)

stock AC_UpdateDamageInformation( playerid, attackerid, weaponid )
{
	p_LastTookDamage[ playerid ] = GetTickCount( );
	p_LastDamageIssuer[ playerid ] = attackerid;
	p_LastWeaponIssuer[ playerid ] = weaponid;
}

// Function Hook (SetPlayerArmour)

stock AC_SetPlayerArmour( playerid, Float:amount )
{
	p_PlayerArmour[ playerid ] [ E_POINTS ] = amount;
	p_PlayerArmour[ playerid ] [ E_SYNCED ] = false;
    return SetPlayerArmour( playerid, amount );
}

#if defined _ALS_SetPlayerArmour
    #undef SetPlayerArmour
#else
    #define _ALS_SetPlayerArmour
#endif
#define SetPlayerArmour AC_SetPlayerArmour

// Function Hook (SetPlayerTeam)

stock AC_SetPlayerTeam( playerid, teamid )
{
	if( teamid != AC_DEFAULT_TEAM ) {
		printf("[ACWarning] You cannot use SetPlayerTeam as you have hitpoint hack detection enabled (teamid %d, default %d).", teamid, AC_DEFAULT_TEAM );
	}
    return SetPlayerTeam( playerid, AC_DEFAULT_TEAM );
}

#if defined _ALS_SetPlayerTeam
    #undef SetPlayerTeam
#else
    #define _ALS_SetPlayerArmour
#endif
#define SetPlayerTeam AC_SetPlayerTeam

/* ** Callback Hooks ** */
public OnPlayerConnect( playerid )
{
	if ( 0 <= playerid < MAX_PLAYERS )
	{
	    // Reset variables
		p_PlayerArmour[ playerid ] [ E_UPDATE_FAIL ] = 0;
		p_DeathSpam{ playerid } = 0;
	}
	
	#if defined AC_AR_OnPlayerConnect
		return AC_AR_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AC_AR_OnPlayerConnect
#if defined AC_AR_OnPlayerConnect
	forward AC_AR_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn( playerid )
{
	// Armour Hack
	p_PlayerArmour[ playerid ] [ E_UPDATE_FAIL ] = 0;
	p_PlayerArmour[ playerid ] [ E_POINTS ] = 0.0;

	SetPlayerTeam( playerid, AC_DEFAULT_TEAM ); // Set everyone the same team

	#if defined AC_AR_OnPlayerSpawn
		return AC_AR_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn AC_AR_OnPlayerSpawn
#if defined AC_AR_OnPlayerSpawn
	forward AC_AR_OnPlayerSpawn(playerid);
#endif

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
	p_LastTookDamage[ playerid ] = GetTickCount( );
	p_LastDamageIssuer[ playerid ] = issuerid;
	p_LastWeaponIssuer[ playerid ] = weapon;
	p_LastDamageIssued[ playerid ] = amount;

	if( issuerid != INVALID_PLAYER_ID )
	{
		if ( weapon < 0 || weapon >= sizeof( s_ValidDamageGiven ) || !s_ValidDamageGiven[ weapon ] )
			return 0;	

		if( ( !IsPlayerStreamedIn( issuerid, playerid ) && ! ( GetTickCount( ) - AC_GetLastUpdateTime( playerid ) >= 2595 ) ) || !IsPlayerStreamedIn( playerid, issuerid ) )
			return 0;
	
		new Float: tmp, Float: tmp_amount = amount;

		if( p_PlayerArmour[ playerid ] [ E_POINTS ] )
		{
			if( ( tmp = p_PlayerArmour[ playerid ] [ E_POINTS ] - tmp_amount ) < 0.0 )  {
				tmp_amount -= p_PlayerArmour[ playerid ] [ E_POINTS ];
				p_PlayerArmour[ playerid ] [ E_POINTS ] = 0.0;
			} else  {
				p_PlayerArmour[ playerid ] [ E_POINTS ] = tmp;
				tmp_amount = 0.0;
			}
		}

		SetPlayerArmour( playerid, p_PlayerArmour[ playerid ] [ E_POINTS ] );
	}
	else
	{
		new Float: tmp, Float: tmp_amount = amount;

		if( !( weapon == 53 || weapon == 54 || weapon == 50 ) && p_PlayerArmour[ playerid ] [ E_POINTS ] )
		{
			if( ( tmp = p_PlayerArmour[ playerid ] [ E_POINTS ] - tmp_amount ) < 0.0 )  {
				tmp_amount -= p_PlayerArmour[ playerid ] [ E_POINTS ];
				p_PlayerArmour[ playerid ] [ E_POINTS ] = 0.0;
			} else  {
				p_PlayerArmour[ playerid ] [ E_POINTS ] = tmp;
				tmp_amount = 0.0;
			}
		}
	}
	
	#if defined AC_AR_OnPlayerDamage
		return AC_AR_OnPlayerDamage(playerid, amount, issuerid, weapon, bodypart);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerDamage
	#undef OnPlayerDamage
#else
	#define _ALS_OnPlayerDamage
#endif
#define OnPlayerDamage AC_AR_OnPlayerDamage
#if defined AC_AR_OnPlayerDamage
	forward AC_AR_OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart);
#endif

// Functions (Player)
stock AC_CheckForArmorHacks( playerid, iTicks )
{
	new
		Float: currentArmour
	;
	
	GetPlayerArmour( playerid, currentArmour );

	// Lag Calculations
	new
		Float: fHitDamage = p_LastDamageIssued[ playerid ],
		Float: fArmourDamage
	;

	if( fHitDamage > currentArmour ) {
		fArmourDamage = currentArmour;
	}
	else fArmourDamage = fHitDamage;

	// Begin Armour Hack Detection
	if( iTicks > p_PlayerArmour[ playerid ] [ E_UPDATE_TIME ] )
	{
		new currentArmourInt 	= floatround( currentArmour, floatround_floor );
		new ArmourShouldBeInt 	= floatround( p_PlayerArmour[ playerid ] [ E_POINTS ], floatround_floor );

		if( currentArmourInt == ArmourShouldBeInt )
			p_PlayerArmour[ playerid ] [ E_SYNCED ] = true;

		if( !p_PlayerArmour[ playerid ] [ E_SYNCED ] )
		{
			if( currentArmourInt > ArmourShouldBeInt )
			{
				switch( p_PlayerArmour[ playerid ] [ E_UPDATE_FAIL ]++ )
				{
					case 0 .. 9: SetPlayerArmour( playerid, p_PlayerArmour[ playerid ] [ E_POINTS ] );
					case 10: 
					{
						SendClientMessage(playerid, SERVER_COLOR, "You have been kicked as you are desynced from the server. Please relog!");
						SMA(COLOR_LIGHTRED, "AdmCmd: %s was kicked by %s, reason: Armour Desync", GetRPName(playerid), SERVER_BOT);
						KickPlayer(playerid);
					}
				}
			}
		}
		else
		{
			p_PlayerArmour[ playerid ] [ E_UPDATE_FAIL ] = 0;

			if( ArmourShouldBeInt > currentArmourInt )
				p_PlayerArmour[ playerid ] [ E_POINTS ] = currentArmour;

			if( currentArmourInt > ArmourShouldBeInt && currentArmourInt <= 255 && currentArmourInt > 0 )
            	SetPlayerArmour( playerid, p_PlayerArmour[ playerid ] [ E_POINTS ] );

			currentArmourInt = floatround( currentArmour, floatround_floor );
			ArmourShouldBeInt = floatround( p_PlayerArmour[ playerid ] [ E_POINTS ], floatround_floor );

			new dmgOne = floatround( currentArmourInt - fArmourDamage, floatround_floor );
			new dmgTwo = floatround( currentArmourInt - fArmourDamage, floatround_ceil );

            if( !( currentArmourInt == ArmourShouldBeInt || dmgOne == ArmourShouldBeInt || dmgTwo == ArmourShouldBeInt ) )
            {
            	SetPlayerArmour( playerid, p_PlayerArmour[ playerid ] [ E_POINTS ] );
            }
		}
		p_PlayerArmour[ playerid ] [ E_UPDATE_TIME ] = iTicks + 1000;
	}
}

public OnPlayerDeath( playerid, killerid, reason )
{
	if ( ! IsPlayerNPC( playerid ) )
	{
		new
			server_time = gettime( );

		// Anti-fakekill
		switch( server_time - p_LastDeath[ playerid ] )
		{
			case 0 .. 3:
			{
				if ( p_DeathSpam{ playerid } ++ == 3 )
				{
					CallLocalFunction( "OnPlayerCheatDetected", "ddd", playerid, CHEAT_FAKEKILL, p_DeathSpam{ playerid } );
					return 1;
				}
			}
			default: p_DeathSpam{ playerid } = 0;
		}

		p_LastDeath[ playerid ] = server_time;

	    // Died in Vehicle
		if ( GetPlayerVehicleID( playerid ) && AC_IsPlayerSpawned( playerid ) )
	    {
			if( ( GetTickCount( ) - p_LastTookDamage[ playerid ] ) > 2500 ) {
				p_LastDamageIssuer[ playerid ] = INVALID_PLAYER_ID, p_LastWeaponIssuer[ playerid ] = 51;
			}
	    }

	    // Reset spawned variable
		AC_SetPlayerSpawned( playerid, false );
   	}
	#if defined AC_AR_OnPlayerDeath
		return AC_AR_OnPlayerDeath(playerid, killerid, reason);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath AC_AR_OnPlayerDeath
#if defined AC_AR_OnPlayerDeath
	forward AC_AR_OnPlayerDeath(playerid, killerid, reason);
#endif