/*
										
________              __________                     _______ ____________________________
______(_)___  __________  /___(_)________________________/ // /__|__  /_  ___/__  /_  __ \
_____  /_  / / /_  ___/  __/_  /__  __ \_  __ \_  __ \ _  _  __/__/_ <_  __ \__  /_  / / /
____  / / /_/ /_(__  )/ /_ _  / _  / / /  / / /  / / /_  _  __/____/ // /_/ /_  / / /_/ /
___  /  \__,_/ /____/ \__/ /_/  /_/ /_//_/ /_//_/ /_/ /_//_/   /____/ \____/ /_/  \____/
/___/
							Discord: justinnn#3670
*/

new PlayerFactionBanLift[MAX_PLAYERS];

#define 		JUSTIN_DEF_BAN_DURATION 	432000

OnGameModeInit2()
{
	new query[256] = "\
	CREATE TABLE IF NOT EXISTS justin_factionbans \
	( \
	    `sqlid` INT NOT NULL AUTO_INCREMENT, \
	    `liftdate` BIGINT NOT NULL DEFAULT 0, \
	    PRIMARY KEY (sqlid)\
	)";
	mysql_query(connectionID, query);

	return 1;
}

GetPlayeyFactionBanInfo(playerid)
{
	new query[512];
	mysql_format(connectionID, query, sizeof(query), "SELECT liftdate FROM `justin_factionbans` WHERE sqlid = '%d'", PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, query, "OnPlayerGetFactionBanInfo", "d", playerid);


	new query2[512];
	mysql_format(connectionID, query2, sizeof(query2), "SELECT * FROM `player_binds` WHERE `userid` = %d ORDER BY `bid` ASC", PlayerInfo[playerid][pID]);
	mysql_tquery(connectionID, query2, "OnPlayerGetBinds", "d", playerid);
}

forward OnPlayerGetBinds(playerid);
public OnPlayerGetBinds(playerid)
{
	if(cache_get_row_count(connectionID))
	{
	    for(new i; i < cache_get_row_count(connectionID); i++)
	    {
	        new bindNum = cache_get_field_content_int(i, "bid");
	        pBindData[playerid][bindNum] = cache_get_field_content_int(i, "btype");
	        cache_get_field_content(i, "btext", pBindTextData[playerid][bindNum]);
	    }
	}
	else
	{
	    for(new i; i < MAX_BINDS; i++)
	    {
	        new query[128];
	        mysql_format(connectionID, query, sizeof(query), "INSERT INTO `player_binds` (`userid`, `bid`) VALUES (%d, %d)", PlayerInfo[playerid][pID], i);
	        mysql_tquery(connectionID, query);
	    }
	}
	return 1;
}

forward OnPlayerGetFactionBanInfo(playerid);
public OnPlayerGetFactionBanInfo(playerid)
{
	if(cache_get_row_count(connectionID))
	{
		PlayerFactionBanLift[playerid] = cache_get_row_int(0, 0);
	}
	else
	{
		PlayerFactionBanLift[playerid] = 0;
	}
	return 1;
}

CMD:unfactionban(playerid, params[])
{
	new targetid;

	if(PlayerInfo[playerid][pAdmin] < 7 || !PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "u", targetid))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /unfactionban [playerid]");
	}
	if(PlayerFactionBanLift[targetid] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "Target player is not faction banned.");
	}

	PlayerFactionBanLift[targetid] = 0;

	new query[256];
	mysql_format(connectionID, query, sizeof(query), "DELETE FROM `justin_factionbans` WHERE `sqlid` = '%d'", PlayerInfo[targetid][pID]);
	mysql_tquery(connectionID, query);

	SCM(playerid, COLOR_LIGHTRED, "Player unbanned from joining factions/groups.");
	return 1;
}

CMD:factionban(playerid, params[])
{
	new targetid, duration;

	if(PlayerInfo[playerid][pAdmin] < 7 || !PlayerInfo[playerid][pFactionMod])
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
	}
	if(sscanf(params, "ud", targetid, duration))
	{
	    return SCM(playerid, COLOR_SYNTAX, "Usage: /factionban [playerid] [days]");
	}
	duration *= 86400;

	FactionBanPlayer(playerid, duration);

	SCM(playerid, COLOR_LIGHTRED, "Player banned from joining factions/groups.");
	return 1;
}

CMD:myfactionban(playerid, params[])
{
	if(PlayerFactionBanLift[playerid] == 0)
	{
	    return SendClientMessage(playerid, COLOR_GREY, "You are not faction banned.");
	}
	else
	{
		new string[520];
		format(string, sizeof(string), "* You are currently faction banned for %s. This is because you were recently kicked/leaved a group/faction.", ConvertTimeS(PlayerFactionBanLift[playerid] - gettime()));
		SendClientMessage(playerid, COLOR_LIGHTRED, string);
	}
	return 1;
}

FactionBanPlayer(playerid, duration = JUSTIN_DEF_BAN_DURATION)
{
	PlayerFactionBanLift[playerid] = duration + gettime();

	new query[256];
	mysql_format(connectionID, query, sizeof(query), "INSERT INTO `justin_factionbans` (`sqlid`, `liftdate`) VALUES ('%d', '%d') ON DUPLICATE KEY UPDATE `liftdate` = '%d'", PlayerInfo[playerid][pID], PlayerFactionBanLift[playerid], PlayerFactionBanLift[playerid]);
	mysql_tquery(connectionID, query);
	return 1;
}

IsPlayerFactionBanned(playerid)
{
	return PlayerFactionBanLift[playerid] > gettime();
}

stock ConvertTimeS(seconds, TYPE = 0)
{
	new string[64], minutes;
	if(TYPE == 0) {
		if(seconds > 86400)
		{
			if(floatround((seconds/86400), floatround_floor) > 1) format(string, sizeof(string), "%d days", floatround((seconds/86400), floatround_floor));
			else format(string, sizeof(string), "%d day", floatround((seconds/86400), floatround_floor));
			seconds=seconds-((floatround((seconds/86400), floatround_floor))*86400);
		}
		if(seconds > 3600)
		{
			if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
			if(floatround((seconds/3600), floatround_floor) > 1) format(string, sizeof(string), "%s%d hours", string, floatround((seconds/3600), floatround_floor));
			else format(string, sizeof(string), "%s%d hour", string, floatround((seconds/3600), floatround_floor));
			seconds=seconds-((floatround((seconds/3600), floatround_floor))*3600);
		}
		if(seconds > 60)
		{
			if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
			if(floatround((seconds/60), floatround_floor) > 1) format(string, sizeof(string), "%s%d minutes", string, floatround((seconds/60), floatround_floor));
			else format(string, sizeof(string), "%s%d minute", string, floatround((seconds/60), floatround_floor));
			seconds=seconds-((floatround((seconds/60), floatround_floor))*60);
		}
		if(strlen(string) > 0) format(string, sizeof(string), "%s, ", string);
		if(seconds > 1) format(string, sizeof(string), "%s%d seconds", string, seconds);
		else if(seconds != 0) format(string, sizeof(string), "%s%d second", string, seconds);
	}
	else {
		if(seconds > 60)
		{
			minutes = floatround((seconds/60), floatround_floor);
			if(minutes > 9) format(string, sizeof(string), "%d", minutes);
			else format(string, sizeof(string), "0%d", minutes);
			seconds = seconds - (minutes * 60);
		}
		if(minutes > 0) {
			if(seconds > 9) format(string, sizeof(string), "%s:%d", string, seconds);
			else format(string, sizeof(string), "%s:0%d", string, seconds);
		}
		else {
			if(seconds > 9) format(string, sizeof(string), "00:%d", seconds);
			else format(string, sizeof(string), "00:0%d", seconds);
		}
		
	}
	return string;
}
