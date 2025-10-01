#include <mentiones> 

public OnPlayerMentioned(playerid, targetid)
{
	new string[1028], type[1028];
	if(GetPVarInt(playerid, "MentionType") == 1)
	{
		type = "Global Chat (/g)";
	}
	else if(GetPVarInt(playerid, "MentionType") == 2)
	{
		type = "VIP Chat (/v)";
	}
	format(string, sizeof(string), "%s~w~ mentioned you from the ~g~%s", GetRPName(playerid), type);
	Dyuze(targetid, string, 5000);
    return 1;
}