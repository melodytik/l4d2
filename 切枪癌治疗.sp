#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0"

#define TIME 0.03

new cisu[MAXPLAYERS + 1];
new String:LastWeaponName[32][MAXPLAYERS + 1];
new Handle:upper_limit;
new Handle:HMTime;
new Handle:Penalty_Blood;

public Plugin:myinfo =
{
	name = "切枪癌治疗",
	author = "Mandysa.",
	description = "切枪癌治疗",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
}

public OnPluginStart()
{
    upper_limit	= CreateConVar("upper_limit", "10", "固定时间内最多允许切多少次枪 超过就进行惩罚");
    HMTime = CreateConVar("HMTime", "6.0", "多少时间清空次数统计");
    Penalty_Blood = CreateConVar("Penalty_Blood", "20", "惩罚血量");
    AutoExecConfig(true, "l4d2_CuttingGunDetection");
    CreateTimer(TIME, Detection, 0, TIMER_REPEAT);
    CreateTimer(GetConVarFloat(HMTime), re, 0, TIMER_REPEAT);
}

public Action:re(Handle:timer)
{
    for(new client = 1; client <= MaxClients; client++)
    {
        if(IsClientInGame(client) && IsPlayerAlive(client))
        {
            cisu[client] = 0;
        }
    }
    return Plugin_Continue;
}

public Action:Detection(Handle:timer)
{	
	for(new client = 1; client <= MaxClients; client++)
    {	
		if(IsClientInGame(client) && IsPlayerAlive(client)) 
        {
            decl String:WeaponName[32];
            GetClientWeapon(client, WeaponName, sizeof(WeaponName));
            if(!StrEqual(WeaponName, LastWeaponName[client], true))
            {
                cisu[client]++;
            }
            LastWeaponName[client] = WeaponName;
            if(cisu[client] > GetConVarInt(upper_limit))
            {
                new health = GetClientHealth(client);
                health -= GetConVarInt(Penalty_Blood);
                SetEntityHealth(client, health);
                if(health <= 0)
                {
                    ForcePlayerSuicide(client);
                }
                cisu[client] = 0;
                PrintToChat(client, "\x01请不要频繁切枪 \x05HP-\x03%d", GetConVarInt(Penalty_Blood));
            }
        }
    }
	return Plugin_Continue;
}