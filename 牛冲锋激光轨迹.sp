#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>

#define PLUGIN_VERSION "1.0.0"

new g_Sprite;
new Handle:timera[MAXPLAYERS + 1];
new Float:PosBefore[MAXPLAYERS + 1][3];
new Float:PosAfter[MAXPLAYERS + 1][3];
new pass[MAXPLAYERS + 1];
new g_LaserColor[4];

public Plugin:myinfo = 
{
	name = "牛冲锋激光轨迹",
	author = "Mandysa.",
	description = "牛冲锋激光轨迹",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
};

public OnPluginStart()
{
    HookEvent("charger_charge_start", kaichong);
    HookEvent("charger_charge_end", buchong);
    g_LaserColor[3] = 200;
}

public OnMapStart()
{
    g_Sprite = PrecacheModel("materials/sprites/laserbeam.vmt");		
}

public Action:kaichong(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    {
        timera[client] = CreateTimer(0.072, isKaiChong, client, TIMER_REPEAT);
    }
}

public Action:isKaiChong(Handle:timer, client)
{
    if(pass[client] == 0)
    {
        GetClientAbsOrigin(client, PosBefore[client]);
        pass[client] = 1;
    }
    else if(pass[client] == 1)
    {
        GetClientAbsOrigin(client, PosAfter[client]);
        pass[client] = 0;
    }
    if(PosBefore[client][0] == 0.0 && PosBefore[client][1] == 0.0 && PosBefore[client][2] == 0.0 ||
    PosAfter[client][0] == 0.0 && PosAfter[client][1] == 0.0 && PosAfter[client][2] == 0.0)
    {
        return;
    }
    g_LaserColor[0] = GetRandomInt(0, 255);
    g_LaserColor[1] = GetRandomInt(0, 255);
    g_LaserColor[2] = GetRandomInt(0, 255);
    TE_SetupBeamPoints(PosBefore[client], PosAfter[client], g_Sprite, 0, 0, 0, 8.0, 25.0, 25.0, 8, 0.0, g_LaserColor, 0);
    TE_SendToAll();
}

public Action:buchong(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    KillTimer(timera[client]);
    PosBefore[client][0] = 0.0;
    PosBefore[client][1] = 0.0;
    PosBefore[client][2] = 0.0;
    PosAfter[client][0] = 0.0;
    PosAfter[client][1] = 0.0;
    PosAfter[client][2] = 0.0;
}