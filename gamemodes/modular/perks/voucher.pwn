CMD:myvouchers(playerid, params[])
{
    if(PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pHospital] > 0 || PlayerInfo[playerid][pCuffed] > 0 || PlayerInfo[playerid][pTied] > 0 || PlayerInfo[playerid][pJoinedEvent] > 0 || PlayerInfo[playerid][pPaintball])
	    return SendClientMessage(playerid, COLOR_GREY, "You can't use this command at the moment.");

    ShowPlayerVoucher(playerid, playerid);
    return 1;
}

CMD:checkvoucher(playerid, params[])
{
	new targetid;
	if(PlayerInfo[playerid][pAdmin] < 3)
		return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");

	if(sscanf(params, "u", targetid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /check [playerid]");
	
	if(!IsPlayerConnected(targetid))
	    return SendClientMessage(playerid, COLOR_SYNTAX, "The player specified is disconnected.");
	
	if(!PlayerInfo[targetid][pLogged])
	    return SendClientMessage(playerid, COLOR_SYNTAX, "That player hasn't logged in yet.");
	
	ShowPlayerVoucher(targetid, targetid);
	return 1;
}

ShowPlayerVoucher(playerid, targetid)
{
    new string[1028], header[128];

    strcat(string, "Vouchers\tAmount");
    format(header, sizeof(header), "Player '%s' Vouchers | %s", GetRPName(targetid),ReturnDate());
    format(string, sizeof(string), "%s\n\
    {AFAFAF}Car Vouchers:\t{FFFFFF}%d\n\
    {AFAFAF}Rare Car Vouchers:\t{FFFFFF}%d\n\
    {AFAFAF}Restricted Car Vouchers:\t{FFFFFF}%d\n\
    {AFAFAF}7 Days BVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}7 Days SVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}7 Days GVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}7 Days PVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month BVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month SVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month GVIP Vouchers\t{FFFFFF}%d\n\
    {AFAFAF}1 Month PVIP Vouchers\t{FFFFFF}%d", string,
    PlayerInfo[targetid][pCarVoucher][0],
    PlayerInfo[targetid][pCarVoucher][1],
    PlayerInfo[targetid][pCarVoucher][2],
    PlayerInfo[targetid][pVIPVoucher][0],
    PlayerInfo[targetid][pVIPVoucher][1],
    PlayerInfo[targetid][pVIPVoucher][2],
    PlayerInfo[targetid][pVIPVoucher][3],
    PlayerInfo[targetid][pVIPVoucher][4],
    PlayerInfo[targetid][pVIPVoucher][5],
    PlayerInfo[targetid][pVIPVoucher][6],
    PlayerInfo[targetid][pVIPVoucher][7]);
    ShowPlayerDialog(playerid, DIALOG_VOUCHER, DIALOG_STYLE_TABLIST_HEADERS, header, string, "Select", "Close");
    return 1;
}

CMD:setvoucher(playerid, params[])
{
    new targetid, string[128], option[24], param[32], value;

    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "us[24]S()[32]", targetid, option, param))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /setvoucher [playerid] [option]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CarVoucher, RareCarVoucher, RestrictedCarVoucher, 7DBVIP, 7DSVIP, 7DGVIP, 7DPVIP, BVIP, SVIP, GVIP, PVIP");
		return 1;
	}
    if(!strcmp(option, "carvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [carvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][0] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "rarecarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [rarecarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][1] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx rare car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "restrictedcarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [restrictedcarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][2] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx restricted car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dbvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dbvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][0] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dsvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dsvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][1] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dgvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dgvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][2] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dpvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [7dpvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][3] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][3], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "bvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [bvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][4] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][4], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "svip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [svip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][5] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][5], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "gvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [gvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][6] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][6], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "pvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /setvoucher [playerid] [pvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][7] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][7], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month pvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    return 1;
}


CMD:removevoucher(playerid, params[])
{
    new targetid, string[128], option[24], param[32], value;

    if(PlayerInfo[playerid][pAdmin] < 6)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "You are not authorized to use this command.");
	}
	if(!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 7)
	{
	    return SendClientMessage(playerid, COLOR_SYNTAX, "This command requires you to be on admin duty. /aduty to go on duty.");
	}
	if(sscanf(params, "us[24]S()[32]", targetid, option, param))
	{
	    SendClientMessageEx(playerid, COLOR_GREY, "USAGE: /removevoucher [playerid] [option]");
		SendClientMessageEx(playerid, COLOR_GREY, "Available names: CarVoucher, RareCarVoucher, RestrictedCarVoucher, 7DBVIP, 7DSVIP, 7DGVIP, 7DPVIP, BVIP, SVIP, GVIP, PVIP");
		return 1;
	}
    if(!strcmp(option, "carvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [carvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][0] += value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "rarecarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [rarecarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][1] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx rare car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "restrictedcarvoucher", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [restrictedcarvoucher] [value]");
		}

        PlayerInfo[targetid][pCarVoucher][2] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET carvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pCarVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx restricted car voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dbvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dbvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][0] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][0], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dsvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dsvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][1] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][1], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dgvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dgvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][2] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][2], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "7dpvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [7dpvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][3] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][3], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 7 days gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "bvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [bvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][4] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][4], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month bvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "svip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [svip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][5] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][5], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month svip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "gvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [gvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][6] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][6], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month gvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    else if(!strcmp(option, "pvip", true))
	{
        if(sscanf(param, "i", value))
	    {
			return SendClientMessage(playerid, COLOR_SYNTAX, "Usage: /removevoucher [playerid] [pvip] [value]");
		}

        PlayerInfo[targetid][pVIPVoucher][7] -= value;
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[targetid][pVIPVoucher][7], PlayerInfo[targetid][pID]);
        mysql_tquery(connectionID, queryBuffer);

        format(string, sizeof(string), "You have been given %dx 1 month pvip voucher by %s", value, GetPlayerNameEx(playerid));
        SendClientMessageEx(playerid, COLOR_LIGHTBLUE, string);
	}
    return 1;
}

new const RestrictedVehicleVoucher[] = {
    431, 437, 438, 420, 416, 433, 427, 490,
    528, 407, 544, 523, 470, 596, 598, 599,
    597, 601, 428, 568, 556, 557, 471, 495, 
    548, 425, 488, 497, 563, 447, 469
};

new const RareVehicleVoucher[] = {
    536, 575, 534, 567, 535, 576, 412, 562,
    565, 411, 559, 561, 560, 506, 451, 558,
    555, 
};

new const VehicleVoucher[] = {
	602, 496, 401, 518, 527, 589, 419, 587,
    533, 526, 474, 545, 517, 410, 600, 436,
    439, 549, 491, 445, 604, 507, 585, 466,
    492, 546, 551, 516, 467, 426, 547, 405,
    580, 409, 550, 566, 540, 421, 529, 542,
    579, 400, 404, 489, 505, 479, 442, 458,
    581, 509, 481, 462, 521, 463, 510, 461,
    466, 586, 475, 402, 603, 429, 541, 415,
    480, 477
};

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_VOUCHER:
        {
            if(response) 
			{
				switch(listitem) 
				{
                    case 0:
                    {
                        SetPVarInt(playerid, "voucherdialog", 1);
                        return ShowPlayerDialog(playerid, DIALOG_CAR_VOUCHER, DIALOG_STYLE_MSGBOX, "Car Voucher System", "Are you sure you want to use your car voucher?", "Yes", "Return");
                    }
                    case 1:
                    {
                        SetPVarInt(playerid, "voucherdialog", 2);
                        return ShowPlayerDialog(playerid, DIALOG_CAR_VOUCHER, DIALOG_STYLE_MSGBOX, "Rare Car Voucher System", "Are you sure you want to use your rare car voucher?", "Yes", "Return");
                    }
                    case 2:
                    {
                        SetPVarInt(playerid, "voucherdialog", 3);
                        return ShowPlayerDialog(playerid, DIALOG_CAR_VOUCHER, DIALOG_STYLE_MSGBOX, "Restricted Car Voucher System", "Are you sure you want to use your restricted car voucher?", "Yes", "Return");
                    }
                    case 3:
                    {
                        SetPVarInt(playerid, "voucherdialog", 4);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days BVIP Voucher?", "Yes", "Return");
                    }
                    case 4:
                    {
                        SetPVarInt(playerid, "voucherdialog", 5);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days SVIP Voucher?", "Yes", "Return");
                    }
                    case 5:
                    {
                        SetPVarInt(playerid, "voucherdialog", 6);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days GVIP Voucher?", "Yes", "Return");
                    }
                    case 6:
                    {
                        SetPVarInt(playerid, "voucherdialog", 7);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 7 Days PVIP Voucher?", "Yes", "Return");
                    }
                    case 7:
                    {
                        SetPVarInt(playerid, "voucherdialog", 8);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month BVIP Voucher?", "Yes", "Return");
                    }
                    case 8:
                    {
                        SetPVarInt(playerid, "voucherdialog", 9);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month SVIP Voucher?", "Yes", "Return");
                    }
                    case 9:
                    {
                        SetPVarInt(playerid, "voucherdialog", 10);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month GVIP Voucher?", "Yes", "Return");
                    }
                    case 10:
                    {
                        SetPVarInt(playerid, "voucherdialog", 11);
                        return ShowPlayerDialog(playerid, DIALOG_NEXT_VOUCHER, DIALOG_STYLE_MSGBOX, "Voucher System", "Are you sure you want to use your 1 Month PVIP Voucher?", "Yes", "Return");
                    }
                }
            }        
        }
        case DIALOG_CAR_VOUCHER:
        {
            if(response)
            {
                if(GetPVarInt(playerid, "voucherdialog") == 1)
                {
                    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                    }
                    if(GetPlayerInterior(playerid) != 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this while being inside an interior.");
                    }
                    else
                    {
                        ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_VEH, "Car Voucher Selection", VehicleVoucher, sizeof(VehicleVoucher));
                    }
                }
                if(GetPVarInt(playerid, "voucherdialog") == 2)
                {
                    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                    }
                    if(GetPlayerInterior(playerid) != 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this while being inside an interior.");
                    }
                    else
                    {
                        ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_RARE_VEH, "Rare Car Voucher Selection", RareVehicleVoucher, sizeof(RareVehicleVoucher));
                    }
                }
                if(GetPVarInt(playerid, "voucherdialog") == 3)
                {
                    if(PlayerInfo[playerid][pInjured] > 0 || PlayerInfo[playerid][pTazedTime] > 0 || PlayerInfo[playerid][pCuffed] > 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                    }
                    if(GetPlayerInterior(playerid) != 0)
                    {
                        DeletePVar(playerid, "voucherdialog");
                        return SendClientMessage(playerid, COLOR_GREY, "You cannot use this while being inside an interior.");
                    }
                    else
                    {
                        ShowPlayerSelectionMenu(playerid, MODEL_SELECTION_RESTRICTED_VEH, "Restricted Car Voucher Selection", RestrictedVehicleVoucher, sizeof(RestrictedVehicleVoucher));
                    }
                }
            }
        }
        case DIALOG_NEXT_VOUCHER:
		{
            if(!response) ShowPlayerVoucher(playerid, playerid);
			if(response)
			{
                if(GetPVarInt(playerid, "voucherdialog") == 4) // 7 Days BVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][0]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D BVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][0]--;
                    PlayerInfo[playerid][pVIPPackage] = 1;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D BVIP voucher(s), you have %d 7D BVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][0]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Bronze VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_0 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][0], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 5) // 7 Days SVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][1]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D SVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][1]--;
                    PlayerInfo[playerid][pVIPPackage] = 2;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D SVIP voucher(s), you have %d 7D SVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][1]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Silver VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_1 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][1], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 6) // 7 Days GVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][2]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][2]--;
                    PlayerInfo[playerid][pVIPPackage] = 3;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D GVIP voucher(s), you have %d 7D GVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][2]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Gold VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_2 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][2], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 7) // 7 Days PVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][3]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7D GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][3]--;
                    PlayerInfo[playerid][pVIPPackage] = 4;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 604800;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 7D PVIP voucher(s), you have %d 7D PVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][3]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Platinum VIP will expire in 7 days.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_3 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][3], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 8) // 1 Month BVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][4]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month BVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][4]--;
                    PlayerInfo[playerid][pVIPPackage] = 1;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month BVIP voucher(s), you have %d 1 Month BVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][4]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Bronze VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_4 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][4], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 9) // 1 Month SVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][5]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month SVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][5]--;
                    PlayerInfo[playerid][pVIPPackage] = 2;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month SVIP voucher(s), you have %d 1 Month SVIP voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][5]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Silver VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_5 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][5], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 10) // 1 Month GVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][6]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][6]--;
                    PlayerInfo[playerid][pVIPPackage] = 3;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month voucher(s), you have %d 1 Month voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][6]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Gold VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_6 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][6], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
                if(GetPVarInt(playerid, "voucherdialog") == 11) // 1 Month PVIP
                {
                    if(PlayerInfo[playerid][pVIPVoucher][7]<= 0) return DeletePVar(playerid, "voucherdialog"), SendClientMessageEx(playerid, COLOR_GREY, "You don't have a 7 Month GVIP Voucher.");
                    
                    PlayerInfo[playerid][pVIPVoucher][7]--;
                    PlayerInfo[playerid][pVIPPackage] = 4;
                    PlayerInfo[playerid][pVIPTime] = gettime() + 2592000;

                    SendMessage(playerid, COLOR_YELLOW, "You have successfully used one of your 1 Month voucher(s), you have %d 1 Month voucher(s) left.", PlayerInfo[playerid][pVIPVoucher][7]);
					SendClientMessage(playerid, COLOR_GREY, "** Note: Your Platinum VIP will expire in 1 Month.");

                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vippackage = %i, viptime = %i, vipcooldown = 0 WHERE uid = %i", PlayerInfo[playerid][pVIPPackage], PlayerInfo[playerid][pVIPTime], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE users SET vipvoucher_7 = %i WHERE uid = %i", PlayerInfo[playerid][pVIPVoucher][7], PlayerInfo[playerid][pID]);
                    mysql_tquery(connectionID, queryBuffer);
                }
            }
        }
    }
    #if defined Voucher_OnDialogResponse
		return Voucher_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Voucher_OnDialogResponse
#if defined Voucher_OnDialogResponse
	forward Voucher_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif