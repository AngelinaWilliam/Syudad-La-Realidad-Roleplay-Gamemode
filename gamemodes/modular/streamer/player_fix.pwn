// Animation Fix

#define _FIXES_IN_RANGE(%0,%1,%2) ((_:(%0) - (_:(%1) + cellmin)) < (_:(%2) - (_:(%1) + cellmin)))
static const FIXES_gscAnimLib[134][] =
{
	"AIRPORT",      "ATTRACTORS",   "BAR",          "BASEBALL",     "BD_FIRE",
	"BEACH",        "BENCHPRESS",   "BF_INJECTION", "BIKE_DBZ",     "BIKED",
	"BIKEH",        "BIKELEAP",     "BIKES",        "BIKEV",        "BLOWJOBZ",
	"BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
	"BUS",          "CAMERA",       "CAR",          "CAR_CHAT",     "CARRY",
	"CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
	"COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
	"DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
	"DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
	"FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
	"FLOWERS",      "FOOD",         "FREEWEIGHTS",  "GANGS",        "GFUNK",
	"GHANDS",       "GHETTO_DB",    "GOGGLES",      "GRAFFITI",     "GRAVEYARD",
	"GRENADE",      "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",
	"INT_OFFICE",   "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",
	"KNIFE",        "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",
	"MD_CHASE",     "MD_END",       "MEDIC",        "MISC",         "MTB",
	"MUSCULAR",     "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",
	"PARK",         "PAULNMAC",     "PED",          "PLAYER_DVBYS", "PLAYIDLES",
	"POLICE",       "POOL",         "POOR",         "PYTHON",       "QUAD",
	"QUAD_DBZ",     "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",
	"ROCKET",       "RUNNINGMAN",   "RUSTLER",      "RYDER",        
	"SCRATCHING",   "SEX",          "SHAMAL",       "SHOP",         "SHOTGUN",
	"SILENCED",     "SKATE",        "SMOKING",      "SNIPER",       "SNM",
	"SPRAYCAN",     "STRIP",        "SUNBATHE",     "SWAT",         "SWEET",
	"SWIM",         "SWORD",        "TANK",         "TATTOOS",      "TEC",
	"TRAIN",        "TRUCK",        "UZI",          "VAN",          "VENDING",
	"VORTEX",       "WAYFARER",     "WEAPONS",      "WOP",          "WUZI"
};

static const FIXES_gscAnimIndexes[24] =
{
	0, 2, 21, 35, 42, 42, 53, 62, 64, 67, 68, 71, 75, 81, 82, 84, 94, 96, 104, 122, 127, 128, 131, 135
};

#define _FIXES_CEILDIV(%0,%1) (((%0) + (%1) - 1) / (%1))
#define _FIXES_NO_RANGE(%0,%1,%2) (((%0) - ((%1) + cellmin)) >= ((%2) - ((%1) + cellmin)))

static 
	FIXES_gsActorAnimLibs[MAX_ACTORS][_FIXES_CEILDIV(135, cellbits)],
	FIXES_gsActorAnimName[MAX_ACTORS][60],
	actor_animation_Timer[MAX_ACTORS],

	FIXES_gsPlayerAnimLibs[MAX_PLAYERS][_FIXES_CEILDIV(135, cellbits)],
	FIXES_gsPlayerAnimName[MAX_PLAYERS][60],
	animation_Timer[MAX_PLAYERS]
;

public OnPlayerConnect(playerid)
{
	static
		name[MAX_PLAYER_NAME]
	;
	
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	
	if (strcmp(name, "FIXES_TEMP_NAME") == 0)
	{
		Kick(playerid);
	}

	FIXES_gsPlayerAnimLibs[playerid][0] =
	FIXES_gsPlayerAnimLibs[playerid][1] =
	FIXES_gsPlayerAnimLibs[playerid][2] =
	FIXES_gsPlayerAnimLibs[playerid][3] =
	FIXES_gsPlayerAnimLibs[playerid][4] = -1;

	KillTimer(animation_Timer[playerid]),
	animation_Timer[playerid] = 0;
	
	#if defined FIXES_OnPlayerConnect
		return FIXES_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif	
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect FIXES_OnPlayerConnect
#if defined FIXES_OnPlayerConnect
	forward FIXES_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
	if (animation_Timer[playerid])
	{
		KillTimer(animation_Timer[playerid]),
		animation_Timer[playerid] = 0;
	}
	#if defined FIXES_OnPlayerDisconnect
		return FIXES_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif	
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect FIXES_OnPlayerDisconnect
#if defined FIXES_OnPlayerDisconnect
	forward FIXES_OnPlayerDisconnect(playerid, reason);
#endif

stock FIXES_CreateActor(modelid, Float:X, Float:Y, Float:Z, Float:Rotation)
{
	new actorid;

	actorid = CreateActor(modelid, X, Y, Z, Rotation);

	if (actorid == INVALID_ACTOR_ID)
	{
		return INVALID_ACTOR_ID;
	}

	FIXES_gsActorAnimLibs[actorid][0] =
	FIXES_gsActorAnimLibs[actorid][1] =
	FIXES_gsActorAnimLibs[actorid][2] =
	FIXES_gsActorAnimLibs[actorid][3] =
	FIXES_gsActorAnimLibs[actorid][4] = -1;
	return actorid;
}

stock FIXES_DestroyActor(actorid)
{
	if (actor_animation_Timer[actorid])
	{
		KillTimer(actor_animation_Timer[actorid]),
		actor_animation_Timer[actorid] = 0;
	}

	return DestroyActor(actorid);
}

stock FIXES_ApplyActorAnimation(actorid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time)
{
	new index = _FIXES_GetAnimLibIndex(animlib);
	if(index != -1)
	{
		FIXES_ApplyActorAnimationDelay(animname, actorid, index, fDelta, loop, lockx, locky, freeze, time);
		return ApplyActorAnimation(actorid, animlib, animname, fDelta, loop, lockx, locky, freeze, time);
	}
	return 0;
}

static stock FIXES_ApplyActorAnimationDelay(animname[], actorid, index, Float:fDelta, loop, lockx, locky, freeze, time)
{
	if (actor_animation_Timer[actorid])
	{
		KillTimer(actor_animation_Timer[actorid]),
		actor_animation_Timer[actorid] = 0;
	}
	
	FIXES_gsActorAnimLibs[actorid][index >>> 5] &= ~(1 << (index & 0x1F));
	FIXES_gsActorAnimName[actorid][0] = '\0';
	strcat(FIXES_gsActorAnimName[actorid], animname);
	
	animation_Timer[actorid] = SetTimerEx("ApplyActorAnimationDelay", 350, false, "ddfddddd", actorid, index, fDelta, loop, lockx, locky, freeze, time);
}

forward ApplyActorAnimationDelay(actorid, index, Float:fDelta, loop, lockx, locky, freeze, time);
public ApplyActorAnimationDelay(actorid, index, Float:fDelta, loop, lockx, locky, freeze, time)
{
	ApplyActorAnimation(actorid, FIXES_gscAnimLib[index], FIXES_gsActorAnimName[actorid], fDelta, loop, lockx, locky, freeze, time);
	actor_animation_Timer[actorid] = 0;
}

stock FIXES_ApplyAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	new index = _FIXES_GetAnimLibIndex(animlib);
	if(index != -1)
	{
		FIXES_ApplyAnimationDelay(animname, playerid, index, fDelta, loop, lockx, locky, freeze, time, forcesync);
		return ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	}
	return 0;
}

static stock FIXES_ApplyAnimationDelay(animname[], playerid, index, Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	if (animation_Timer[playerid])
	{
		KillTimer(animation_Timer[playerid]),
		animation_Timer[playerid] = 0;
	}
	
	FIXES_gsPlayerAnimLibs[playerid][index >>> 5] &= ~(1 << (index & 0x1F));
	FIXES_gsPlayerAnimName[playerid][0] = '\0';
	strcat(FIXES_gsPlayerAnimName[playerid], animname);
	
	animation_Timer[playerid] = SetTimerEx("ApplyAnimationDelay", 350, false, "ddfdddddd", playerid, index, fDelta, loop, lockx, locky, freeze, time, forcesync);
}

forward ApplyAnimationDelay(playerid, index, Float:fDelta, loop, lockx, locky, freeze, time, forcesync);
public ApplyAnimationDelay(playerid, index, Float:fDelta, loop, lockx, locky, freeze, time, forcesync)
{
	ApplyAnimation(playerid, FIXES_gscAnimLib[index], FIXES_gsPlayerAnimName[playerid], fDelta, loop, lockx, locky, freeze, time, forcesync);
	animation_Timer[playerid] = 0;
}

static stock _FIXES_GetAnimLibIndex(animlib[])
{
	new
		diff,
		idx = animlib[0] & ~0x20;
	// Uses a sort of optimised binary search.  The code first identifies the area in the array
	// in which libraries with this first letter are, then does a binary search using only that
	// subset of the array.  This used to use an N-ary search that just went linearly through
	// the identified subset of the array, and that was 5x faster than a simple linear loop over
	// the whole array.  This new version is 50% faster than even that was.  "E" has no
	// libraries, but we don't check for that explicitly as it would slow down the more common
	// code path - and it ends fairly quickly anyway as "upper == lower".
	if (_FIXES_IN_RANGE(idx, 'A', 'W' + 1))
	{
		new
			upper = FIXES_gscAnimIndexes[idx - ('A' - 1)],
			lower = FIXES_gscAnimIndexes[idx - 'A'];
		while (upper != lower)
		{
			idx = (upper - lower) / 2 + lower;
			if ((diff = strcmp(FIXES_gscAnimLib[idx], animlib, true)))
			{
				if (diff > 0) upper = idx;
				else lower = idx + 1;
			}
			else
			{
				return idx;
			}
		}
	}

	return -1;
}

stock FIXES_SetPlayerName(playerid, const name[])
{
	static
		sOldName[MAX_PLAYER_NAME]
	;
	
	GetPlayerName(playerid, sOldName, sizeof (sOldName));
	if (!strcmp(name, sOldName, true))
	{
		if (strcmp(name, sOldName, false))
		{
			SetPlayerName(playerid, "FIXES_TEMP_NAME");
			if (SetPlayerName(playerid, name) == -1)
			{
				SetPlayerName(playerid, sOldName);
				return -1;
			}
			return 1;
		}
		else
		{
			return 0;
		}
	}
	return SetPlayerName(playerid, name);
}

#if defined _ALS_ApplyActorAnimation
	#undef ApplyActorAnimation
#else
	#define _ALS_ApplyActorAnimation
#endif
#define ApplyActorAnimation FIXES_ApplyActorAnimation

#if defined _ALS_CreateActor
	#undef CreateActor
#else
	#define _ALS_CreateActor
#endif
#define CreateActor FIXES_CreateActor

#if defined _ALS_DestroyActor
	#undef DestroyActor
#else
	#define _ALS_DestroyActor
#endif
#define DestroyActor FIXES_DestroyActor

#if defined _ALS_ApplyAnimation
	#undef ApplyAnimation
#else
	#define _ALS_ApplyAnimation
#endif
#define ApplyAnimation FIXES_ApplyAnimation

#if defined _ALS_SetPlayerName
	#undef SetPlayerName
#else
	#define _ALS_SetPlayerName
#endif
#define SetPlayerName FIXES_SetPlayerName