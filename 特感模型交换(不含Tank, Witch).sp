#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>

#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo = 
{
	name = "特感模型交换",
	author = "Mandysa.",
	description = "特感模型交换",
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
				case 1:
				SetEntityModel(client, "models/infected/jockey.mdl");
				case 2:
				SetEntityModel(client, "models/infected/hunter.mdl");
				case 3:
				SetEntityModel(client, "models/infected/boomer.mdl");
				case 4:
				SetEntityModel(client, "models/infected/charger.mdl");
				case 5:
				SetEntityModel(client, "models/infected/smoker.mdl");
				case 6:
				SetEntityModel(client, "models/infected/spitter.mdl");
			}
		}
	}
    return Plugin_Handled;
}