#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>

#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo = 
{
	name = "HT和Boomer模型交换",
	author = "Mandysa.",
	description = "Hunter&Boomer模型交换",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
};

public OnPluginStart()
{
	HookEvent("player_spawn", HandleEventPlayerSpawn);
}

public Action:HandleEventPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    if(client)
    {
		if(GetClientTeam(client) == 3)
		{
			new iClass = GetEntProp(client, Prop_Send, "m_zombieClass");
			
			switch(iClass)
			{
				case 2:
                SetEntityModel(client, "models/infected/hunter.mdl");
                case 3:
                SetEntityModel(client, "models/infected/boomer.mdl");
			}
		}
	}
    return Plugin_Handled;
}