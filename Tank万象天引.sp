#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>

#define PLUGIN_VERSION "1.0"

new DeadTank[512];
new PlayerClient[MAXPLAYERS + 1];
new T_colors[4];
new X_colors[4];
new g_Sprite;

public Plugin:myinfo = 
{
	name = "Tank万象天引",
	author = "Mandysa.",
	description = "Tank万象天引",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
};

public OnPluginStart()
{
    HookEvent("player_spawn", EventPlayerSpawn);
    HookEvent("mission_lost", EventMissionLost);
    HookEvent("player_death", EventPlayerDeath);

    HookEvent("tank_spawn", EventTankSpawn);
    HookEvent("tank_killed", EventTankDead);
    T_colors[0] = 150;
    T_colors[1] = 0;
    T_colors[2] = 0;
    T_colors[3] = 15;

    X_colors[0] = 175;
    X_colors[1] = 0;
    X_colors[2] = 0;
    X_colors[3] = 5;
}

public OnMapStart()
{
    g_Sprite = PrecacheModel("materials/sprites/laserbeam.vmt");

    for(new i = 0; i <= MAXPLAYERS; i++)
    {
        PlayerClient[i] = 0;
        continue;
    }
}

public Action:EventPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    for(new i = 0; i <= MAXPLAYERS; i++)
    {
        if(PlayerClient[i] == 0)
        {
            PlayerClient[i] = client;
        }
        else
        {
            continue;
        }
    }

    return;
}

public Action:EventPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    
    for(new i = 0; i <= MAXPLAYERS; i++)
    {
        if(PlayerClient[i] == client)
        {
            PlayerClient[i] = 0;
        }
        else
        {
            continue;
        }
    }

    return;
}

public Action:EventMissionLost(Handle:event, const String:name[], bool:dontBroadcast)
{
    for(new i = 0; i <= MAXPLAYERS; i++)
    {
        PlayerClient[i] = 0;
        continue;
    }

    return;
}

public Action:EventTankSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    if(client)
    {
        CreateTimer(0.01, SXGH, client);

        PrintToChatAll("\x05Tank将在10秒后使用万象天引，请及时躲避");
        CreateTimer(10.0, WXTY, client);
    }

    return Plugin_Continue;
}

public Action:WXTY(Handle timer, client)
{
    if(DeadTank[client] == 0)
    {
        decl Float:ORI[3];

        GetClientAbsOrigin(client, ORI);
        TE_SetupBeamRingPoint(ORI, 1000.0, 2000.0, g_Sprite, 0, 0, 0, 0.9, 15.0, 10.0, X_colors, 0, 0);
        TE_SendToAll();

        for(new i = 0; i <= MAXPLAYERS; i++)
        {
            if(IsValidPlayer(PlayerClient[i]))
            {
                decl Float:playerORI[3];
                GetClientAbsOrigin(PlayerClient[i], playerORI);
                new Float:ABSORI[2];
                ABSORI[0] = FloatAbs(ORI[0]);
                ABSORI[1] = FloatAbs(ORI[1]);

                new Float:ABSPLAYERORI[2];
                ABSPLAYERORI[0] = FloatAbs(playerORI[0]);
                ABSPLAYERORI[1] = FloatAbs(playerORI[1]);

                new Float:JGa;
                new Float:JGb;

                if(FloatCompare(ABSORI[0], ABSPLAYERORI[0]) == 1)//参数1大
                {
                    JGa = ABSORI[0] - ABSPLAYERORI[0];
                }
                else if(FloatCompare(ABSORI[0], ABSPLAYERORI[0]) == -1)//参数2大
                {
                    JGb = ABSPLAYERORI[0] - ABSORI[0];
                }

                if(JGa <= 2000 && JGb <= 2000)
                {
                    TeleportEntity(PlayerClient[i], ORI, NULL_VECTOR , NULL_VECTOR);
                }
                else
                {
                    continue;
                }
            }
            continue;
        }

        CreateTimer(20.0, TS, client);
        CreateTimer(30.0, WXTY1, client);
    }
}

public Action:WXTY1(Handle timer, client)
{
    if(DeadTank[client] == 0)
    {
        decl Float:ORI[3];

        GetClientAbsOrigin(client, ORI);
        TE_SetupBeamRingPoint(ORI, 1000.0, 2000.0, g_Sprite, 0, 0, 0, 0.9, 15.0, 10.0, X_colors, 0, 0);
        TE_SendToAll();

        for(new i = 0; i <= MAXPLAYERS; i++)
        {
            if(IsValidPlayer(PlayerClient[i]))
            {
                decl Float:playerORI[3];
                GetClientAbsOrigin(PlayerClient[i], playerORI);
                new Float:ABSORI[2];
                ABSORI[0] = FloatAbs(ORI[0]);
                ABSORI[1] = FloatAbs(ORI[1]);

                new Float:ABSPLAYERORI[2];
                ABSPLAYERORI[0] = FloatAbs(playerORI[0]);
                ABSPLAYERORI[1] = FloatAbs(playerORI[1]);

                new Float:JGa;
                new Float:JGb;

                if(FloatCompare(ABSORI[0], ABSPLAYERORI[0]) == 1)//参数1大
                {
                    JGa = ABSORI[0] - ABSPLAYERORI[0];
                }
                else if(FloatCompare(ABSORI[0], ABSPLAYERORI[0]) == -1)//参数2大
                {
                    JGb = ABSPLAYERORI[0] - ABSORI[0];
                }

                if(JGa <= 2000 && JGb <= 2000)
                {
                    TeleportEntity(PlayerClient[i], ORI, NULL_VECTOR , NULL_VECTOR);
                }
                else
                {
                    continue;
                }
            }
            continue;
        }

        CreateTimer(20.0, TS, client);
        CreateTimer(30.0, WXTY, client);
    }
}

public Action:TS(Handle timer, client)
{
    if(!IsClientInGame(client))
    {
        return;
    }
    
    if(DeadTank[client] == 0)
    {
        PrintToChatAll("\x05Tank将在10秒后使用万象天引，请及时躲避");
    }

    return;
}

public Action:SXGH(Handle timer, client)
{
    if(DeadTank[client] == 0)
    {
        decl Float:ORI[3];

        GetClientAbsOrigin(client, ORI);
        TE_SetupBeamRingPoint(ORI, 1000.0, 2000.0, g_Sprite, 0, 0, 0, 0.9, 15.0, 10.0, T_colors, 0, 0);
        TE_SendToAll();

        CreateTimer(0.7, SXGH1, client);
    }
    else
    {
        DeadTank[client] = 0;
        return;
    }
}

public Action:SXGH1(Handle timer, client)
{
    if(DeadTank[client] == 0)
    {
        decl Float:ORI[3];

        GetClientAbsOrigin(client, ORI);
        TE_SetupBeamRingPoint(ORI, 1000.0, 2000.0, g_Sprite, 0, 0, 0, 0.9, 15.0, 10.0, T_colors, 0, 0);
        TE_SendToAll();

        CreateTimer(0.7, SXGH, client);
    }
    else
    {
        DeadTank[client] = 0;
        return;
    }
}

public Action:EventTankDead(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));

    DeadTank[client] = 1;
    return;
}

stock bool:IsValidPlayer(Client, bool:AllowBot = true, bool:AllowDeath = false)
{
	if (Client < 1 || Client > MaxClients)
		return false;
	if (!IsClientConnected(Client) || !IsClientInGame(Client))
		return false;
	if (!AllowBot)
	{
		if (IsFakeClient(Client))
			return false;
	}

	if (!AllowDeath)
	{
		if (!IsPlayerAlive(Client))
			return false;
	}	
	
	return true;
}