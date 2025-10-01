
new EmoteDamage[MAX_PLAYERS];
/*GetPlayerDamageEmote(playerid)
{
    EmoteDamage[playerid] = 1;
    if(EmoteDamage[playerid])
	{
		SetPlayerAttachedObject(playerid, 4, 1240, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
		SetTimerEx("EmoteSystem", 5000, false, "i", playerid);
	}
}*/

forward EmoteSystem(playerid);
public EmoteSystem(playerid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid, 4);
}

CMD:emote(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_EMOTE, DIALOG_STYLE_LIST, "Emote", "Heart\nAlert\nDrugs\nDollar\nGangsta Sign\nCJ", "Select", "Back");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_EMOTE:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1240, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                    case 1:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1239, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                    case 2:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1575, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);
                    }
                    case 3:
                    {
                        SetPlayerAttachedObject(playerid, 4, 1274, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);         
                    }   
                    case 4:
                    {    
                        SetPlayerAttachedObject(playerid, 4, 1313, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1); 
                    }
                    case 5:
                    {
                        SetPlayerAttachedObject(playerid, 4, 18963, 2, 0.468, 0, 0, 0, 89.3, 0, 1, 1, 1);  
                    }
                }
            }
            SetTimerEx("EmoteSystem", 5000, false, "i", playerid);
        }
    }
    #if defined Emote_OnDialogResponse
		return Emote_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Emote_OnDialogResponse
#if defined Emote_OnDialogResponse
	forward Emote_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif