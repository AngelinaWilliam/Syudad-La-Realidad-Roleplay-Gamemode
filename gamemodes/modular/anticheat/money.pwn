forward GetPlayerCash(playerid);
public GetPlayerCash(playerid)
{
    return PlayerInfo[playerid][pCash];
}

GivePlayerCash(playerid, amount)
{
    if(PlayerInfo[playerid][pLogged])
    {
        PlayerInfo[playerid][pCash] = PlayerInfo[playerid][pCash] + amount;

        if(!PlayerInfo[playerid][pAdminDuty])
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET cash = cash + %i WHERE uid = %i", amount, PlayerInfo[playerid][pID]);
            mysql_tquery(connectionID, queryBuffer);
        }
    }
}
