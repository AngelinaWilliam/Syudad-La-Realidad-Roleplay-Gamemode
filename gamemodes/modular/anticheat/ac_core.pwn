new gAnticheat = 1;

forward OnPlayerCheatDetected(playerid, cheatcode, extraid);

static stock
    bool: p_acSpawned  				[ MAX_PLAYERS char ],
    p_acUpdateTime 					[ MAX_PLAYERS ]
;
	
enum 
{
	CHEAT_CARWARP = 1,
	CHEAT_RAPIDFIRE,
	CHEAT_AUTOCBUG,
	CHEAT_SPEEDHACK,
	CHEAT_REMOTEJACK,
	CHEAT_FAKEKILL,
	CHEAT_WEAPON,
	CHEAT_FLY,
	CHEAT_CAR_SWING,
	CHEAT_PARTICLE_SPAM
};

// functions

stock bool: AC_IsPlayerSpawned( playerid ) {
	return p_acSpawned{ playerid };
}

stock AC_GetLastUpdateTime( playerid ) {
	return p_acUpdateTime[ playerid ];
}

stock AC_SetPlayerSpawned( playerid, bool: spawned ) {
	p_acSpawned{ playerid } = spawned;
}

stock ac_IsPointInArea( Float: X, Float: Y, Float: minx, Float: maxx, Float: miny, Float: maxy )
 	return ( X > minx && X < maxx && Y > miny && Y < maxy );

stock Float: ac_PointDistance( Float: X, Float: Y, Float: dstX, Float: dstY )
	return ( ( X - dstX ) * ( X - dstX ) ) + ( ( Y - dstY ) * ( Y - dstY ) );

// hooks
public OnPlayerConnect( playerid ) {
	new ac_core_name[24];
	GetPlayerName(playerid, ac_core_name, sizeof(ac_core_name));

	if(strlen(ac_core_name) <= 2)
	{
		Kick(playerid);
		return 1;
	}

	if(!(0 <= playerid < MAX_PLAYERS))
	{
		Kick(playerid);
		return 1;
	}

	if ( 0 <= playerid < MAX_PLAYERS ) {
		p_acSpawned{ playerid } = false;
	}
	
	#if defined AC_Core_OnPlayerConnect
		return AC_Core_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}	

#if defined OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AC_Core_OnPlayerConnect
#if defined AC_Core_OnPlayerConnect
	forward AC_Core_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn( playerid ) {
	if ( 0 <= playerid < MAX_PLAYERS ) {
		p_acSpawned{ playerid } = true;
	}
	#if defined AC_Core_OnPlayerSpawn
		return AC_Core_OnPlayerSpawn(playerid);
	#else
		return 1;
	#endif	
}	

#if defined OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn AC_Core_OnPlayerSpawn
#if defined AC_Core_OnPlayerSpawn
	forward AC_Core_OnPlayerSpawn(playerid);
#endif

public OnPlayerRequestClass( playerid, classid ) {
	if ( 0 <= playerid < MAX_PLAYERS ) {
		p_acSpawned{ playerid } = false;
	}
	#if defined AC_Core_OnPlayerRequestClass
		return AC_Core_OnPlayerRequestClass(playerid, classid);
	#else
		return 1;
	#endif	
}	

#if defined OnPlayerRequestClass
	#undef OnPlayerRequestClass
#else
	#define _ALS_OnPlayerRequestClass
#endif
#define OnPlayerRequestClass AC_Core_OnPlayerRequestClass
#if defined AC_Core_OnPlayerRequestClass
	forward AC_Core_OnPlayerRequestClass(playerid, classid);
#endif

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	new iState = GetPlayerState( playerid );

	if( iState == PLAYER_STATE_WASTED || ! AC_IsPlayerSpawned( playerid ) )
		return 0; // Why bother, he's dead!

	AC_CheckForAutoCbug( playerid, weaponid );
	
	#if defined AC_Core_OnPlayerWeaponShot
		return AC_Core_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerWeaponShot
	#undef OnPlayerWeaponShot
#else
	#define _ALS_OnPlayerWeaponShot
#endif
#define OnPlayerWeaponShot AC_Core_OnPlayerWeaponShot
#if defined AC_Core_OnPlayerWeaponShot
	forward AC_Core_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif

public OnPlayerUpdate(playerid)
{
	if( ! AC_IsPlayerSpawned( playerid ) )
		return 0; // Not Spawned, No SYNC!

    if(GetPlayerMoney(playerid) != PlayerInfo[playerid][pCash])
    {
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
    }   

	if( !IsPlayerNPC( playerid ) )
	{
		new
			iState = GetPlayerState( playerid );

		p_acUpdateTime[ playerid ] = GetTickCount( );

		if( iState != PLAYER_STATE_SPECTATING )
		{
        	AC_CheckPlayerRemoteJacking ( playerid );
			AC_CheckForFlyHacks( playerid, p_acUpdateTime[ playerid ] );
			//AC_CheckForArmorHacks( playerid, p_acUpdateTime[ playerid ] );
		}
	}
	
	#if defined AC_Core_OnPlayerUpdate
		return AC_Core_OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate AC_Core_OnPlayerUpdate
#if defined AC_Core_OnPlayerUpdate
	forward AC_Core_OnPlayerUpdate(playerid);
#endif

// callbacks 
public OnPlayerCheatDetected(playerid, cheatcode, extraid)
{
	if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 7 && !PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pKicked])
	{
		switch(cheatcode)
		{
			case CHEAT_RAPIDFIRE:
			{
				new weapon_name[32];
				GetWeaponName(extraid, weapon_name, sizeof(weapon_name));
			
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using rapid fire (%s).", GetRPName(playerid), playerid, weapon_name);
					Log_Write("log_cheat", "%s (uid: %i) possibly used rapid fire (%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], weapon_name);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Rapid Fire (%s)", GetRPName(playerid), CHEAT_RAPIDFIRE, weapon_name);
					KickPlayer(playerid);
				}				
			}
			case CHEAT_AUTOCBUG:
			{
				new weapon_name[32];
				GetWeaponName(extraid, weapon_name, sizeof(weapon_name));
			
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using auto-cbug (%s).", GetRPName(playerid), playerid, weapon_name);
					//Log_Write("log_cheat", "%s (uid: %i) possibly used rapid fire (%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], weapon_name);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Auto-CBUG (%s)", GetRPName(playerid), SERVER_BOT, weapon_name);
					KickPlayer(playerid);
				}				
			}
			case CHEAT_SPEEDHACK:
			{
				new speed_hack_code[64];
				
				switch(extraid)
				{
					case 0: speed_hack_code = "On-Foot";
					case 1, 2: speed_hack_code = "Vehicle";
				}
				
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using speed hack (%s).", GetRPName(playerid), playerid, speed_hack_code);
					//Log_Write("log_cheat", "%s (uid: %i) possibly used speed hack (%s)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], speed_hack_code);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Speed Hack (%s)", GetRPName(playerid), SERVER_BOT, speed_hack_code);
					KickPlayer(playerid);
				}	
			}
			case CHEAT_FAKEKILL:
			{
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using fake kill.", GetRPName(playerid), playerid);
					Log_Write("log_cheat", "%s (uid: %i) possibly used fake kill.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Fake Kill", GetRPName(playerid), SERVER_BOT);
					KickPlayer(playerid);
				}	
			}
			case CHEAT_WEAPON:
			{
				new weapon_name[32];
				GetWeaponName(extraid, weapon_name, sizeof(weapon_name));			
			
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using weapon hacks (%s).", GetRPName(playerid), playerid, weapon_name);
					Log_Write("log_cheat", "%s (uid: %i) possibly used weapon hacks (%s).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], weapon_name);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autobanned by %s, reason: Weapon Hacks (%s)", GetRPName(playerid), SERVER_BOT, weapon_name);
				    AddBan(GetPlayerNameEx(playerid), GetPlayerIP(playerid), "Admin", "Weapon Hacks", 1);
				    KickIP(GetPlayerIP(playerid));
				    BanPlayer(playerid, SERVER_BOT, "Weapon Hacks");
				    KickPlayer(playerid);



				}	
			}
			case CHEAT_CARWARP:
			{
				SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Car Warp", GetRPName(playerid), SERVER_BOT);
				KickPlayer(playerid);
			}
			case CHEAT_FLY:
			{
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using fly hacks.", GetRPName(playerid), playerid);
					Log_Write("log_cheat", "%s (uid: %i) possibly used fly hacks.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Fly Hacks", GetRPName(playerid), SERVER_BOT);
					KickPlayer(playerid);
				}	
			}
			case CHEAT_CAR_SWING:
			{
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using car swing.", GetRPName(playerid), playerid);
					Log_Write("log_cheat", "%s (uid: %i) possibly used car swing.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Car Swing", GetRPName(playerid), SERVER_BOT);
					KickPlayer(playerid);
				}	
			}
			case CHEAT_PARTICLE_SPAM:
			{
				PlayerInfo[playerid][pACWarns]++;

				if(PlayerInfo[playerid][pACWarns] <= 3)
				{
					SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using car particle spam.", GetRPName(playerid), playerid);
					Log_Write("log_cheat", "%s (uid: %i) possibly used car particle spam.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
				}
				else
				{
					SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Car Particle Spam", GetRPName(playerid), SERVER_BOT);
					KickPlayer(playerid);
				}	
			}
		}
	}
	return 1;
}
forward OnPlayerBugAttempt(playerid, bugcode);
public OnPlayerBugAttempt(playerid, bugcode)
{
	if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 7 && !PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pKicked])
	{
		// Disable AFK Ghost for Android Users.
		if(IsPlayerAndroid(playerid) && (bugcode == 0))
			return 1;
	
		new bug_code[64];
		
		switch(bugcode)
		{
			case 0: bug_code = "AFK ghost";
			case 1: bug_code = "NPC Spoof";
			case 2: bug_code = "Fake Spawn";
			case 3: bug_code = "Fake Connect";
			case 4: bug_code = "CJ Run";
		}
		
        PlayerInfo[playerid][pACWarns]++;

        if(PlayerInfo[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using bugger hacks (%s).", GetRPName(playerid), playerid, bug_code);
            Log_Write("log_cheat", "%s (uid: %i) possibly used bugger hacks (%s).", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], bug_code);
        }
        else
        {
            SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokick by %s, reason: Bugger Hacks (%s)", GetRPName(playerid), SERVER_BOT, bug_code);
            //BanPlayer(playerid, SERVER_BOT, "Airbreak");
            KickPlayer(playerid);
        }		
	}
	return 1;
}

public OnPlayerTeleport(playerid, Float:distance)
{
    if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 7 && !PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pKicked])
    {
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]))
        {
            PlayerInfo[playerid][pACWarns]++;

            if(PlayerInfo[playerid][pACWarns] < 4)
            {
                SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly teleport hacking (distance: %.1f).", GetRPName(playerid), playerid, distance);
                Log_Write("log_cheat", "%s (uid: %i) possibly teleport hacked (distance: %.1f)", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], distance);
            }
            else
            {
                SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokicked by %s, reason: Teleport hacks", GetRPName(playerid), SERVER_BOT);
                KickPlayer(playerid);
            }
        }
    }

    return 1;
}

public OnPlayerAirbreak(playerid)
{
    if((gAnticheat) && PlayerInfo[playerid][pAdmin] < 7 && !PlayerInfo[playerid][pAdminDuty] && !PlayerInfo[playerid][pKicked])
    {
        PlayerInfo[playerid][pACWarns]++;

        if(PlayerInfo[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
        {
            SAM(COLOR_YELLOW, "AdmWarning: %s[%i] is possibly using airbreak hacks.", GetRPName(playerid), playerid);
            Log_Write("log_cheat", "%s (uid: %i) possibly used airbreak.", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID]);
        }
        else
        {
            SMA(COLOR_LIGHTRED, "AdmCmd: %s was autokick by %s, reason: Airbreak", GetRPName(playerid), SERVER_BOT);
            //BanPlayer(playerid, SERVER_BOT, "Airbreak");
            KickPlayer(playerid);
        }
    }
    return 1;
}
