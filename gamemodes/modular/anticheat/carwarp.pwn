static stock
    p_ac_CarWarpTime				[ MAX_PLAYERS ],
    p_ac_CarWarpVehicleID			[ MAX_PLAYERS ]
;

public OnPlayerStateChange( playerid, newstate, oldstate )
{
  	if ( newstate == PLAYER_STATE_DRIVER )
    {
        if ( GetPlayerVehicleID( playerid ) != p_ac_CarWarpVehicleID[ playerid ] )
        {
        	new
        		server_time = gettime( );

	        if ( p_ac_CarWarpTime[ playerid ] > server_time )
	        {
				CallLocalFunction( "OnPlayerCheatDetected", "ddd", playerid, CHEAT_CARWARP, 0 );
	            return 1;
	        }

	        p_ac_CarWarpTime[ playerid ] = server_time + 1;
	        p_ac_CarWarpVehicleID[ playerid ] = GetPlayerVehicleID( playerid );
		}
    }
	
	#if defined AC_CW_OnPlayerStateChange
		return AC_CW_OnPlayerStateChange(playerid, newstate, oldstate);
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnPlayerStateChange
	#undef OnPlayerStateChange
#else
	#define _ALS_OnPlayerStateChange
#endif
#define OnPlayerStateChange AC_CW_OnPlayerStateChange
#if defined AC_CW_OnPlayerStateChange
	forward AC_CW_OnPlayerStateChange(playerid);
#endif