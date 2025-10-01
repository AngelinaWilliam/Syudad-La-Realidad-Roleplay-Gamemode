#include <open.mp>

#define GetBit(%0,%1) ((%0 >> %1) & 1)
#pragma warning disable 239

//One check is enough
//#define CHECK_0x2
#define CHECK_0x46
//#define CHECK_0x47
//#define CHECK_0x48

#if defined CHECK_0x2
enum Flags
{
    b0x01,
    bApplyGravity,
    bDisableFriction,
    bCollidable,
    b0x10,
    bDisableMovement,
    b0x40,
    b0x80,

    bSubmergedInWater,
    bOnSolidSurface,
    bBroken,
    b0x800,
    b0x1000,
    b0x2000,
    b0x4000,
    b0x8000,

    b0x10000,
    b0x20000,
    bBulletProof,
    bFireProof,
    bCollisionProof,
    bMeeleProof,
    bInvulnerable,
    bExplosionProof,

    b0x1000000,
    bAttachedToEntity,
    b0x4000000,
    bTouchingWater,
    bEnableCollision,
    bDestroyed,
    b0x40000000,
    b0x80000000
};

new PhysFlags[MAX_PLAYERS][Flags];
#endif

public OnFilterScriptInit()
{
    print("Android check has been successfully loaded.");
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
    print(" Android check filterscript unloaded");
    print("--------------------------------------\n");
}

public OnPlayerConnect(playerid)
{
    new pName[MAX_PLAYER_NAME + 1 ];
    GetPlayerName(playerid, pName, sizeof(pName));
 
    #if defined CHECK_0x2
     for(new i = 0; i < 32; i++)
    {
        PhysFlags[playerid][Flags:i] = 0;
    }
    #endif
    
    #if defined CHECK_0x48
    SendClientCheck(playerid, 0x48, 0, 0, 2);
    #endif
    
    #if defined CHECK_0x46
    SendClientCheck(playerid, 0x46, 1598, 0, 28); // 1598 - beachball
    #endif

    #if defined CHECK_0x47
    SendClientCheck(playerid, 0x47, 1598, 0, 48); // 1598 - beachball
    #endif
    return 1;
}
// SendClientCheck example script by evgen1137
// thanks to MTA devs for structs
