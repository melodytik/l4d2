#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>

#define PLUGIN_VERSION "1.0.0"

public Plugin:myinfo = 
{
	name = "巨型女巫",
	author = "Mandysa.",
	description = "放大女巫",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
};

public OnPluginStart()
{
    HookEvent("witch_spawn", EventWitchSpawn);
}

public Action:EventWitchSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
    new ent = GetEventInt(event, "witchid");
    SetEntPropFloat(ent , Prop_Send,"m_flModelScale", 12.0);
    return Plugin_Handled;
}