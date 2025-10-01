CMD:ocrp(playerid, params[])
{
	if(PlayerInfo[playerid][pRefunded] == 1)
	{
	    return SCM(playerid, COLOR_GREY, "You have already claimed your refund package.");
	}
	else
    RefundPlayer(playerid);
	SMA(COLOR_LIGHTRED, "{ffac1d}[SERVER]: {37ff04}%s {FFFFFF}has claimed their refund package using {FF0000}/ocrp.", GetRPName(playerid));
	ShowPlayerDialog(playerid, DIALOG_REFUND, DIALOG_STYLE_MSGBOX, "{eec90e}[ocrp]: {FFFFFF}You have claimed your refund package", "{FFFFFF}As you came to our server, you have received the following as a starter package:\n\n{25b200}${FFFFFF}250,000 {4fff22}(CASH)\n{A028AD}Gold Donator{FFFFFF}(14 days)\n{FF0000}Faggio Vehicle {FFFFFF}(/vst)\n\n{FFFFFF}We hope that you will invite more of your friends to play on the server!\n\n{FFFFFF}Credits for freebies: Nescafe\n{FFFFFF}Developer: BINNI Danzy","{36FF00}Claim","Exit");
	return 1;
}

RefundPlayer(playerid)
{
	if(PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pRefunded] = 1;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET refunded = 1 WHERE uid = %i", PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
        GivePlayerCash(playerid, 20000);
        new vehicleid = 550;
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO vehicles (ownerid, owner, modelid, pos_x, pos_y, pos_z, pos_a, color1, color2) VALUES(%i, '%s', 462, '%f', '%f', '%f', '%f', 0, 0)", PlayerInfo[playerid][pID], GetPlayerNameEx(playerid), vehicleid, x + 2.0 * floatsin(-a, degrees), y + 2.0 * floatcos(-a, degrees), z, a);
		mysql_tquery(connectionID, queryBuffer);
		VIPRefund(playerid);
	}
}

VIPRefund(playerid)
{
	if (PlayerInfo[playerid][pLogged])
	{
		PlayerInfo[playerid][pVIPPackage] = 3;
		PlayerInfo[playerid][pVIPTime] = gettime() + (1209600);
		PlayerInfo[playerid][pVIPCooldown] = 0;
		mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
		mysql_tquery(connectionID, queryBuffer);
	}
}
