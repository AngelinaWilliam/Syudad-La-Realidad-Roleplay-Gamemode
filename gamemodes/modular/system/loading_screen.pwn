new PlayerText:LoadingScreenTD[MAX_PLAYERS][9];

forward LoadingScreen(playerid);
public LoadingScreen(playerid)
{
	ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    SetTimerEx("LoadingScreen2", 1500, false, "i", playerid);
}

forward LoadingScreen2(playerid);
public LoadingScreen2(playerid)
{
	ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][2]);
    SetTimerEx("LoadingScreen3", 1500, false, "i", playerid);
}

forward LoadingScreen3(playerid);
public LoadingScreen3(playerid)
{
	ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][2]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][3]);
    SetTimerEx("LoadingScreen4", 1500, false, "i", playerid);
}

forward LoadingScreen4(playerid);
public LoadingScreen4(playerid)
{
	ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][2]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][3]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][4]);
    SetTimerEx("LoadingScreen5", 1500, false, "i", playerid);
}

forward LoadingScreen5(playerid);
public LoadingScreen5(playerid)
{
	ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][2]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][3]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][4]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][5]);
    SetTimerEx("LoadingScreen6", 1500, false, "i", playerid);
}

forward LoadingScreen6(playerid);
public LoadingScreen6(playerid)
{
	ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][2]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][3]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][4]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][6]);
    SetTimerEx("LoadingScreen7", 1500, false, "i", playerid);
}

forward LoadingScreen7(playerid);
public LoadingScreen7(playerid)
{
	ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][2]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][3]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][4]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][5]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][6]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][7]);
    SetTimerEx("LoadingScreen8", 1500, false, "i", playerid);
}

forward LoadingScreen8(playerid);
public LoadingScreen8(playerid)
{
    ClearChat(playerid);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][0]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][1]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][2]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][3]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][4]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][5]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][6]);
    PlayerTextDrawHide(playerid, LoadingScreenTD[playerid][7]);
    PlayerTextDrawShow(playerid, LoadingScreenTD[playerid][8]);

    SetTimerEx("LoadingScreen9", 1500, false, "i", playerid);
}

forward LoadingScreen9(playerid);
public LoadingScreen9(playerid)
{
	for(new i = 0; i < 9; i++)  
    {
        PlayerTextDrawHide(playerid, LoadingScreenTD[playerid][i]);
    }

	/*for(new i = 0; i < 5; i++)  
    {
        PlayerTextDrawShow(playerid, LoginTD[playerid][i]);
    }

	SelectTextDraw(playerid, 0xFFFF00FF);*/
	ShowRandomCamera(playerid);
    SetTimerEx("ShowMainMenuCamera", 100, false, "i", playerid);
}

public OnPlayerConnect(playerid)
{
    LoadingScreenTD[playerid][0] = CreatePlayerTextDraw(playerid, 38.000000, 1.000000, "_");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][0], 0.600000, 53.700004);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][0], 398.500000, -1245.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][0], 135);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][0], 0);

	LoadingScreenTD[playerid][1] = CreatePlayerTextDraw(playerid, 323.000000, 55.000000, ""SERVER_NAME"");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][1], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][1], 0.241666, 1.799998);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][1], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][1], 0);

	LoadingScreenTD[playerid][2] = CreatePlayerTextDraw(playerid, 323.000000, 71.000000, "Welcome To Eclipse City Roleplay");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][2], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][2], 0.137500, 1.149999);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][2], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][2], 0);

	LoadingScreenTD[playerid][3] = CreatePlayerTextDraw(playerid, 323.000000, 186.000000, "Loading Game (Complete)");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][3], 0.137500, 1.149999);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][3], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][3], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][3], 0);

	LoadingScreenTD[playerid][4] = CreatePlayerTextDraw(playerid, 323.000000, 196.000000, "Loading Maps (Complete)");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][4], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][4], 0.137500, 1.149999);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][4], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][4], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][4], 0);

	LoadingScreenTD[playerid][5] = CreatePlayerTextDraw(playerid, 323.000000, 206.000000, "Loading Server Plugins (Complete)");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][5], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][5], 0.137500, 1.149999);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][5], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][5], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][5], 0);

	LoadingScreenTD[playerid][6] = CreatePlayerTextDraw(playerid, 323.000000, 216.000000, "Loading Account (Complete)");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][6], 0.137500, 1.149999);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][6], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][6], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][6], 0);

	LoadingScreenTD[playerid][7] = CreatePlayerTextDraw(playerid, 323.000000, 251.000000, "Connecting to the Database");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][7], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][7], 0.241666, 1.799998);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][7], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][7], 0);

    LoadingScreenTD[playerid][8] = CreatePlayerTextDraw(playerid, 323.000000, 251.000000, "Connected");
	PlayerTextDrawFont(playerid, LoadingScreenTD[playerid][8], 2);
	PlayerTextDrawLetterSize(playerid, LoadingScreenTD[playerid][8], 0.241666, 1.799998);
	PlayerTextDrawTextSize(playerid, LoadingScreenTD[playerid][8], 735.000000, 352.000000);
	PlayerTextDrawSetOutline(playerid, LoadingScreenTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, LoadingScreenTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, LoadingScreenTD[playerid][8], 2);
	PlayerTextDrawColor(playerid, LoadingScreenTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, LoadingScreenTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, LoadingScreenTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, LoadingScreenTD[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, LoadingScreenTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, LoadingScreenTD[playerid][8], 0);
    #if defined Loading_OnPlayerConnect
		return Loading_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Loading_OnPlayerConnect
#if defined Loading_OnPlayerConnect
	forward Loading_OnPlayerConnect(playerid);
#endif