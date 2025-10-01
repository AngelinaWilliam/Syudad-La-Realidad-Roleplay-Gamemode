new RandomMessagesToSend[][] =
{
    "SERVER: Need help? The Community Advisors are here to help you. (/requesthelp to get help)",
    "SERVER: Join our discord community "SERVER_URL"",
    "SERVER: Want to donate in this server? Contact management for donation",
    "SERVER: You want to be a member of faction?Just apply in discord server.",
    "SERVER: You want to be create your gang or join the gang? Contact gang leader or appy in discord.",
    "SERVER: Seen a Hacker/Dmer/Rulebreaker? Report on admin used the cmds [/report] or [/rdm]", 
    "SERVER: To avoid being jailed, just follow the rules on the server",
    "SERVER: Too force closed/fc? Try to clear cache your gta application and remove some mods."
};

forward SendRandomMessageToAll();
public SendRandomMessageToAll()
{
	foreach(new i: Player)
	{
		if(PlayerInfo[i][pLogged] && !PlayerInfo[i][pTutorial])
		{
	    	SendMessageToAll(COLOR_ORANGE, RandomMessagesToSend[random(sizeof(RandomMessagesToSend))]);
	    }
	}
    return 1;
}

public OnGameModeInit()
{
    SetTimer("SendRandomMessageToAll",100000,1); 
    
    #if defined Randommsg_OnGameModeInit
		return Randommsg_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Randommsg_OnGameModeInit
#if defined Randommsg_OnGameModeInit
	forward Randommsg_OnGameModeInit();
#endif
