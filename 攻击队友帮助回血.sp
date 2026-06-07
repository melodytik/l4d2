#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>
#include <sdkhooks>
#include <colors>

#define PLUGIN_VERSION "2.5.0"

const huixuebeishu = 2;

public Plugin:myinfo =
{
	name = "攻击队友帮助回血",
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
		PrintToChat(client,"\x03本服已安装攻击队友回复血量插件 -by Mandysa");
	}
}

public Action:PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new AttackerUserId = GetEventInt(event, "attacker");
	new AttackerClient = GetClientOfUserId(AttackerUserId);
	new HurterUserId = GetEventInt(event, "userid");
	new HurterClient = GetClientOfUserId(HurterUserId);
	new Dmg_Heath = GetEventInt(event, "dmg_health");
	new PlayerHealthBefore = GetClientHealth(HurterClient);
	new PlayerHealthAfter = Dmg_Heath * huixuebeishu + PlayerHealthBefore;
	new ClientTeam_Hurter = GetClientTeam(HurterClient);
	new ClientTeam_Attacker = GetClientTeam(AttackerClient);
	
	if (PlayerHealthAfter >= 100)
	{
		PlayerHealthAfter = 100;
	}
	
	
	if(!IsFakeClient(AttackerClient))
	{
		if(ClientTeam_Hurter == 2)
		{
			if(ClientTeam_Attacker == 2)
			{
				if(AttackerClient != HurterClient)
				{
					new show= Dmg_Heath * huixuebeishu;
					if(show != 0)
					{
						PrintToChat(HurterClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x03%d\x05 血量", AttackerClient, show);
						SetEntityHealth(HurterClient, PlayerHealthAfter);
						return Plugin_Handled;
					}
				}
			}
		}
	}
	return Plugin_Handled;
}