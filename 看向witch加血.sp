#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0"

#define INTERVALTIME 0.03

new MaxHealth[MAXPLAYERS + 1];
new pass[MAXPLAYERS + 1];
new Handle:Min;
new Handle:Max;

public Plugin:myinfo =
{
	name = "看向witch加血",
	author = "Mandysa.",
	description = "看向witch加血",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
}

public OnPluginStart()
{
    Min	= CreateConVar("Min", "1", "偷窥Witch一次最少回血量");
    Max = CreateConVar("Max", "4", "偷窥Witch一次最大回血量");
    AutoExecConfig(true, "l4d2_PeepWitch_Rebleeding");
    CreateTimer(INTERVALTIME, Detection, 0, TIMER_REPEAT);
}

public Action:Detection(Handle:timer)
{	
	for (new client = 1; client <= MaxClients; ++client)
    {	
		if(IsClientInGame(client) && IsPlayerAlive(client)) 
        {
            new AimTar = GetClientAimTarget(client, false);
            if((AimTar != -1) && IsValidEntity(AimTar))
            {
                decl String:name[32];
                GetEntityClassname(AimTar, name, sizeof(name));
                if(StrEqual(name, "witch", true))
                {
                    if(pass[client] == 0)
                    {
                        SDKHook(client, SDKHook_GetMaxHealth, GETMAXHEALTH);
                        new health = GetClientHealth(client);
                        new rand = GetRandomInt(GetConVarInt(Min), GetConVarInt(Max));
                        if(health + rand <= MaxHealth[client])
                        {
                            SetEntityHealth(client, health + rand);
                            PrintToChat(client, "\x03你通过偷窥witch获得了\x05 %d \x03血量", rand);
                        }
                        CreateTimer(1.8, RET, client);
                        pass[client] = 1;
                    }
                }
            }
        }
    }

	return Plugin_Continue;
}

public Action:RET(Handle:timer, any:client)
{
    pass[client] = 0;
}

public Action:GETMAXHEALTH(int entity, int& maxhealth)
{
    MaxHealth[entity] = maxhealth;
}

public OnClientPutInServer(client)
{
    MaxHealth[client] = 0;
    pass[client] = 0;
}

public OnClientDisconnect(client)
{
    MaxHealth[client] = 0;
    pass[client] = 0;
}