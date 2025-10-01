// Actor System 

#define MAX_DYNAMIC_ACTORS (100)
enum actEnum
{
    actor_ID,
    Text3D:actor_Label,
    actorID,
    actorExists,
    actorName[24],
    actorSkin,
    actorAnim,
    Float:actorX,
    Float:actorY,
    Float:actorZ,
    Float:actorA,
    actorVW
};
new ActorInfo[MAX_DYNAMIC_ACTORS][actEnum];

// mysql 

forward OnAdminCreateActor(playerid, actorid, name[], skin, Float:x, Float:y, Float:z, Float:angle, world);
public OnAdminCreateActor(playerid, actorid, name[], skin, Float:x, Float:y, Float:z, Float:angle, world)
{
    strcpy(ActorInfo[actorid][actorName], name, MAX_PLAYER_NAME);
    ActorInfo[actorid][actorID] = cache_insert_id(connectionID);
    ActorInfo[actorid][actorSkin] = skin;
    ActorInfo[actorid][actorX] = x;
    ActorInfo[actorid][actorY] = y;
    ActorInfo[actorid][actorZ] = z;
    ActorInfo[actorid][actorA] = angle;
    ActorInfo[actorid][actorVW] = world;
    ActorInfo[actorid][actorExists] = 1;
    ActorInfo[actorid][actorAnim] = 1; //default
   
    ReloadActor(actorid);
    SCMf(playerid, COLOR_NEWBIE, "** Actor %i created successfully.", actorid);
}


// commands 

CMD:createactor(playerid, params[])
{
    new name[24], world = GetPlayerVirtualWorld(playerid), skin, Float:x, Float:y, Float:z, Float:a;

    if(PlayerInfo[playerid][pAdmin] < 6)
        return SCM(playerid, COLOR_TWEET, "Error:"WHITE" You are not authorized to use this command.");

    if(sscanf(params, "s[24]d", name, skin))
        return SCM(playerid, COLOR_GREY, "USAGE:"WHITE" /createactor [name] [skin]");

    if(skin < 0 || skin == 74 || skin > 311)
        return SCM(playerid, COLOR_TWEET, "Invalid SkinID.");

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    for(new i = 0; i < MAX_DYNAMIC_ACTORS; i ++)
    {
        if(!ActorInfo[i][actorExists])
        {
            mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "INSERT INTO actors (name, skin, anim, x, y, z, a, world) VALUES('%e', %d, 1, %f, %f, %f, %f, %d)", name, skin, x, y, z, a, world);
            mysql_tquery(connectionID, queryBuffer, "OnAdminCreateActor", "iisiffffi", playerid, i, name, skin, x, y, z, a, world);
            return 1;
        }
    }

    SCM(playerid, COLOR_TWEET, "Error:"WHITE" Actor slots are currently full. Ask developers to increase the internal limit.");
    return 1;
}

CMD:gotoactor(playerid, params[])
{
    new actorid;

    if(PlayerInfo[playerid][pAdmin] < 6)
    {
        return SendClientMessage(playerid, COLOR_GREY, "You are not authorized to use this command.");
    }

    if(sscanf(params, "i", actorid))
    {
        return SendClientMessage(playerid, COLOR_SYNTAX, "USAGE: /gotoactor [actorid]");
    }
    if(!(0 <= actorid < MAX_DYNAMIC_ACTORS) || !ActorInfo[actorid][actorExists])
    {
        return SendClientMessage(playerid, COLOR_GREY, "Invalid actor.");
    }

    GameTextForPlayer(playerid, "~w~Teleported", 5000, 1);

    SetPlayerPos(playerid, ActorInfo[actorid][actorX], ActorInfo[actorid][actorY], ActorInfo[actorid][actorZ]);
    SetPlayerVirtualWorld(playerid, ActorInfo[actorid][actorVW]);
    SetCameraBehindPlayer(playerid);

    return 1;
}

CMD:editactor(playerid, params[])
{
    new actorid, option[14], param[32];

    if(PlayerInfo[playerid][pAdmin] < 6)
        return SCM(playerid, COLOR_TWEET, "Error:"WHITE" You are not authorized to use this command.");

    if(sscanf(params, "is[14]S()[32]", actorid, option, param))
    {
        SCM(playerid, COLOR_GREY, "USAGE:"WHITE" /editactor [actorid] [option]");
        SCM(playerid, COLOR_GREY2, "List of options: Name");
        return 1;
    }
    if(!(0 <= actorid < MAX_DYNAMIC_ACTORS) || !ActorInfo[actorid][actorExists])
        return SCM(playerid, COLOR_TWEET, "Error:"WHITE" Invalid actor.");

    if(!strcmp(option, "name", true))
    {
        new name[24];

        if(sscanf(param, "s[24]", name))
            return SCM(playerid, COLOR_GREY, "USAGE:"WHITE" /editactor [actorid] [name] [name of actor]");

        strcpy(ActorInfo[actorid][actorName], name, 24);

        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE actors SET name = '%e' WHERE id = %i", ActorInfo[actorid][actorName], ActorInfo[actorid][actorID]);
        mysql_tquery(connectionID, queryBuffer);

        ReloadActor(actorid);
        SCMf(playerid, SERVER_COLOR, "** You've changed the name of Actor %i to %s.", actorid, name);
    }
    if(!strcmp(option, "anim", true))
    {
        new id;
        if(sscanf(param, "d", id)) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /editactor [actorid] [anim 1-3]");
        if(id > 3 || id < 1) return SendClientMessage(playerid, COLOR_WHITE, "Invalid value");
        switch(id) {
            case 1: ActorInfo[actorid][actorAnim] = 1;
            case 2: ActorInfo[actorid][actorAnim] = 2;
            case 3: ActorInfo[actorid][actorAnim] = 3;
        }
        mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "UPDATE actors SET anim = %i WHERE id = %i", ActorInfo[actorid][actorAnim], ActorInfo[actorid][actorID]);
        mysql_tquery(connectionID, queryBuffer);

        ReloadActor(actorid);
        SCMf(playerid, SERVER_COLOR, "** You've changed the animation of Actor %i to %d.", actorid, id);
    }
    return 1;
}

CMD:removeactor(playerid, params[])
{
    new actorid;

    if(PlayerInfo[playerid][pAdmin] < 6)
        return SCM(playerid, COLOR_GREY, "Error:"WHITE" You are not authorized to use this command.");

    if(sscanf(params, "i", actorid))
        return SCM(playerid, COLOR_GREY, "USAGE:"WHITE" /removeactor [actorid]");

    if(!(0 <= actorid < MAX_DYNAMIC_ACTORS) || !ActorInfo[actorid][actorExists])
        return SCM(playerid, COLOR_GREY, "Error:"WHITE" Invalid actor.");

    DestroyDynamic3DTextLabel(ActorInfo[actorid][actor_Label]);
    DestroyActor(ActorInfo[actorid][actor_ID]);

    if(IsValidActor(ActorInfo[actorid][actor_ID])) {
        DestroyActor(ActorInfo[actorid][actor_ID]);
    }

    mysql_format(connectionID, queryBuffer, sizeof(queryBuffer), "DELETE FROM actors WHERE id = %i", ActorInfo[actorid][actorID]);
    mysql_tquery(connectionID, queryBuffer);

    ActorInfo[actorid][actorExists] = 0;
    ActorInfo[actorid][actorID] = 0;

    SCMf(playerid, SERVER_COLOR, "** You have removed actor %i.", actorid);
    return 1;
}

// functions
ReloadActor(actorid)
{
    if(ActorInfo[actorid][actorExists])
    {
        new string[128], name[24];
    
        strcpy(name, ActorInfo[actorid][actorName], 24);
        
        for(new i = 0, l = strlen(name); i < l; i ++)
        {
            if(name[i] == '_')
            {
                name[i] = ' ';
            }
        }       

        ActorInfo[actorid][actor_ID] = CreateActor(ActorInfo[actorid][actorSkin], ActorInfo[actorid][actorX], ActorInfo[actorid][actorY], ActorInfo[actorid][actorZ], ActorInfo[actorid][actorA]);
        if(ActorInfo[actorid][actorAnim] == 1) ApplyActorAnimation(ActorInfo[actorid][actor_ID], "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
        else if(ActorInfo[actorid][actorAnim] == 2) ApplyActorAnimation(ActorInfo[actorid][actor_ID], "ON_LOOKERS", "wave_loop",  4.1, 1, 1, 1, 1, 1);
        else if(ActorInfo[actorid][actorAnim] == 3) ApplyActorAnimation(ActorInfo[actorid][actor_ID], "PED", "endchat_03", 4.1, 1, 1, 1, 1, 1);

        DestroyDynamic3DTextLabel(ActorInfo[actorid][actor_Label]);
        format(string, sizeof(string), "%s (%d)", name, actorid);
        ActorInfo[actorid][actor_Label] = CreateDynamic3DTextLabel(string, COLOR_WHITE, ActorInfo[actorid][actorX], ActorInfo[actorid][actorY], ActorInfo[actorid][actorZ] + 1, 25.0);

        SetActorVirtualWorld(ActorInfo[actorid][actor_ID], ActorInfo[actorid][actorVW]);
    }
}
