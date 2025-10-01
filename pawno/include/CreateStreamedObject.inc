/*
--------------------------------------------------------------------------------
?               CreateStreamedObject - Streamer DrawDistance fix!              ?
?               Usage :                                                        ?
?				If you want to replace your CreateDynamicObject codes,         ?
?				Before including, do #define REPLACE_CreateDynamicObject.      ?
?               If you don't want it to replace then, use                      ?
?               #undef REPLACE_CreateDynamicObject                             ?
?               Credits goes to those who have told about setting the          ?
?				data via Streamer_SetFloatData.                                ?
				Lordz, for creating as an include and hooks.                   ?
--------------------------------------------------------------------------------
*/

#if defined _included_createstreamedobject
 #endinput
#endif

#define _included_createstreamedobject

#include <a_samp>
#include <streamer>

stock CreateStreamedObject(modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, vworld = -1, interiorid = -1, playerid = -1, Float:streamdistance = 300.0, Float:drawdistance = 300.0)
{
 new Object_ID = CreateDynamicObject(modelid, X, Y, Z, rX, rY, rZ, vworld, interiorid, playerid, streamdistance);
 Streamer_SetFloatData(STREAMER_TYPE_OBJECT, Object_ID, E_STREAMER_DRAW_DISTANCE, drawdistance);
 return Object_ID;
}

#if defined REPLACE_CreateDynamicObject
 #define CreateDynamicObject CreateStreamedObject
#endif