

#if defined DISCORDS

//No more formatting
new format_string[1800];
stock SendDCMessage(const title[], const message[]) {
	return DCC_SendChannelEmbedMessage(DCC_FindChannelById("1208390867367239780"), DCC_Embed:DCC_CreateEmbed(title, message, .color=0xFF9900));
}
#define SendDiscordMessage(%0,%1,%2) \
	format(format_string, sizeof(format_string), %1,%2) \
	&& SendDCMessage(%0, format_string)

enum svrData
{
	svrDays,
	svrHours,
	svrMins,
	svrScs
};
new ServerData[svrData];

#define PROFILE_CHANNEL_ID 	"1412500585282015322" //1411417204972589209
new DCC_Channel:profile_channel;

public VOICE_OnGameModeInit()
{
    DCC_SetBotPresenceStatus(IDLE);
	profile_channel = DCC_FindChannelById(PROFILE_CHANNEL_ID);

	SetTimer("Uptimer_Counter", 1000, true);
	SetTimer("BotStatus", 1000, true);

	#if defined DCSTATS_VOICE_OnGameModeInit
        return DCSTATS_VOICE_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_VOICE_OnGameModeInit
    #undef VOICE_OnGameModeInit
#else
    #define _ALS_VOICE_OnGameModeInit
#endif
#define VOICE_OnGameModeInit DCSTATS_VOICE_OnGameModeInit
#if defined DCSTATS_VOICE_OnGameModeInit
    forward DCSTATS_VOICE_OnGameModeInit();
#endif

//Bot status
forward BotStatus();
public BotStatus()
{
    new status1[256];
    format(status1,sizeof(status1),""SERVER_NAME" | %02d:%02d:%02d", ServerData[svrDays], ServerData[svrHours], ServerData[svrMins]);
    DCC_SetBotActivity(status1);
    DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
}

forward Uptimer_Counter();
public Uptimer_Counter()
{
	ServerData[svrScs]++;
	if(ServerData[svrScs] == 60)
	{
		ServerData[svrScs] = 0;
		ServerData[svrMins]++;
		if(ServerData[svrMins] == 60)
		{
			ServerData[svrMins] = 0;
			ServerData[svrHours]++;
			if(ServerData[svrHours] == 24)
			{
				ServerData[svrHours] = 0;
				ServerData[svrDays]++;
			}
		}
	}
}

// Discord Commands
#define CommandChannel "1411417204972589209"
DCMD:oprison(user, channel, params[])
{
    new username[32 + 1], minutes, reason[128], playerid;

    if(channel != DCC_FindChannelById(CommandChannel))
    {
        return 1;
    }
    if(sscanf(params, "s[24]is[128]", username, minutes, reason))
    {
        return DCC_SendChannelMessage(channel, "Usage: /oprison [username] [minutes] [reason]");
    }
    if(minutes < 1)
    {
        return DCC_SendChannelMessage(channel, "The amount of minutes cannot be below one. Use /release instead.");
    }
    if(IsPlayerOnline(username))
    {
        return DCC_SendChannelMessage(channel, "That player is already online and logged in. Use /prison instead.");
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT adminlevel, uid FROM users WHERE username = '%e'", username);
    mysql_tquery(connectionID, queryBuffer, "OnAdminOfflinePrison", "isis", playerid, username, minutes, reason);
    return 1;
}

DCMD:ban(user, channel, params[])
{
    new targetid, reason[128], user_name[32 + 1], playerid;
    if(channel != DCC_FindChannelById(CommandChannel))
    {
        return 1;
    }
    if(sscanf(params, "us[128]", targetid, reason))
    {
        return DCC_SendChannelMessage(channel, "Usage: /ban [playerid] [reason]");
    }
    if(!IsPlayerConnected(targetid))
    {
        return DCC_SendChannelMessage(channel, "The player specified is disconnected.");
    }
    //Log_Write("log_punishments", "%s (uid: %i) banned %s (uid: %i), reason: %s", GetPlayerNameEx(playerid), PlayerInfo[playerid][pID], GetPlayerNameEx(targetid), PlayerInfo[targetid][pID], reason);
    SMA(COLOR_LIGHTRED, "AdmCmd: %s was banned by %s, reason: %s", user_name, GetRPName(playerid), reason);
    BanPlayer(targetid, GetPlayerNameEx(playerid), reason);
    DisplayBanSystem(targetid);
    return 1;
}
DCMD:unban(user, channel, params[])
{
    new username[MAX_PLAYER_NAME], playerid;

    if(channel != DCC_FindChannelById(CommandChannel))
    {
        return 1;
    }
    if(sscanf(params, "s[24]", username))
    {
        return DCC_SendChannelMessage(channel, "Usage: /unban [username]");
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT id, permanent FROM bans WHERE username = '%e'", username);
    mysql_tquery(connectionID, queryBuffer, "OnAdminUnbanUser", "is", playerid, username);
    return 1;
}


#define BOT_CHANNEL "enter-command" // change this
#define BOT_NAME "BOT-LOGS" //change this
#define COLOR_RED 0xFF0000FF


DCMD:dchat(user, channel, params[]) {

    if(channel != DCC_FindChannelById(CommandChannel))
    {
        return 1;
    }

    if(isnull(params)) {
        DCC_SendChannelMessage(channel, "`!dchat");
    } else {

        new str[144], username[33];
        DCC_GetUserName(user, username, sizeof(username));
        format(str, sizeof(str), ""TWEET"[Discord Chat] "WHITE"%s: %s", username, params);
        SendClientMessageToAll(-1, str); //Broadcast message to server.
    }
    return 1;
}

DCMD:achat(user, channel, params[]) {

    if(channel != DCC_FindChannelById(CommandChannel))
    {
        return 1;
    }

    if(isnull(params)) {
        DCC_SendChannelMessage(channel, "`!achat");
    } else {

        new str[144], username[33];
        DCC_GetUserName(user, username, sizeof(username));
        format(str, sizeof(str), ""RED"[Discord Admin Chat] "WHITE"%s: %s", username, params);
        SendAdminMessage(-1, str); //Broadcast message to server.
    }
    return 1;
}

DCMD:cmds(user, channel, params[])
{
    if(channel != DCC_FindChannelById(CommandChannel))
    {
        return 1;
    }   
    DCC_SendChannelMessage(channel, "cmds, players, achat (ADMIN), dchat (GLOBAL), unban, ban, oprison, saveall");
    return 1;
}

DCMD:saveall(user, channel, params[])
{
    new username[33];
    DCC_GetUserName(user, username, sizeof(username));
    if(channel != DCC_FindChannelById(CommandChannel))
    {
        return 1;
    }


    foreach(new i : Player)
    {
        SavePlayerVariables(i);
    }    
    SaveIllegalSystem();
    SMA(COLOR_LIGHTRED, "[Save Accouunts]"WHITE" %s has saved all player accounts.", username);
    return 1;
}

DCMD:ip(user, channel, params[]) {
	new DCC_Embed:embed = DCC_CreateEmbed("SERVER IP ADDRESS", "51.79.243.181:27515");
	DCC_SetEmbedColor(embed, 0xFF9900);
    DCC_SendChannelEmbedMessage(channel, embed);
	return 1;
}

DCMD:chat(user, channel, params[]) 
{
    new DCC_Role:role = DCC_FindRoleById("1404691196307046501"); //administrator
    new DCC_Guild:guild = DCC_FindGuildById("1376111395866677308");
    new bool:hasRole;
    DCC_HasGuildMemberRole(guild, user, role, hasRole);
	if(!hasRole) return DCC_SendChannelEmbedMessage(channel, DCC_Embed:DCC_CreateEmbed("Unauthorized", "You are not authorized to use this command.", .color=0xFF0606));

    if(isnull(params)) {
        DCC_SendChannelMessage(channel, "SYNTAX: !chat [msg]");
    } else {
        new str[144], username[33], dest[35];
        DCC_GetUserName(user, username, sizeof(username));
		DCC_GetUserDiscriminator(user, dest, sizeof(dest));

        format(str, sizeof(str), "(( Discord %s#%s says: %s ))", username, dest, params);
        SendClientMessageToAll(-1, str);
		DCC_SendChannelMessage(channel, "> SUCCESS");
		SendDiscordMessage("DC-CHAT", "((%s#%s says: %s ))", username, dest, params);
    }
    return 1;
}

DCMD:players(user, channel, params[])
{
	new szDialog[(1024 * 2)], title[300];
	new sz_playerName[MAX_PLAYER_NAME];
	foreach(new i : Player)
	{
		GetPlayerName(i, sz_playerName, MAX_PLAYER_NAME);
		format(szDialog, sizeof(szDialog), "%s> %d    %s       %d\n", szDialog, i, sz_playerName, GetPlayerPing(i));
	}
	
    if(Iter_Count(Player) < 1) format(title, sizeof(title), "**SERVER IS CURRENTLY EMPTY :(");
	format(title, sizeof(title), "*Players: (%d/%d)* \n> **ID     NICKNAME     PING**", Iter_Count(Player), MAX_PLAYERS);
	
	new DCC_Embed:embed = DCC_CreateEmbed("**"SERVER_NAME"**");
    DCC_SetEmbedColor(embed, 0xFF9900);
    DCC_AddEmbedField(embed,title, szDialog, true);
	return DCC_SendChannelEmbedMessage(channel, embed); 
}

DCMD:help(user, channel, params[])
{
    new DCC_Role:role = DCC_FindRoleById("1404691196307046501"); //administrator
    new DCC_Guild:guild = DCC_FindGuildById("1376111395866677308");
    new bool:hasRole;
    
    DCC_HasGuildMemberRole(guild, user, role, hasRole);
    new dc_commands[290];
    if(!hasRole) format(dc_commands, 290, "> !status !ip !players !profile\n> !link (verification)");
    format(dc_commands, 290, "> !status !ip !players !profile !ann !chat !kick\n> !link (verification)");

	new DCC_Embed:embed1 = DCC_CreateEmbed(":question: *!help*");
    DCC_SetEmbedColor(embed1, 0xFF9900);
	DCC_AddEmbedField(embed1,"**Available commands**:", dc_commands, true);
    
	DCC_SetEmbedFooter(embed1, "<:ocrp_logo:1412501580862984283> OC:RP Development Team");
    DCC_SendChannelEmbedMessage(channel, embed1);
	return 1;
}

DCMD:status(user, channel, params[])
{
    foreach(new i : Player) { /**/ }
    
    new mass_string[1800];
	format(mass_string, 1800, "> IP:```openmppanel.playsamp.fun:6012``` \n> <:ocrp_online:1412501580862984283> `%i` \n> <:wgrp_uptime:1082593584445931541> `%i hour, %i minutes , %i seconds` \n> <:wgrp_logo:1082593178001092618> WC:RP Development Team", Iter_Count(Player), ServerData[svrHours], ServerData[svrMins], ServerData[svrScs]);
	
	DCC_SendChannelEmbedMessage(channel, DCC_Embed:DCC_CreateEmbed("<:ocrp_up:1412501580862984283>Syudad La Realidad is Online!", mass_string, .color=0xFF9900));
	return 1;
}

DCMD:profile(user, channel, params[])
{
    if(isnull(params))
    {
        return DCC_SendChannelEmbedMessage(channel, DCC_Embed:DCC_CreateEmbed("", "`Usage: !profile [username]`", .color=0x343434));
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "SELECT * FROM users WHERE username = '%e'", params);
    mysql_tquery(connectionID, queryBuffer, "DiscordCheckingStats", "s", params);
    return 1;
}

forward DiscordCheckingStats(username[]);
public DiscordCheckingStats(username[])
{
    profile_channel = DCC_FindChannelById(PROFILE_CHANNEL_ID);
    if(!cache_get_row_count(connectionID))
	{
        DCC_SendChannelEmbedMessage(profile_channel, DCC_Embed:DCC_CreateEmbed("Error: Invalid Username", "The player specified doesn't exist.", .color=0x343434));
    }
    else
    {
        new skin, hours, number;
        new online[20], string[1028], skinurl[1028];
        
        skin = cache_get_field_content_int(0, "skin");
        hours = cache_get_field_content_int(0, "hours");
        number = cache_get_field_content_int(0, "phone");

        if(!IsPlayerOnline(username)) {
            online = "Offline";
        } else {
            online = "Online";
        }

        new DCC_Embed:embed = DCC_CreateEmbed("<:wgrp_logo:1082593178001092618> "SERVER_NAME" Profile");
        format(string, sizeof(string), "**Name:** %s\n**Status:** %s\n**Skin:** %i\n**Playing Hours:** %i\n**Phone Number:** %i", username, online, skin, hours, number);
        format(skinurl, sizeof(skinurl), "https://assets.open.mp/assets/images/skins/%i.png", cache_get_field_content_int(0, "skin"));
        DCC_SetEmbedDescription(embed, string);
        DCC_SetEmbedImage(embed, skinurl);
        DCC_SetEmbedColor(embed, 0xFF9900);
        DCC_SendChannelEmbedMessage(profile_channel, embed);
    }
}

#endif
