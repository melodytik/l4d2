#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>
#include <sdkhooks>
#include <colors>

#define PLUGIN_VERSION "2.0.0"

public Plugin:myinfo =
{
	name = "攻击队友吸血",
	author = "Mandysa.",
	description = "",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
} 

public OnPluginStart()
{
	HookEvent("player_hurt", PlayerHurt);
}

public OnClientPutInServer(client)
{
	if (!IsFakeClient(client)) 
	{
		PrintToChat(client,"\x03本服已安装攻击队友吸血插件 -by Mandysa");
	}
}

public Action:PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new AttackerUserId = GetEventInt(event, "attacker");
	new AttackerClient = GetClientOfUserId(AttackerUserId);
	new HurterUserId = GetEventInt(event, "userid");
	new HurterClient = GetClientOfUserId(HurterUserId);
	new Dmg_Heath = GetEventInt(event, "dmg_health");
	new PlayerHealthBefore = GetClientHealth(AttackerClient);
	new PlayerHealthAfter = Dmg_Heath + PlayerHealthBefore;
	new ClientTeam_Hurter = GetClientTeam(HurterClient);
	new ClientTeam_Attacker = GetClientTeam(AttackerClient);
	
	if (PlayerHealthAfter >= 100)
	{
		if(AttackerClient != HurterClient)
		{
			if(AttackerClient != HurterClient)
			{
				PlayerHealthAfter = 100;
				if(!IsFakeClient(HurterClient))
				{
					PrintToChat(AttackerClient, "\x05[\x03吸血\x05] \x03你的血量已达上限，无法继续吸取血量！");
				}
				return Plugin_Handled;
			}
		}
		return Plugin_Handled;
	}
	
	
	if(!IsFakeClient(AttackerClient))
	{
		if(AttackerClient != HurterClient)
		{
			if(ClientTeam_Hurter == 2)
			{
				if(ClientTeam_Attacker == 2)
				{
					PrintToChat(HurterClient, "\x05[\x03吸血\x05] \x03%N\x05 攻击了你 吸取了你 \x03%d\x05 血量", AttackerClient, Dmg_Heath);
					PrintToChat(AttackerClient, "\x05[\x03吸血\x05] 你因为攻击 \x03%N\x05 吸取了 \x01[\x03%d\x01] \x05血量", HurterClient, Dmg_Heath);
					SetEntityHealth(AttackerClient, PlayerHealthAfter);
					return Plugin_Handled;
				}
			}
		}
	}
	return Plugin_Handled;
}