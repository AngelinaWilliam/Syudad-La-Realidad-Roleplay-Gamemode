public OnPlayerConnect(playerid)
{
	new tempStr[64];
	//Player Textdraws
	BoxingTD[playerid][0] = CreatePlayerTextDraw(playerid, 226.000000, 317.000000, "_");
	PlayerTextDrawFont(playerid, BoxingTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][0], 0.600000, 1.150003);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][0], 299.500000, 130.500000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][0], -16777081);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][0], 0);

	BoxingTD[playerid][1] = CreatePlayerTextDraw(playerid, 412.000000, 317.000000, "_");
	PlayerTextDrawFont(playerid, BoxingTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][1], 0.600000, 1.150003);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][1], 299.500000, 130.500000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][1], 65415);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][1], 0);

	BoxingTD[playerid][2] = CreatePlayerTextDraw(playerid, 228.000000, 318.000000, "Jahseh Qwery");
	PlayerTextDrawFont(playerid, BoxingTD[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][2], 0.241666, 0.949999);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][2], 400.000000, 139.000000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][2], 130);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][2], 0);

	BoxingTD[playerid][3] = CreatePlayerTextDraw(playerid, 412.000000, 318.000000, "QUIN HERS");
	PlayerTextDrawFont(playerid, BoxingTD[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][3], 0.241666, 0.949999);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][3], 400.000000, 127.000000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][3], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][3], 130);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][3], 0);

	BoxingTD[playerid][4] = CreatePlayerTextDraw(playerid, 228.000000, 340.000000, "TOTAL BETS ~g~$5,000");
	PlayerTextDrawFont(playerid, BoxingTD[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][4], 0.241666, 0.949999);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][4], 295.000000, 139.000000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][4], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][4], 130);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][4], 0);

	format(tempStr, sizeof(tempStr), "PAYOUT = ~r~$%s", number_format(betInfo[playerid][MeronBetAmount]));
	BoxingTD[playerid][5] = CreatePlayerTextDraw(playerid,  228.000000, 357.000000, tempStr);
	PlayerTextDrawFont(playerid, BoxingTD[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][5], 0.241666, 0.949999);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][5], 295.000000, 139.000000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][5], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][5], 130);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][5], 0);


	BoxingTD[playerid][6] = CreatePlayerTextDraw(playerid, 412.000000, 340.000000, "TOTAL BETS ~g~$5,000");
	PlayerTextDrawFont(playerid, BoxingTD[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][6], 0.241666, 0.949999);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][6], 295.000000, 139.000000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][6], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][6], 130);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][6], 0);

	format(tempStr, sizeof(tempStr), "PAYOUT = ~r~$%s", number_format(betInfo[playerid][WalaBetAmount]));
	BoxingTD[playerid][7] = CreatePlayerTextDraw(playerid, 412.000000, 357.000000, tempStr);
	PlayerTextDrawFont(playerid, BoxingTD[playerid][7], 2);
	PlayerTextDrawLetterSize(playerid, BoxingTD[playerid][7], 0.241666, 0.949999);
	PlayerTextDrawTextSize(playerid, BoxingTD[playerid][7], 295.000000, 139.000000);
	PlayerTextDrawSetOutline(playerid, BoxingTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, BoxingTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, BoxingTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, BoxingTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, BoxingTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, BoxingTD[playerid][7], 130);
	PlayerTextDrawUseBox(playerid, BoxingTD[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, BoxingTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, BoxingTD[playerid][7], 0);

	Fight_MeronHP[playerid] = CreatePlayerProgressBar(playerid, 199.000000, 380.000000, 62.000000, 4.000000, -1, 100.000000, 0);
	SetPlayerProgressBarValue(playerid, Fight_MeronHP[playerid], 50.000000);

	Fight_WalaHP[playerid] = CreatePlayerProgressBar(playerid, 385.000000, 380.000000, 62.000000, 4.000000, -1, 100.000000, 0);
	SetPlayerProgressBarValue(playerid, Fight_WalaHP[playerid], 50.000000);

	HideFightTD(playerid);

	#if defined justin_OnPlayerConnect
		return justin_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect justin_OnPlayerConnect
#if defined justin_OnPlayerConnect
	forward justin_OnPlayerConnect(playerid);
#endif


CMD:showfighttd(playerid, params[])
{
	ShowFightTD(playerid);
	return 1;
}

CMD:hidefighttd(playerid, params[])
{
	HideFightTD(playerid);
	return 1;
}

ShowFightTD(playerid, showWin = 0)
{
	UpdatePlayerBetTD(playerid);

    for (new i = 0; i < 8; i ++) 
    {
        PlayerTextDrawShow(playerid, BoxingTD[playerid][i]);
    }

	if(showWin == 1)
	{
		PlayerTextDrawShow(playerid, BoxingTD[playerid][0]);
		PlayerTextDrawShow(playerid, BoxingTD[playerid][2]);
	}
	else if(showWin == 2)
	{
		PlayerTextDrawShow(playerid, BoxingTD[playerid][1]);
		PlayerTextDrawShow(playerid, BoxingTD[playerid][3]);
	}
	else
	{
		new Float:hp;
		GetPlayerHealth(cockFight[Fighter1ID], hp);
		SetPlayerProgressBarValue(playerid, Fight_MeronHP[playerid], hp);
		GetPlayerHealth(cockFight[Fighter2ID], hp);
		SetPlayerProgressBarValue(playerid, Fight_WalaHP[playerid], hp);

		ShowPlayerProgressBar(playerid, Fight_WalaHP[playerid]);
		ShowPlayerProgressBar(playerid, Fight_MeronHP[playerid]);
	}
}

HideFightTD(playerid)
{
    for (new i = 0; i < 8; i ++) 
    {
        PlayerTextDrawHide(playerid, BoxingTD[playerid][i]);
    }

	HidePlayerProgressBar(playerid, Fight_MeronHP[playerid]);
	HidePlayerProgressBar(playerid, Fight_WalaHP[playerid]);
}

UpdateAllFightTD(bool:updatePlayers = true)
{
	foreach(new i : Player)
	{	
		new tempStr[64], meronid = cockFight[Fighter1ID], walaid = cockFight[Fighter2ID];
		format(tempStr, sizeof(tempStr), "~y~$%s", number_format(cockFight[MeronBet]));
		PlayerTextDrawSetString(i, BoxingTD[i][4], tempStr);
		format(tempStr, sizeof(tempStr), "~y~$%s", number_format(cockFight[WalaBet]));
		PlayerTextDrawSetString(i, BoxingTD[i][6], tempStr);

		format(tempStr, sizeof(tempStr), "%s", GetPlayerNameEx(meronid));
		PlayerTextDrawSetString(i, BoxingTD[i][2], tempStr);

		format(tempStr, sizeof(tempStr), "%s", GetPlayerNameEx(walaid));
		PlayerTextDrawSetString(i, BoxingTD[i][3], tempStr);
	}
	if(updatePlayers)
	{
		foreach(new i : Player)
		{
		    if(IsPlayerInDynamicArea(i, cockFight[FightArea]))
		    {
		        UpdatePlayerBetTD(i);
		    }
		}
	}
}

UpdatePlayerBetTD(playerid)
{
	new tempStr[64];
	new walapayout = GetWalaPayout(playerid);
	new waladeduction = cockFight[WinDeduction] <= 0.0 ? 0 : floatround((float(walapayout) - float(betInfo[playerid][WalaBetAmount])) * cockFight[WinDeduction]);
	new walawinamount = walapayout - waladeduction;

	new meronpayout = GetMeronPayout(playerid);
	new merondeduction = cockFight[WinDeduction] <= 0.0 ? 0 : floatround((float(meronpayout) - float(betInfo[playerid][MeronBetAmount])) * cockFight[WinDeduction]);
	new meronwinamount = meronpayout - merondeduction;

	format(tempStr, sizeof(tempStr), "PAYOUT = ~g~$%s", number_format(meronwinamount));
	PlayerTextDrawSetString(playerid, BoxingTD[playerid][5], tempStr);
	format(tempStr, sizeof(tempStr), "PAYOUT = ~g~$%s", number_format(walawinamount));
	PlayerTextDrawSetString(playerid, BoxingTD[playerid][7], tempStr);
}