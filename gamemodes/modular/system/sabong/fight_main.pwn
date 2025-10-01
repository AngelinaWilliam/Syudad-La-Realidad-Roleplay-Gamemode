#define BET_MERON 1
#define BET_WALA 2

#define CF_TYPE_LO_DIES			0.25
#define CF_TYPE_WALO_ANIM		0.33
#define CF_TYPE_ONSE			0.375
#define CF_TYPE_TRES	 		0.5
#define CF_TYPE_SAMPU_ANIM 		0.66
#define CF_TYPE_DOBLADO 		0.99


enum E_COCKFIGHT
{
	Float:FighterPos1X,
	Float:FighterPos1Y,
	Float:FighterPos1Z,
	Float:FighterPos2X,
	Float:FighterPos2Y,
	Float:FighterPos2Z,
	Float:BetPosX,
	Float:BetPosY,
	Float:BetPosZ,
	Fighter1ID,
	Fighter2ID,
	Float:CockType,
	Float:WinDeduction,
	MinimumBet,

    BettingCP,
    Text3D:BettingText3D,
    FightArea,

    bool:IsBetOpen,
    bool:IsMatchStarted,
    CountDownTimer,

    MeronBet,
    WalaBet,
    TotalBet,
    TempTotalBet

}
new cockFight[E_COCKFIGHT];

enum E_BET_INFO
{
	MeronBetAmount,
	WalaBetAmount
}
new betInfo[MAX_PLAYERS][E_BET_INFO];


new cockFightcount = 5;


new PlayerText:BoxingTD[MAX_PLAYERS][8];
new PlayerBar:Fight_MeronHP[MAX_PLAYERS];
new PlayerBar:Fight_WalaHP[MAX_PLAYERS];



#include "modular\system\sabong/fight_client.pwn"
#include "modular\system\sabong/fight_td.pwn"



ResetCockFightVars(bool:resetpos = true)
{
    foreach(new i : Player)
    {
        betInfo[i][WalaBetAmount] = 0;
        betInfo[i][MeronBetAmount] = 0;
        HideFightTD(i);
    }

    if(resetpos)
    {
        cockFight[FighterPos1X] = 0.0;
        cockFight[FighterPos1Y] = 0.0;
        cockFight[FighterPos1Z] = 0.0;
        cockFight[FighterPos2X] = 0.0;
        cockFight[FighterPos2Y] = 0.0;
        cockFight[FighterPos2Z] = 0.0;
        cockFight[BetPosX] = 0.0;
        cockFight[BetPosY] = 0.0;
        cockFight[BetPosZ] = 0.0;
        cockFight[CockType] = CF_TYPE_SAMPU_ANIM;
        cockFight[WinDeduction] = 0.0;
        cockFight[MinimumBet] = 1000;
    	cockFight[Fighter1ID] = INVALID_PLAYER_ID;
        cockFight[Fighter2ID] = INVALID_PLAYER_ID;
    }
    cockFight[IsBetOpen] = false;
    cockFight[IsMatchStarted] = false;
    cockFight[MeronBet] = 0;
    cockFight[WalaBet] = 0;
    cockFight[TotalBet] = 0;
    cockFight[TempTotalBet] = 0;
    if(IsValidDynamicPickup(cockFight[BettingCP])) DestroyDynamicPickup(cockFight[BettingCP]);
    if(IsValidDynamic3DTextLabel(cockFight[BettingText3D])) DestroyDynamic3DTextLabel(cockFight[BettingText3D]), cockFight[BettingText3D] = Text3D:-1;
    if(IsValidDynamicArea(cockFight[FightArea])) DestroyDynamicArea(cockFight[FightArea]), cockFight[FightArea] = -1;
    KillTimer(cockFight[CountDownTimer]);

}

IsPlayerFighter(playerid)
{
    return cockFight[Fighter1ID] == playerid || cockFight[Fighter2ID] == playerid;
}

IsSabongActive()
{
    return cockFight[IsBetOpen] || cockFight[IsMatchStarted];
}

GetFightType(Float:type)
{
	new str[124];
	if(type == CF_TYPE_LO_DIES) str = "LO DIES (.25)";
	else if(type == CF_TYPE_WALO_ANIM) str = "Walo-Anim (.33)";
	else if(type == CF_TYPE_ONSE) str = "Onse (.375)";
	else if(type == CF_TYPE_TRES) str = "Tres (.5)";
	else if(type == CF_TYPE_SAMPU_ANIM) str = "Sampu-anim (.66)";
	else if(type == CF_TYPE_DOBLADO) str = "Doblado (2)";
	return str;
}

ShowCockFightMenuFunc(playerid)
{
	new str[512];
	format(str, sizeof(str), "\
        %s\n\
        %s\n\
        %s\n\
        Fighter 1: {FF0000}%s{FFFFFF}\n\
        Fighter 2: {2641FE}%s{FFFFFF}\n\
        Type: %s\n\
        Charge (On-Win) %d%%\n\
        Minimum Bet: $%s\n\
        {FFFF00}%s{FFFFFF}\n\
        {FF0000}Reset/Force End",
		cockFight[BetPosX] == 0.0 && cockFight[BetPosY] == 0.0 && cockFight[BetPosZ] == 0.0 ? ("Set Bet Position here") : ("{696969}Change Bet Position{FFFFFF}"),
        cockFight[FighterPos1X] == 0.0 && cockFight[FighterPos1Y] == 0.0 && cockFight[FighterPos1Z] == 0.0 ? ("Set Fighter Position 1 here") : ("{696969}Change Fighter Position 1{FFFFFF}"),
        cockFight[FighterPos2X] == 0.0 && cockFight[FighterPos2Y] == 0.0 && cockFight[FighterPos2Z] == 0.0 ? ("Set Fighter Position 2 here") : ("{696969}Change Fighter Position 2{FFFFFF}"),
        cockFight[Fighter1ID] != INVALID_PLAYER_ID ? GetPlayerNameEx(cockFight[Fighter1ID]) : ("None"),
		cockFight[Fighter2ID] != INVALID_PLAYER_ID ? GetPlayerNameEx(cockFight[Fighter2ID]) : ("None"),
		GetFightType(cockFight[CockType]),
		floatround(cockFight[WinDeduction] * 100.0),
		number_format(cockFight[MinimumBet]),
        cockFight[IsBetOpen] ? ("Close Betting and Start the Fight") : ("Open Betting")
	);
    ShowPlayerDialog(playerid, ShowCockFightMenu, DIALOG_STYLE_LIST, "Boxing Menu", str, "Select", "Cancel");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case ShowCockFightMenu:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0:
                    {
                        GetPlayerPos(playerid, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ]);
                        SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Bet position set.");
                        return 1;
                    }
                    case 1:
                    {
                        GetPlayerPos(playerid, cockFight[FighterPos1X], cockFight[FighterPos1Y], cockFight[FighterPos1Z]);                  
                        SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Fighter 1 position set.");
                        return 1;
                    }
                    case 2:
                    {
                        GetPlayerPos(playerid, cockFight[FighterPos2X], cockFight[FighterPos2Y], cockFight[FighterPos2Z]);
                        SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Fighter 2 position set.");
                        return 1;
                    }
                    case 3: return ShowSetFighterMenuFunc(playerid, 1);
                    case 4: return ShowSetFighterMenuFunc(playerid, 2);
                    case 5: return ShowFightTypeSelectionFunc(playerid);
                    case 6: return ShowChargeMenuFunc(playerid);
                    case 7: return SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Due to some bugs, this feature is disabled. Use /setminbet instead.");
                    case 8:
                    {
                        if(!cockFight[IsBetOpen])
                        {
                            if(cockFight[IsMatchStarted]) return SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Match already started.");
                            if(cockFight[FighterPos1X] == 0.0 || cockFight[FighterPos1Y] == 0.0 || cockFight[FighterPos1Z] == 0.0 || cockFight[FighterPos2X] == 0.0 || cockFight[FighterPos2Y] == 0.0 || cockFight[FighterPos2Z] == 0.0 || cockFight[BetPosX] == 0.0 || cockFight[BetPosY] == 0.0 || cockFight[BetPosZ] == 0.0 || cockFight[Fighter1ID] == INVALID_PLAYER_ID || cockFight[Fighter2ID] == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Fight is not completely setup.");
                            if(!IsPlayerConnected(cockFight[Fighter1ID]) && !IsPlayerConnected(cockFight[Fighter2ID])) return SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] One of the fighters is disconnected.");
                            OpenFightBetting();

                            new str3[254];
                            format(str3, sizeof(str3), "[Boxing System]: "WHITE" %s hosted a fight.", GetPlayerNameEx(playerid));
                            SAM(COLOR_LIGHTBLUE, str3, 2);
                        }
                        else if(cockFight[IsBetOpen])
                        {
                            if(IsValidDynamicPickup(cockFight[BettingCP])) DestroyDynamicPickup(cockFight[BettingCP]);
                            if(IsValidDynamic3DTextLabel(cockFight[BettingText3D])) DestroyDynamic3DTextLabel(cockFight[BettingText3D]), cockFight[BettingText3D] = Text3D:-1;

                            new meronPlayer = cockFight[Fighter1ID], walaPlayer = cockFight[Fighter2ID];
                            SetPlayerPos(meronPlayer, cockFight[FighterPos1X], cockFight[FighterPos1Y], cockFight[FighterPos1Z]);
                            SetPlayerPos(walaPlayer, cockFight[FighterPos2X], cockFight[FighterPos2Y], cockFight[FighterPos2Z]);
                            TogglePlayerControllable(meronPlayer, false);
                            TogglePlayerControllable(walaPlayer, false);
                            PlayerInfo[meronPlayer][pNoDamage] = 0;
                            PlayerInfo[walaPlayer][pNoDamage] = 0;

                            cockFight[CountDownTimer] = SetTimerEx("CockFightCountDown", 1000, true, "");

                            SendClientMessageToAll(COLOR_LIGHTBLUE, "* Betting has been closed, the match has started.");
                            SendClientMessageToAll(COLOR_LIGHTBLUE, "* Be in range of match to view the status. /gotofight to mark the venue on your map.");
                        }
                    }
                    case 9:
                    {
                        new meronPlayer = cockFight[Fighter1ID], walaPlayer = cockFight[Fighter2ID];
                        if(IsPlayerConnected(meronPlayer))
                        {
                            SetPlayerWeapons(meronPlayer);
                            SetPlayerSkin(meronPlayer, PlayerInfo[meronPlayer][pSkin]);
                            SetPlayerPos(meronPlayer, cockFight[FighterPos1X], cockFight[FighterPos1Y], cockFight[FighterPos1Z]);
                            SetPlayerColor(meronPlayer, 0xFFFFFF00);
                            PlayerInfo[meronPlayer][pNoDamage] = 0;
                            RemovePlayerAttachedObject(meronPlayer, 9);
                        }
                        if(IsPlayerConnected(walaPlayer))
                        {
                            SetPlayerSkin(walaPlayer, PlayerInfo[walaPlayer][pSkin]);
                            SetPlayerPos(walaPlayer, cockFight[FighterPos2X], cockFight[FighterPos2Y], cockFight[FighterPos2Z]);
                            SetPlayerColor(walaPlayer, 0xFFFFFF00);
                            SetPlayerWeapons(walaPlayer);
                            PlayerInfo[walaPlayer][pNoDamage] = 0;
                            RemovePlayerAttachedObject(walaPlayer, 9);
                        }
                        foreach(new i : Player)
                        {
                            if(betInfo[i][WalaBetAmount] > 0 || betInfo[i][MeronBetAmount] > 0)
                            {
                                GivePlayerCash(i, betInfo[i][WalaBetAmount]);
                                GivePlayerCash(i, betInfo[i][MeronBetAmount]);
                                SM(i, COLOR_GRAD1, "Your $%s bet has been refunded because the match is cancelled.", number_format(betInfo[i][WalaBetAmount] + betInfo[i][MeronBetAmount]));
                                betInfo[i][WalaBetAmount] = 0;
                                betInfo[i][MeronBetAmount] = 0;
                            }
                        }
                        ResetCockFightVars();
                        SendClientMessage(playerid, COLOR_GRAD1, "Boxing System reset.");
                    }
                }
            }
        }
        case ShowSetFighterMenu1:
        {
            if(response)
            {
                new fighterid = strval(inputtext);

                if(!IsPlayerConnected(fighterid)) return SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Player is not connected.");
                
                cockFight[Fighter1ID] = fighterid;

                SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Fighter set.");
                SendClientMessage(fighterid, COLOR_YELLOW, "[Boxing System]"WHITE" You are set as a fighter! Prepare for your fight!!!");
                callcmd::boxingmenu(playerid, "");
            }
            else callcmd::boxingmenu(playerid, "");
        }
        case ShowSetFighterMenu2:
        {
            if(response)
            {
                new fighterid = strval(inputtext);

                if(!IsPlayerConnected(fighterid)) return SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Player is not connected.");

                cockFight[Fighter2ID] = fighterid;

                SendClientMessage(playerid, COLOR_GRAD1, "[SERVER] Fighter set.");
                SendClientMessage(fighterid, COLOR_LIGHTBLUE, "[Boxing System]"WHITE" You are set as a fighter! Prepare for your fight!!!");
                callcmd::boxingmenu(playerid, "");
            }
            else callcmd::boxingmenu(playerid, "");
        }
        case ShowFightTypeSelection:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0: cockFight[CockType] = CF_TYPE_LO_DIES;
                    case 1: cockFight[CockType] = CF_TYPE_WALO_ANIM;
                    case 2: cockFight[CockType] = CF_TYPE_ONSE;
                    case 3: cockFight[CockType] = CF_TYPE_TRES;
                    case 4: cockFight[CockType] = CF_TYPE_SAMPU_ANIM;
                    case 5: cockFight[CockType] = CF_TYPE_DOBLADO;
                }

                SendClientMessage(playerid, COLOR_YELLOW, "[SERVER] Fight Type set.");
                callcmd::boxingmenu(playerid, "");
            }
            else callcmd::boxingmenu(playerid, "");
        }
        case ShowChargeMenu:
        {
            if(response)
            {
                new chargeamount = strval(inputtext);
                if(chargeamount < 0 || chargeamount > 80) return SendClientMessage(playerid, COLOR_YELLOW, "[SERVER] Please input 0 - 80. 0 = no charge.");
                cockFight[WinDeduction] = chargeamount == 0 ? 0.0 : float(chargeamount) / 100.0;

                SendClientMessage(playerid, COLOR_YELLOW, "[SERVER] Charge amount set.");
                callcmd::boxingmenu(playerid, "");
            }
            else callcmd::boxingmenu(playerid, "");
        }
    }
    #if defined justin_OnDialogResponse
        return justin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif

#define OnDialogResponse justin_OnDialogResponse
#if defined justin_OnDialogResponse
    forward justin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

ShowSetFighterMenuFunc(playerid, fighternum)
{
    if(fighternum == 1)
        ShowPlayerDialog(playerid, ShowSetFighterMenu1, DIALOG_STYLE_INPUT, "Boxing Menu - Set Fighter", "Please input the ID of the fighter", "Select", "Cancel");
    else if(fighternum == 2)
        ShowPlayerDialog(playerid, ShowSetFighterMenu2, DIALOG_STYLE_INPUT, "Boxing Menu - Set Fighter", "Please input the ID of the fighter", "Select", "Cancel");
    return 1;
}

ShowFightTypeSelectionFunc(playerid)
{
	ShowPlayerDialog(playerid, ShowFightTypeSelection, DIALOG_STYLE_LIST, "Boxing Menu - Set Type", "LO DIES (.25)\nWalo-Anim (.33)\nOnse (.375)\nTres (.5)\nSampu-anim (.66)\nDoblado (2x)", "Select", "Cancel");
    return 1;
}

ShowChargeMenuFunc(playerid)
{
	ShowPlayerDialog(playerid, ShowChargeMenu, DIALOG_STYLE_INPUT, "Boxing Menu - Set Charge amount on win", "Please input 1 - 80. ex. (50 is equivalent to 50%)", "Select", "Cancel");
    return 1;
}


OpenFightBetting()
{
    if(IsValidDynamicPickup(cockFight[BettingCP])) DestroyDynamicPickup(cockFight[BettingCP]);
    cockFight[BettingCP] = CreateDynamicPickup(1212, 23, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ]);
    if(IsValidDynamic3DTextLabel(cockFight[BettingText3D])) DestroyDynamic3DTextLabel(cockFight[BettingText3D]), cockFight[BettingText3D] = Text3D:-1;
    cockFight[BettingText3D] = CreateDynamic3DTextLabel(""GREY"[Betting Place]"WHITE"\nType '/bet' to place your bet.", -1, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ]+0.3, 8.0);
    if(IsValidDynamicArea(cockFight[FightArea])) DestroyDynamicArea(cockFight[FightArea]), cockFight[FightArea] = -1;
    cockFight[FightArea] = CreateDynamicSphere(cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ], 150.0);

    cockFight[IsBetOpen] = true;

    new meronPlayer = cockFight[Fighter1ID], walaPlayer = cockFight[Fighter2ID];

    ResetPlayerWeapons(meronPlayer);
    SetPlayerSkin(meronPlayer, 80);
    SetPlayerHealth(meronPlayer, 100);
    SetPlayerArmour(meronPlayer, 100);
    SetPlayerColor(meronPlayer, COLOR_RED);
    SetPlayerPos(meronPlayer, cockFight[FighterPos1X], cockFight[FighterPos1Y], cockFight[FighterPos1Z]);
    SendClientMessage(meronPlayer, COLOR_GRAD1, "* Dont fight yet. Betting only started. Wait for the countdown of match to start.");
    callcmd::dat(meronPlayer, "");
    PlayerInfo[meronPlayer][pNoDamage] = 1;

    ResetPlayerWeapons(walaPlayer);
    SetPlayerSkin(walaPlayer, 81);
    SetPlayerHealth(walaPlayer, 100);
    SetPlayerArmour(walaPlayer, 100);
    SetPlayerColor(walaPlayer, COLOR_BLUE);
    SetPlayerPos(walaPlayer, cockFight[FighterPos2X], cockFight[FighterPos2Y], cockFight[FighterPos2Z]);
    SendClientMessage(walaPlayer, COLOR_GRAD1, "* Dont fight yet. Betting only started. Wait for the countdown of match to start.");
    callcmd::dat(walaPlayer, "");
    PlayerInfo[walaPlayer][pNoDamage] = 1;

    SMA(COLOR_LIGHTBLUE, "* An fight %s has been hosted! The betting is now OPEN! /gotofight to mark the venue on your map.", GetFightType(cockFight[CockType]));
    if(random(100) > 60) SendClientMessageToAll(COLOR_YELLOW, "[PROTIP] Betting is one of the fastest way to earn huge amount of cash!");
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 50.0, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ]))
        {
            ShowFightTD(i);
        }
    }
    UpdateAllFightTD();
}

forward CockFightCountDown();
public CockFightCountDown()
{
    if(cockFightcount != 0)
    {
        new str[32];
        format(str, sizeof(str), "~y~%d", cockFightcount);

        foreach(new i : Player)
        {
            if(IsPlayerInRangeOfPoint(i, 50.0, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ]))
            {
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
                GameTextForPlayer(i, str, 1000, 3);
            }
        }
        cockFightcount--;
    }
    else if(cockFightcount >= 0)
    {
        KillTimer(cockFight[CountDownTimer]);
        StartCockFight();
        cockFightcount = 5;
        foreach(new i : Player)
        {
            if(IsPlayerInRangeOfPoint(i, 50.0, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ]))
            {
                PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);
                GameTextForPlayer(i, "~r~FIGHT", 1000, 3);
            }
        }
    }
    return 1;
}

StartCockFight()
{
    cockFight[IsBetOpen] = false;
    cockFight[IsMatchStarted] = true;
    new meronPlayer = cockFight[Fighter1ID], walaPlayer = cockFight[Fighter2ID];

    SetPlayerHealth(meronPlayer, 100);
    SetPlayerArmour(meronPlayer, 100);
    TogglePlayerControllable(meronPlayer, true);
    SetPlayerFightingStyle(meronPlayer, 4);
    SetPlayerAttachedObject(meronPlayer, 9, 19605, 1, 1.4659, 0.0000, 0.0000, 0.0000, 87.3999, 0.0000, 1.0000, 1.0000, 1.0000, 0xFF840410, 0xFFFFFFFF);
    PlayerInfo[meronPlayer][pNoDamage] = 0;

    SetPlayerHealth(walaPlayer, 100);
    SetPlayerArmour(walaPlayer, 100);
    TogglePlayerControllable(walaPlayer, true);
    SetPlayerFightingStyle(walaPlayer, 4);
    SetPlayerAttachedObject(walaPlayer, 9, 19607, 1, 1.4659, 0.0000, 0.0000, 0.0000, 87.3999, 0.0000, 1.0000, 1.0000, 1.0000, 0xFF840410, 0xFFFFFFFF);
    PlayerInfo[walaPlayer][pNoDamage] = 0;
}


forward EndMatch();
public EndMatch()
{
    new meronPlayer = cockFight[Fighter1ID], walaPlayer = cockFight[Fighter2ID];
    SetPlayerSkin(meronPlayer, PlayerInfo[meronPlayer][pSkin]);
    SetPlayerSkin(walaPlayer, PlayerInfo[walaPlayer][pSkin]);
    SetPlayerPos(meronPlayer, cockFight[FighterPos1X], cockFight[FighterPos1Y], cockFight[FighterPos1Z]);
    SetPlayerPos(walaPlayer, cockFight[FighterPos2X], cockFight[FighterPos2Y], cockFight[FighterPos2Z]);
    SetPlayerWeapons(meronPlayer);
    SetPlayerWeapons(walaPlayer);
    SetPlayerColor(meronPlayer, 0xFFFFFF00);
    SetPlayerColor(walaPlayer, 0xFFFFFF00);
    SetPlayerFightingStyle(meronPlayer, PlayerInfo[meronPlayer][pFightStyle]);
    SetPlayerFightingStyle(walaPlayer, PlayerInfo[walaPlayer][pFightStyle]);
    RemovePlayerAttachedObject(walaPlayer, 9);
    RemovePlayerAttachedObject(meronPlayer, 9);
    callcmd::dat(meronPlayer, "");
    callcmd::dat(walaPlayer, "");
    PlayerInfo[meronPlayer][pNoDamage] = 0;
    PlayerInfo[walaPlayer][pNoDamage] = 0;

    ResetCockFightVars(false);
    return 1;
}

forward DelayedRevive(playerid);
public DelayedRevive(playerid)
{
    PlayerInfo[playerid][pInjured] = 0;
    PlayerInfo[playerid][pHunger] = 100;
    PlayerInfo[playerid][pHungerTimer] = 0;
    PlayerInfo[playerid][pThirst] = 100;
    PlayerInfo[playerid][pThirstTimer] = 0;
    PlayerInfo[playerid][pBrokenLeg] = 0;
    TogglePlayerControllable(playerid, 1);
    SetPlayerHealth(playerid, 100.0);
    ClearAnimations(playerid, 1);

    if(PlayerInfo[playerid][pAcceptedEMS] != INVALID_PLAYER_ID)
    {
        PlayerInfo[playerid][pAcceptedEMS] = INVALID_PLAYER_ID;
    }
    ApplyAnimationEx(playerid, "PED", "getup_front", 4.0, 0, 1, 1, 0, 0);
    return 1;
}

ChargeFromTotalBets(amount)
{
    cockFight[TempTotalBet] -= amount;
}

Float:GetMeronOdds()
{
    return 1.0 / (float(cockFight[MeronBet]) / float(cockFight[TotalBet]));
}

Float:GetWalaOdds()
{
    return 1.0 / (float(cockFight[WalaBet]) / float(cockFight[TotalBet]));
}

GetMeronPayout(playerid)
{
    if(betInfo[playerid][MeronBetAmount] < 1000) return 0;
    return floatround((((float(betInfo[playerid][MeronBetAmount]) * GetMeronOdds()) - float(betInfo[playerid][MeronBetAmount])) * cockFight[CockType]) + float(betInfo[playerid][MeronBetAmount]), floatround_floor);
}

GetWalaPayout(playerid)
{
    if(betInfo[playerid][WalaBetAmount] < 1000) return 0;
    return floatround((((float(betInfo[playerid][WalaBetAmount]) * GetWalaOdds()) - float(betInfo[playerid][WalaBetAmount])) * cockFight[CockType]) + float(betInfo[playerid][WalaBetAmount]), floatround_floor);
}

CMD:gotofight(playerid, params[])
{
    if(cockFight[FighterPos1X] != 0.0 || cockFight[FighterPos1Y] != 0.0 || cockFight[FighterPos1Z] != 0.0 || cockFight[FighterPos2X] != 0.0 || cockFight[FighterPos2Y] != 0.0 || cockFight[FighterPos2Z] != 0.0 || cockFight[BetPosX] != 0.0 || cockFight[BetPosY] != 0.0 || cockFight[BetPosZ] != 0.0 || cockFight[Fighter1ID] != INVALID_PLAYER_ID || cockFight[Fighter2ID] != INVALID_PLAYER_ID)
    {
        if(IsPlayerInRangeOfPoint(playerid, 50.0, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ])) return SendClientMessage(playerid, COLOR_GRAD1, "You are already in the fighting area.");
        callcmd::kcp(playerid, "");
        SendClientMessage(playerid, -1, "* Fight Venue is marked on your map.");
        PlayerInfo[playerid][pCP] = CHECKPOINT_MISC;
        SetPlayerCheckpoint(playerid, cockFight[BetPosX], cockFight[BetPosY], cockFight[BetPosZ], 5.0);
        return 1;
    }
    return SendClientMessage(playerid, -1, "* Fight Venue is not completely setup. Please try again later.");
}

CMD:setminbet(playerid, params[]) 
{
    if(PlayerInfo[playerid][pAdmin] > 3)
    {
        new minbet;
        if(sscanf(params, "d", minbet)) return SendClientMessage(playerid, COLOR_GRAD1, "/setminbet [bet]");
        cockFight[MinimumBet] = minbet;
        SM(playerid, COLOR_GRAD1, "Minimum bet has been set to $%s", number_format(cockFight[MinimumBet]));
    }
    return 1;
}


CMD:boxingmenu(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 7)
	{
		ShowCockFightMenuFunc(playerid);
	}
	return 1;
}
