#define COOLDOWN_TIME 5000 // in seconds
#define MAX_SPAM 3 // maximum number before ban

new lastCmdTime[MAX_PLAYERS];
new cmdSpamCount[MAX_PLAYERS];

// Forward
forward ResetSpamCounter(playerid);
public ResetSpamCounter(playerid)
{
    cmdSpamCount[playerid] = 0;
    return 1;
}