#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>
#include <sdkhooks>

#define PLUGIN_VERSION "2.3.2"

new Handle:cvar_Difficulty = INVALID_HANDLE;
#define MAX_LINE_WIDTH 64
new nandu;

new jiandanhuixue = 10;//简单难度击中队友回血量
new putonghunxue = 5;//普通难度击中队友回血量
new kunnanhuixue = 2;//困难难度击中队友回血量
new zhuanjiahuixue = 1;//专家难度击中队友回血量

public Plugin:myinfo =
{
	name = "攻击队友帮助回血-固定回血量关闭友伤版",
	author = "Mandysa.",
	description = "",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
} 

public OnPluginStart()
{
	CreateTimer(0.5, SurvivorFriendlyFireFactor);
	HookEvent("friendly_fire", FriendlyFire);
	cvar_Difficulty = FindConVar("z_difficulty");
	HookConVarChange(cvar_Difficulty, ConVarDifficultyChange);
}

void Change()
{
	if(GetCurrentDifficulty()==0)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为简单 击中队友回血量修改为: \x04%d ", jiandanhuixue);
		nandu = 0;
		return;
	}
	else if(GetCurrentDifficulty()==1)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为普通 击中队友回血量修改为: \x04%d ", putonghunxue);
		nandu = 1;
		return;
	}
	else if(GetCurrentDifficulty()==2)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为高级 击中队友回血量修改为: \x04%d ", kunnanhuixue);
		nandu = 2;
		return;
	}
	else if(GetCurrentDifficulty()==3)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为专家 击中队友回血量修改为: \x04%d ", zhuanjiahuixue);
		nandu = 3;
		return;
	}
	return;
}

public OnMapStart()
{
	Change();
	return;
}

GetCurrentDifficulty()
{
	decl String:Difficulty[MAX_LINE_WIDTH];
	GetConVarString(cvar_Difficulty, Difficulty, sizeof(Difficulty));
	if (StrEqual(Difficulty, "normal", false)) return 1;
	else if (StrEqual(Difficulty, "hard", false)) return 2;
	else if (StrEqual(Difficulty, "impossible", false)) return 3;
	else return 0;
}

public Action:SurvivorFriendlyFireFactor(Handle timer)
{
	SetConVarString(FindConVar("survivor_friendly_fire_factor_easy"), "0", false, false);
	SetConVarString(FindConVar("survivor_friendly_fire_factor_normal"), "0", false, false);
	SetConVarString(FindConVar("survivor_friendly_fire_factor_hard"), "0", false, false);
	SetConVarString(FindConVar("survivor_friendly_fire_factor_expert"), "0", false, false);
	return Plugin_Handled;
}

public Action:FriendlyFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	new AttackerUserId = GetEventInt(event, "attacker");
	new AttackerClient = GetClientOfUserId(AttackerUserId);
	new VictimUserid = GetEventInt(event, "victim");
	new VictimClient = GetClientOfUserId(VictimUserid);
	new AttackerTeam = GetClientTeam(AttackerClient);
	new VictimTeam = GetClientTeam(VictimClient);
	new PlayerHealthBefore = GetClientHealth(VictimClient);
	
	if(!IsFakeClient(AttackerClient))
	{
		if(AttackerTeam == 2)
		{
			if(VictimTeam == 2)
			{
				if(VictimClient != AttackerClient)
				{
					if(nandu == 0)
					{
						new PlayerHealthAfterjiandan = PlayerHealthBefore + jiandanhuixue;
						if(PlayerHealthAfterjiandan > 100)
						{
							PlayerHealthAfterjiandan = 100;
							PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
							SetEntityHealth(VictimClient, PlayerHealthAfterjiandan);
							return Plugin_Handled;
						}
						SetEntityHealth(VictimClient, PlayerHealthAfterjiandan);
						PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, jiandanhuixue);
					}
					else if(nandu == 1)
					{
						new PlayerHealthAfterputong = PlayerHealthBefore + putonghunxue;
						if(PlayerHealthAfterputong > 100)
						{
							PlayerHealthAfterputong = 100;
							PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
							SetEntityHealth(VictimClient, PlayerHealthAfterputong);
							return Plugin_Handled;
						}
						SetEntityHealth(VictimClient, PlayerHealthAfterputong);
						PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, putonghunxue);
					}
					else if(nandu == 2)
					{
						new PlayerHealthAfterkunnan = PlayerHealthBefore + kunnanhuixue;
						if(PlayerHealthAfterkunnan > 100)
						{
							PlayerHealthAfterkunnan = 100;
							PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
							SetEntityHealth(VictimClient, PlayerHealthAfterkunnan);
							return Plugin_Handled;
						}
						SetEntityHealth(VictimClient, PlayerHealthAfterkunnan);
						PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, kunnanhuixue);
					}
					else if(nandu == 3)
					{
						new PlayerHealthAfterzhuanjia = PlayerHealthBefore + zhuanjiahuixue;
						if(PlayerHealthAfterzhuanjia > 100)
						{
							PlayerHealthAfterzhuanjia = 100;
							PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
							SetEntityHealth(VictimClient, PlayerHealthAfterzhuanjia);
							return Plugin_Handled;
						}
						SetEntityHealth(VictimClient, PlayerHealthAfterzhuanjia);
						PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, zhuanjiahuixue);
					}
				}
			}
		}
	}
	return Plugin_Handled;
}

public ConVarDifficultyChange(Handle:convar, const String:oldValue[], const String:newValue[])
{
	Change();
	return;
}