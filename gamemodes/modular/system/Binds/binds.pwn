#define MAX_BINDS 10
#define BIND_TYPE_INVALID 0
#define BIND_TYPE_ME 1
#define BIND_TYPE_DO 2


// Mask System
new Maskara[MAX_PLAYERS];
new MaskaraID[MAX_PLAYERS] = 0;

new pBindData[MAX_PLAYERS][MAX_BINDS];

new pBindTextData[MAX_PLAYERS][MAX_BINDS][254];

OnGameModeInit3()
{
    new query[600] = "\
    CREATE TABLE IF NOT EXISTS player_binds \
    ( \
        `id` INT AUTO_INCREMENT NOT NULL, \
        `userid` INT NOT NULL, \
        `bid` INT NOT NULL, \
        `btype` INT NOT NULL DEFAULT 0, \
        `btext` VARCHAR(255) NOT NULL DEFAULT '', \
        PRIMARY KEY (id)\
    )";
    mysql_query(connectionID, query);

    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    for(new i; i < MAX_BINDS; i++)
    {
        pBindData[playerid][i] = BIND_TYPE_INVALID;
        for(new x; x < 64; x++)
        {
            pBindTextData[playerid][i][x] = 0;
        }
    }
    #if defined justenn_OnPlayerDisconnect
        return justenn_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect justenn_OnPlayerDisconnect
#if defined justenn_OnPlayerDisconnect
    forward justenn_OnPlayerDisconnect(playerid, reason);
#endif

CMD:binds(playerid, params[])
{
    new output[1024], tempStr[64];
    for(new i; i < MAX_BINDS; i++)
    {
        new bindmsg[13];
        strmid(bindmsg, pBindTextData[playerid][i], 0, 10);
        if (strlen(bindmsg) >= 10) strcat(bindmsg,"...");

        format(tempStr, sizeof(tempStr), "b%d\t%s\t%s\n", i+1, pBindData[playerid][i] == 1 ? ("/me") : pBindData[playerid][i] == 2 ? ("/do") : ("None"), isnull(bindmsg) ? ("Empty") : bindmsg);
        strcat(output, tempStr);
    }

    ShowPlayerDialog(playerid, mybinds, DIALOG_STYLE_LIST, "Bind System", output, "Select", "Cancel");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case mybinds:
        {
            if(response)
            {
                ShowBindData(playerid, listitem);
            }
        }
        case bindaction:
        {
            if(response)
            {
                new bindid = GetPVarInt(playerid, "pbindid");
                if(listitem == 0) ShowEditBindType(playerid, bindid);
                else if (listitem == 1) ShowEditBindMsg(playerid, bindid);
            }
            else callcmd::binds(playerid, "");
        }
        case bindedittype:
        {
            if(response)
            {
                new bindid = GetPVarInt(playerid, "pbindid");
                if(listitem == 0)
                {
                    pBindData[playerid][bindid] = BIND_TYPE_ME;
                    SavePlayerBindData(playerid, bindid);
                    callcmd::binds(playerid, "");
                    return 1;
                }
                else if (listitem == 1)
                {
                    pBindData[playerid][bindid] = BIND_TYPE_DO;
                    SavePlayerBindData(playerid, bindid);
                    callcmd::binds(playerid, "");
                    return 1;
                }
            }
            else callcmd::binds(playerid, "");
        }
        case bindeditmsg:
        {
            if(response)
            {
                new bindid = GetPVarInt(playerid, "pbindid");
                if(strlen(inputtext) < 8 || strlen(inputtext) > 254)
                {
                    SCM(playerid, COLOR_SYNTAX, "Bind message cant be longer than 254 characters and shorter than 8.");
                    ShowEditBindMsg(playerid, bindid);
                    return 1;
                }
                mysql_escape_string(inputtext, pBindTextData[playerid][bindid]);

                SavePlayerBindData(playerid, bindid);
                callcmd::binds(playerid, "");
                return 1;
            }
            else callcmd::binds(playerid, "");
        }
    }
    #if defined justinnn_OnDialogResponse
        return justinnn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif

#define OnDialogResponse justinnn_OnDialogResponse
#if defined justinnn_OnDialogResponse
    forward justinnn_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif


ShowBindData(playerid, bindid)
{
    new output[127];
    format(output, sizeof(output), "Edit Bind b%d", bindid+1);
    SetPVarInt(playerid, "pbindid", bindid);
    ShowPlayerDialog(playerid, bindaction, DIALOG_STYLE_LIST, output, "Edit Type\nEdit Message", "Select", "Cancel");
    return 1;
}

ShowEditBindType(playerid, bindid)
{
    new output[20];
    format(output, sizeof(output), "Edit Bind b%d", bindid+1);
    SetPVarInt(playerid, "pbindid", bindid);
    ShowPlayerDialog(playerid, bindedittype, DIALOG_STYLE_LIST, output, "/me\n/do", "Select", "Cancel");
    return 1;
}

ShowEditBindMsg(playerid, bindid)
{
    new output[128], title[20];
    format(output, sizeof(output), "/b%d\nCurrent Message: %s", bindid+1, pBindTextData[playerid][bindid]);
    format(title, sizeof(title), "Edit Bind b%d", bindid+1);
    SetPVarInt(playerid, "pbindid", bindid);
    ShowPlayerDialog(playerid, bindeditmsg, DIALOG_STYLE_INPUT, title, output, "Edit", "Cancel");
    return 1;
}

SavePlayerBindData(playerid, bindid)
{
    new query[512];
    mysql_format(connectionID, query, sizeof(query), "UPDATE `player_binds` SET `btype` = %d, `btext` = '%e' WHERE `userid` = %d AND `bid` = %d", pBindData[playerid][bindid], pBindTextData[playerid][bindid], PlayerInfo[playerid][pID], bindid);
    mysql_tquery(connectionID, query);
}

ShowPlayerBind(playerid, bindid)
{
    bindid -= 1;
    if(PlayerInfo[playerid][pJailTime] && strfind(PlayerInfo[playerid][pPrisonReason], "[OOC]", true) != -1) return SendClientMessageEx(playerid, COLOR_GREY, "OOC prisoners are restricted to only speak in /b");
    if(pBindData[playerid][bindid] == BIND_TYPE_INVALID || isnull(pBindTextData[playerid][bindid])) return SendClientMessageEx(playerid, COLOR_GREY, "No bind has been set-up on this slot. Use /binds");
    switch(pBindData[playerid][bindid])
    {
        case BIND_TYPE_ME:
        {
           if(Maskara[playerid] == 1)
           {
               if(strlen(pBindTextData[playerid][bindid]) > MAX_SPLIT_LENGTH)
               {
                   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}* Stranger_%d %.*s...", MaskaraID[playerid], MAX_SPLIT_LENGTH, pBindTextData[playerid][bindid]);
                   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} ...%s", pBindTextData[playerid][bindid][MAX_SPLIT_LENGTH]);
               }
               else
               {
                   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}* Stranger_%d %s", MaskaraID[playerid], pBindTextData[playerid][bindid]);
               }
           }
           else
           {
               if(strlen(pBindTextData[playerid][bindid]) > MAX_SPLIT_LENGTH)
               {
                   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}* %s %.*s...", GetRPName(playerid), MAX_SPLIT_LENGTH, pBindTextData[playerid][bindid]);
                   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} ...%s", pBindTextData[playerid][bindid][MAX_SPLIT_LENGTH]);
               }
               else
               {
                   SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA}* %s %s", GetRPName(playerid), pBindTextData[playerid][bindid]);
               }
           }
        }
        case BIND_TYPE_DO:
        {
            if(Maskara[playerid] == 1)
            {
                if(strlen(pBindTextData[playerid][bindid]) > MAX_SPLIT_LENGTH)
                {
                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} %.*s...", MAX_SPLIT_LENGTH, pBindTextData[playerid][bindid]);
                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} ...%s (( Stranger_%d ))", pBindTextData[playerid][bindid][MAX_SPLIT_LENGTH], MaskaraID[playerid]);
                }
                else
                {
                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} %s (( Stranger_%d ))", pBindTextData[playerid][bindid], MaskaraID[playerid]);
                }
            }
            else
            {
                if(strlen(pBindTextData[playerid][bindid]) > MAX_SPLIT_LENGTH)
                {
                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} %.*s...", MAX_SPLIT_LENGTH, pBindTextData[playerid][bindid]);
                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} ...%s (( %s ))", pBindTextData[playerid][bindid][MAX_SPLIT_LENGTH], GetRPName(playerid));
                }
                else
                {
                    SendProximityMessage(playerid, 20.0, SERVER_COLOR, "{C2A2DA} %s (( %s ))", pBindTextData[playerid][bindid], GetRPName(playerid));
                }
            }
        }
        default: return SendClientMessageEx(playerid, COLOR_GREY, "No bind has been set-up on this slot. Use /binds");
    }
    return 1;
}

CMD:b1(playerid, params[])
{
    ShowPlayerBind(playerid, 1);
    return 1;
}

CMD:b2(playerid, params[])
{
    ShowPlayerBind(playerid, 2);
    return 1;
}

CMD:b3(playerid, params[])
{
    ShowPlayerBind(playerid, 3);
    return 1;
}

CMD:b4(playerid, params[])
{
    ShowPlayerBind(playerid, 4);
    return 1;
}

CMD:b5(playerid, params[])
{
    ShowPlayerBind(playerid, 5);
    return 1;
}

CMD:b6(playerid, params[])
{
    ShowPlayerBind(playerid, 6);
    return 1;
}

CMD:b7(playerid, params[])
{
    ShowPlayerBind(playerid, 7);
    return 1;
}

CMD:b8(playerid, params[])
{
    ShowPlayerBind(playerid, 8);
    return 1;
}

CMD:b9(playerid, params[])
{
    ShowPlayerBind(playerid, 9);
    return 1;
}

CMD:b10(playerid, params[])
{
    ShowPlayerBind(playerid, 10);
    return 1;
}
