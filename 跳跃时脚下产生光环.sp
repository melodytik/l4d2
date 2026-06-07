#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>

#define DEFAULT_FLAGS FCVAR_PLUGIN|FCVAR_NOTIFY
#define PLUGIN_VERSION "1.0.0"

new g_Sprite;
new T_colors[4];

public Plugin:myinfo = 
{
	name = "跳跃时脚下产生光环",
	author = "Mandysa.",
	description = "跳跃时脚下产生光环",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
};

public OnPluginStart()
{
    HookEvent("player_jump", Player_Jump);
}

public OnMapStart()
{
	g_Sprite = PrecacheModel("materials/sprites/laserbeam.vmt");
}

public Action:Player_Jump(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    if(client)
    {
        if(!IsFakeClient(client))
        {
            decl Float:ORI[3];
            GetClientAbsOrigin(client, ORI);
            T_colors[0] = GetRandomInt(0, 255);
            T_colors[1] = GetRandomInt(0, 255);
            T_colors[2] = GetRandomInt(0, 255);
            T_colors[3] = 100;
            TE_SetupBeamRingPoint(ORI, 15.0, 70.0, g_Sprite, 0, 0, 0, 1.5, 2.1, 4.0, T_colors, 0, 0);
            TE_SendToAll();
        }
    }
    return Plugin_Continue;
}