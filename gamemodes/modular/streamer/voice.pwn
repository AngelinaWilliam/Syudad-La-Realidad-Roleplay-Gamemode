//sampvoice
new SV_GSTREAM:factionstream[MAX_FACTIONS] = { SV_NULL, ... };
new SV_GSTREAM:gangstream[MAX_GANGS] = { SV_NULL, ... };
new SV_LSTREAM:lstream[MAX_PLAYERS] = { SV_NULL, ... };

new SV_GSTREAM:broadcaststream = SV_NULL; 
new SV_GSTREAM:dispatchstream = SV_NULL; //mech


new SV_GSTREAM:gstream;
public OnGameModeInit()
{
    dispatchstream = SvCreateGStream(COLOR_ORANGE, "DISPATCH");
    broadcaststream = SvCreateGStream(COLOR_ORANGE, "Broadcast");
    gstream = SvCreateGStream(0xffff0000, "GLOBAL"); // blue color

	#if defined VOICE_OnGameModeInit
		return VOICE_OnGameModeInit();
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit VOICE_OnGameModeInit
#if defined VOICE_OnGameModeInit
	forward VOICE_OnGameModeInit();
#endif

public OnGameModeExit()
{
    if (dispatchstream) SvDeleteStream(dispatchstream);
    if (broadcaststream) SvDeleteStream(broadcaststream);

	#if defined VOICE_OnGameModeExit
		return VOICE_OnGameModeExit();
	#else
		return 1;
	#endif	
}	

#if defined _ALS_OnGameModeExit
	#undef OnGameModeExit
#else
	#define _ALS_OnGameModeExit
#endif
#define OnGameModeExit VOICE_OnGameModeExit
#if defined VOICE_OnGameModeExit
	forward VOICE_OnGameModeExit();
#endif

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid)
{
    if (keyid == 0x42 && lstream[playerid]) SvAttachSpeakerToStream(lstream[playerid], playerid);

    if (keyid == 0x58)
    {
        if(broadcaststream) SvAttachSpeakerToStream(broadcaststream, playerid);
    }
    if(PlayerInfo[playerid][pToggleGangRadio] == 1)
    {
        if(keyid == 0x4E && gangstream[PlayerInfo[playerid][pGang]]) SvAttachSpeakerToStream(gangstream[PlayerInfo[playerid][pGang]], playerid);
    }
    if (keyid == 0x4D)
    {
        if(dispatchstream) SvAttachSpeakerToStream(dispatchstream, playerid);
    }
    if(PlayerInfo[playerid][pToggleFactionRadio] == 1)
    {
        if(keyid == 0x5A && factionstream[PlayerInfo[playerid][pFaction]]) SvAttachSpeakerToStream(factionstream[PlayerInfo[playerid][pFaction]], playerid);
    }
    //if (keyid == 0x5A && gstream) SvAttachSpeakerToStream(gstream, playerid);
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if (keyid == 0x42 && lstream[playerid]) SvDetachSpeakerFromStream(lstream[playerid], playerid);

    if (keyid == 0x58)
    {
        if(broadcaststream) SvDetachSpeakerFromStream(broadcaststream, playerid);
    }
    if(PlayerInfo[playerid][pToggleGangRadio] == 1)
    {
        if(keyid == 0x4E && gangstream[PlayerInfo[playerid][pGang]]) SvDetachSpeakerFromStream(gangstream[PlayerInfo[playerid][pGang]], playerid);
    }
    if (keyid == 0x4D)
    {
        if(dispatchstream) SvDetachSpeakerFromStream(dispatchstream, playerid);
    }
    if(PlayerInfo[playerid][pToggleFactionRadio] == 1)
    {
        if(keyid == 0x5A && factionstream[PlayerInfo[playerid][pFaction]]) SvDetachSpeakerFromStream(factionstream[PlayerInfo[playerid][pFaction]], playerid);
    }
    //if (keyid == 0x5A && gstream) SvDetachSpeakerFromStream(gstream, playerid);
}
