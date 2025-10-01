// Anti-CBug 

new bool:pCBugging[MAX_PLAYERS];
new ptmCBugFreezeOver[MAX_PLAYERS];
new ptsLastFiredWeapon[MAX_PLAYERS];

#define AUTOCBUG_TICKS_DEAGLE   	( 500 ) // prev 600
#define AUTOCBUG_TICKS_SHOTGUN  	( 850 )
#define AUTOCBUG_TICKS_COUNTRY  	( 750 )
#define AUTOCBUG_TICKS_SNIPER   	( 750 )

/* ** Variables ** */
static stock
	p_cbugKeyTicks					[ MAX_PLAYERS ],
	p_cbugFireTicks					[ MAX_PLAYERS ],
    p_cbugWarns 					[ MAX_PLAYERS char ]
;

public OnPlayerConnect( playerid ) {
	if ( 0 <= playerid < MAX_PLAYERS ) {
		p_cbugWarns{ playerid } = 0;
	}
	#if defined AC_CBUG_OnPlayerConnect
		return AC_CBUG_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AC_CBUG_OnPlayerConnect
#if defined AC_CBUG_OnPlayerConnect
	forward AC_CBUG_OnPlayerConnect(playerid);
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(0 <= playerid < MAX_PLAYERS)
	{
		if( !p_cbugKeyTicks[ playerid ] ) {
			p_cbugKeyTicks[ playerid ] = GetTickCount( ), p_cbugWarns{ playerid } = 0;
		}

		if( ( ( ( newkeys & ( KEY_CROUCH ) ) == ( KEY_CROUCH ) ) || ( ( oldkeys & ( KEY_CROUCH ) ) == ( KEY_CROUCH ) ) ) ) {
			p_cbugKeyTicks[ playerid ] = GetTickCount( ), p_cbugWarns{ playerid } = 0;
		}	
	
		if(!pCBugging[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(!PlayerInfo[playerid][pJoinedEvent])
			{		
				if(PRESSED(KEY_FIRE))
				{
					switch(GetPlayerWeapon(playerid))
					{
						case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
						{
							ptsLastFiredWeapon[playerid] = gettime();
						}
					}
				}
				else if(PRESSED(KEY_CROUCH))
				{
					if((gettime() - ptsLastFiredWeapon[playerid]) < 1)
					{
						if(GetPVarInt(playerid, "EventToken") < 1 && GetPVarInt(playerid, "IsInArena") == -1)
						{
							TogglePlayerControllable(playerid, false);

							pCBugging[playerid] = true;

							new Float:health;
							GetPlayerHealth(playerid, health);
							SetPlayerHealth(playerid, health - 9.0);
							ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.1, 1, 0, 0, 0, 1000);

							GameTextForPlayer(playerid, "~r~~h~DON'T C-BUG!", 3000, 4);

							KillTimer(ptmCBugFreezeOver[playerid]);
							ptmCBugFreezeOver[playerid] = SetTimerEx("CBugFreezeOver", 1500, false, "i", playerid);
						}
					}
				}
			}
		}
	}
	
	#if defined AC_CBUG_OnPlayerKeyStateChange
		return AC_CBUG_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange AC_CBUG_OnPlayerKeyStateChange
#if defined AC_CBUG_OnPlayerKeyStateChange
	forward AC_CBUG_OnPlayerKeyStateChange(playerid);
#endif

forward CBugFreezeOver(playerid);
public CBugFreezeOver(playerid)
{
	TogglePlayerControllable(playerid, true);
	pCBugging[playerid] = false;
	return 1;
}

stock AC_CheckForAutoCbug( playerid, weaponid )
{
	// Anti-Rapid Fire
	if( !p_cbugFireTicks[ playerid ] ) p_cbugFireTicks[ playerid ] = GetTickCount( );
	else
	{
		new
			iTicks = GetTickCount( ),
			iInterval = iTicks - p_cbugFireTicks[ playerid ],
			iKeyInterval = iTicks - p_cbugKeyTicks[ playerid ],
			iHardInterval = 1000
		;

		if( (weaponid == WEAPON_SHOTGUN && !IsPlayerAndroid(playerid)) || weaponid == WEAPON_DEAGLE || weaponid == WEAPON_RIFLE || weaponid == WEAPON_SNIPER )
		{
			new
				iCompare = iKeyInterval - iInterval,
				Float: fOwnPacketLoss = NetStats_PacketLossPercent( playerid )
			;

	     	switch( weaponid )
            {
                case WEAPON_DEAGLE: 	iHardInterval = AUTOCBUG_TICKS_DEAGLE;
                case WEAPON_SHOTGUN: 	iHardInterval = AUTOCBUG_TICKS_SHOTGUN;
                case WEAPON_RIFLE: 		iHardInterval = AUTOCBUG_TICKS_COUNTRY;
                case WEAPON_SNIPER: 	iHardInterval = AUTOCBUG_TICKS_SNIPER;
            }

			if( iInterval < iHardInterval && iCompare > 1500 && fOwnPacketLoss < 0.8 ) {
				if( p_cbugWarns{ playerid }++ >= 2 ) {
					printf( "[autocbug detect] %d detected (wep %d, interval %d, compare %d, warns %d)", playerid, weaponid, iInterval, iCompare, p_cbugWarns{ playerid });
					CallLocalFunction( "OnPlayerCheatDetected", "ddd", playerid, CHEAT_AUTOCBUG, weaponid );
				}
			}
		}
		p_cbugFireTicks[ playerid ] = iTicks;
	}
}
