
CMD:bet(playerid, params[]) 
{
	if(cockFight[IsBetOpen])
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ])) return SendClientMessage(playerid, COLOR_GRAD1, "You are not near in the betting place/pickup");

		new side[8], betamount;
		if(sscanf(params, "s[8]d", side, betamount)) return SM(playerid, COLOR_GRAD1, "/bet [red/blue] [amount]");
		if(betamount < cockFight[MinimumBet]) return SM(playerid, COLOR_GRAD1, "The minimum bet is $%s", number_format(cockFight[MinimumBet]));
		if(betamount > PlayerInfo[playerid][pCash]) return SM(playerid, COLOR_GRAD1, "Insufficient funds.");
		if(betInfo[playerid][MeronBetAmount] > 0 && !strcmp(side, "meron")) return SM(playerid, COLOR_GRAD1, "* You already have placed your bet on Meron. | Amount: $%s", number_format(betInfo[playerid][MeronBetAmount]));
		if(betInfo[playerid][WalaBetAmount] > 0 && !strcmp(side, "wala")) return SM(playerid, COLOR_GRAD1, "* You already have placed your bet on Wala. | Amount: $%s", number_format(betInfo[playerid][WalaBetAmount]));

		if(!strcmp(side, "red"))
		{
			betInfo[playerid][MeronBetAmount] = betamount;
			cockFight[MeronBet] += betamount;
			cockFight[TotalBet] += betamount;
			cockFight[TempTotalBet] += betamount;
			SendClientMessageEx(playerid, COLOR_GRAD1, "* You have placed your bet on Red. | Amount: $%s", number_format(betInfo[playerid][MeronBetAmount]));
		}
		else if(!strcmp(side, "blue"))
		{
			betInfo[playerid][WalaBetAmount] = betamount;
			cockFight[WalaBet] += betamount;
			cockFight[TotalBet] += betamount;
			cockFight[TempTotalBet] += betamount;
			SendClientMessageEx(playerid, COLOR_GRAD1, "* You have placed your bet on Blue. | Amount: $%s", number_format(betInfo[playerid][WalaBetAmount]));
		}
		else return SendClientMessageEx(playerid, COLOR_GRAD1, "/bet [red/blue] [amount]");

		GivePlayerCash(playerid, -betamount);
		UpdateAllFightTD();
		return 1;
	}
	SendClientMessage(playerid, COLOR_GRAD1, "* The betting is already closed.");
	return 1;
}
