#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>
#include <sdkhooks>

#define PLUGIN_VERSION "6.0.0"

new Handle:cvar_Difficulty = INVALID_HANDLE;
#define MAX_LINE_WIDTH 64
new nandu;
new DaoDi[MAXPLAYERS+1];

new Handle:Team_damage_on;
new Handle:flame_damage_on;
new Handle:jiandanhuixue;
new Handle:putonghuixue;
new Handle:kunnanhuixue;
new Handle:zhuanjiahuixue;
new Handle:Easy_MAX_HP;
new Handle:Normal_MAX_HP;
new Handle:Hard_MAX_HP;
new Handle:Impossible_MAX_HP;
new Handle:Incapped_MAX_Easy;
new Handle:Incapped_MAX_Normal;
new Handle:Incapped_MAX_Hard;
new Handle:Incapped_MAX_Impossible;

public Plugin:myinfo =
{
	name = "l4d2_AttackerTeam",
	author = "Mandysa. & 藤野深月.",
	description = "攻击队友可以帮助回血",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
} 

public OnPluginStart()
{
	CreateTimer(0.5, SurvivorFriendlyFireFactor);
	HookEvent("player_hurt", FriendlyFire);
	HookEvent("player_incapacitated_start", InCapacitated);
	HookEvent("revive_success", ReScued);
	HookEvent("mission_lost", Lost);
	HookEvent("player_death", Death);
	cvar_Difficulty = FindConVar("z_difficulty");
	HookConVarChange(cvar_Difficulty, ConVarDifficultyChange);
	RegisterCvars();
}

RegisterCvars()
{
	Team_damage_on					= CreateConVar("Team_damage_on",						"0",		"队友伤害 0=关闭 1=开启");
	flame_damage_on					= CreateConVar("flame_damage_on",						"1",		"火焰伤害 0=关闭 1=开启");
	jiandanhuixue						= CreateConVar("jiandanhuixue",							"10",		"简单难度击中队友回生命值  0=关闭");
	putonghuixue					= CreateConVar("putonghuixue",						"5",		"普通难度击中队友回生命值  0=关闭");
	kunnanhuixue						= CreateConVar("kunnanhuixue",							"3",		"困难难度击中队友回生命值  0=关闭");
	zhuanjiahuixue			= CreateConVar("zhuanjiahuixue",				"2",		"专家难度击中队友回生命值  0=关闭");
	Easy_MAX_HP							= CreateConVar("Easy_MAX_HP",								"100",	"简单难度可恢复最大生命值");
	Normal_MAX_HP						= CreateConVar("Normal_MAX_HP",							"100",	"普通难度可恢复最大生命值");
	Hard_MAX_HP							= CreateConVar("Hard_MAX_HP",								"100",	"困难难度可恢复最大生命值");
	Impossible_MAX_HP				= CreateConVar("Impossible_MAX_HP",					"100",	"专家难度可恢复最大生命值");
	Incapped_MAX_Easy				= CreateConVar("Incapped_MAX_Easy",					"300",	"简单难度倒地可恢复最大生命值");
	Incapped_MAX_Normal			= CreateConVar("Incapped_MAX_Normal",				"300",	"普通难度倒地可恢复最大生命值");
	Incapped_MAX_Hard				= CreateConVar("Incapped_MAX_Hard",					"300",	"困难难度倒地可恢复最大生命值");
	Incapped_MAX_Impossible	= CreateConVar("Incapped_MAX_Impossible",		"300",	"专家难度倒地可恢复最大生命值");
	AutoExecConfig(true, "l4d2_AttackerTeam");
}

public Action:InCapacitated(Handle:event, const String:name[], bool:dontBroadcast)
{
	new DaoDiclient = GetClientOfUserId(GetEventInt(event, "userid"));
	new DaoDiTeam = GetClientTeam(DaoDiclient);
	
	if(IsClientConnected(DaoDiclient))
	{
		if(IsPlayerAlive(DaoDiclient))
		{
			if(DaoDiTeam == 2)
			{
				for(new i = 0; i < MAXPLAYERS + 1; i++)
				{
					if(DaoDi[i] == 0)
					{
						DaoDi[i] = DaoDiclient;
						return Plugin_Handled;
					}
					else 
					{
						continue;
					}
				}
			}
		}
	}
	return Plugin_Handled;
}

public Action:ReScued(Handle:event, const String:name[], bool:dontBroadcast)
{
	new HuoJiuclient = GetClientOfUserId(GetEventInt(event, "subject"));
	new HuojiuTeam = GetClientTeam(HuoJiuclient);
	
	if(IsClientConnected(HuoJiuclient))
	{
		if(IsPlayerAlive(HuoJiuclient))
		{
			if(HuojiuTeam == 2)
			{
				for(new i = 0; i < MAXPLAYERS + 1; i++)
				{
					if(DaoDi[i] == HuoJiuclient)
					{
						DaoDi[i] = 0;
						return Plugin_Handled;
					}
					else
					{
						continue;
					}
				}
			}
		}
	}
	return Plugin_Handled;
}

public Action:Death(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	for(new i = 0; i < MAXPLAYERS + 1; i++)
	{
		if(DaoDi[i] == client)
		{
			DaoDi[i] = 0;
			return Plugin_Handled;
		}
		else
		{
			continue;
		}
	}
	return Plugin_Handled;
}


void Change()
{
	if(GetCurrentDifficulty()==0)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为简单 击中队友回血量修改为: \x04%d ", GetConVarInt(jiandanhuixue));
		nandu = 0;
		return;
	}
	else if(GetCurrentDifficulty()==1)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为普通 击中队友回血量修改为: \x04%d ", GetConVarInt(putonghuixue));
		nandu = 1;
		return;
	}
	else if(GetCurrentDifficulty()==2)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为高级 击中队友回血量修改为: \x04%d ", GetConVarInt(kunnanhuixue));
		nandu = 2;
		return;
	}
	else if(GetCurrentDifficulty()==3)
	{
		PrintToChatAll("\x05[\x03回血\x05] \x03检测到难度更改为专家 击中队友回血量修改为: \x04%d ", GetConVarInt(zhuanjiahuixue));
		nandu = 3;
		return;
	}
	return;
}

public Action:Lost(Handle:event, const String:name[], bool:dontBroadcast)
{
	for(new i = 0; i < MAXPLAYERS + 1; i++)
	{
		DaoDi[i] = 0;
	}
}

public OnMapStart()
{
	Change();
	for(new i = 0; i < MAXPLAYERS + 1; i++)
	{
		DaoDi[i] = 0;
	}
	return;
}

public OnClientPutInServer(client)
{
	if(nandu == 0)
	{
		PrintToChat(client, "\x05[\x03回血\x05] \x03当前服务器难度为简单 击中队友回血量为: \x04%d ", GetConVarInt(jiandanhuixue));
		return;
	}
	else if(nandu == 1)
	{
		PrintToChat(client, "\x05[\x03回血\x05] \x03当前服务器难度为普通 击中队友回血量为: \x04%d ", GetConVarInt(putonghuixue));
		return;
	}
	else if(nandu == 2)
	{
		PrintToChat(client, "\x05[\x03回血\x05] \x03当前服务器难度为高级 击中队友回血量为: \x04%d ", GetConVarInt(kunnanhuixue));
		return;
	}
	else if(nandu == 3)
	{
		PrintToChat(client, "\x05[\x03回血\x05] \x03当前服务器难度为专家 击中队友回血量为: \x04%d ", GetConVarInt(zhuanjiahuixue));
		return;
	}
}

public OnClientDisconnect(client)
{
	new clientTeam = GetClientTeam(client);
	
	if(clientTeam == 2)
	{
		for(new i = 0; i < MAXPLAYERS + 1; i++)
		{
			if(DaoDi[i] == client)
			{
				DaoDi[i] = 0;
				return;
			}
			else
			{
				continue;
			}
		}
	}
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

SerachClient(client)
{
	for(new i = 0; i < MAXPLAYERS + 1; i++)
	{
		if(DaoDi[i] == client)
		{
			return 1;
		}
		else 
		{
			continue;
		}
	}
	return 0;
}

public Action:SurvivorFriendlyFireFactor(Handle timer)
{
	if(GetConVarInt(Team_damage_on) == 0)
	{
		SetConVarFloat(FindConVar("survivor_friendly_fire_factor_easy"), 0.0);
		SetConVarFloat(FindConVar("survivor_friendly_fire_factor_normal"), 0.0);
		SetConVarFloat(FindConVar("survivor_friendly_fire_factor_hard"), 0.0);
		SetConVarFloat(FindConVar("survivor_friendly_fire_factor_expert"), 0.0);
	}
	if(GetConVarInt(flame_damage_on) == 0)
	{
		SetConVarFloat(FindConVar("survivor_burn_factor_easy"), 0.0);
		SetConVarFloat(FindConVar("survivor_burn_factor_Normal"), 0.0);
		SetConVarFloat(FindConVar("survivor_burn_factor_hard"), 0.0);
		SetConVarFloat(FindConVar("survivor_burn_factor_expert"), 0.0);
	}
	return Plugin_Handled;
}

public Action:FriendlyFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	new AttackerUserId = GetEventInt(event, "attacker");
	new AttackerClient = GetClientOfUserId(AttackerUserId);
	new VictimUserid = GetEventInt(event, "userid");
	new VictimClient = GetClientOfUserId(VictimUserid);
	
	if(AttackerClient && VictimClient)
	{
		new AttackerTeam = GetClientTeam(AttackerClient);
		new VictimTeam = GetClientTeam(VictimClient);
		new PlayerAlive = IsPlayerAlive(VictimClient);
		new PlayerAlive2 = IsPlayerAlive(AttackerClient);
		new PlayerHealthBefore = GetClientHealth(VictimClient);
		
		if(!IsFakeClient(AttackerClient))
		{
			if(PlayerAlive == 1)
			{
				if(PlayerAlive2 == 1)
				{
					if(AttackerTeam == 2)
					{
						if(VictimTeam == 2)
						{
							if(VictimClient != AttackerClient)
							{
								if(nandu == 0)
								{
									new PlayerHealthAfterjiandan = PlayerHealthBefore + GetConVarInt(jiandanhuixue);
									
									if(SerachClient(VictimClient))
									{
										if(PlayerHealthAfterjiandan > GetConVarInt(Incapped_MAX_Easy))
										{
											PlayerHealthAfterjiandan = GetConVarInt(Incapped_MAX_Easy);
											PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
											SetEntityHealth(VictimClient, PlayerHealthAfterjiandan);
											return Plugin_Handled;
										}
										SetEntityHealth(VictimClient, PlayerHealthAfterjiandan);
										PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(jiandanhuixue));
										return Plugin_Handled;
									}
									else if(PlayerHealthAfterjiandan > GetConVarInt(Easy_MAX_HP))
									{
											PlayerHealthAfterjiandan = GetConVarInt(Easy_MAX_HP);
											PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
											SetEntityHealth(VictimClient, PlayerHealthAfterjiandan);
											return Plugin_Handled;
									}
									SetEntityHealth(VictimClient, PlayerHealthAfterjiandan);
									PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(jiandanhuixue));
								}
								else if(nandu == 1)
								{
									new PlayerHealthAfterputong = PlayerHealthBefore + GetConVarInt(putonghuixue);
									
									if(SerachClient(VictimClient))
									{
										if(PlayerHealthAfterputong > GetConVarInt(Incapped_MAX_Normal))
										{
											PlayerHealthAfterputong = GetConVarInt(Incapped_MAX_Normal);
											PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
											SetEntityHealth(VictimClient, PlayerHealthAfterputong);
											return Plugin_Handled;
										}
										SetEntityHealth(VictimClient, PlayerHealthAfterputong);
										PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(putonghuixue));
										return Plugin_Handled;
									}
									else if(PlayerHealthAfterputong > GetConVarInt(Normal_MAX_HP))
									{
										PlayerHealthAfterputong = GetConVarInt(Normal_MAX_HP);
										PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
										SetEntityHealth(VictimClient, PlayerHealthAfterputong);
										return Plugin_Handled;
									}
									SetEntityHealth(VictimClient, PlayerHealthAfterputong);
									PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(putonghuixue));
								}
								else if(nandu == 2)
								{
									new PlayerHealthAftergaoji = PlayerHealthBefore + GetConVarInt(kunnanhuixue);
									
									if(SerachClient(VictimClient))
									{
										if(PlayerHealthAftergaoji > GetConVarInt(Incapped_MAX_Hard))
										{
											PlayerHealthAftergaoji = GetConVarInt(Incapped_MAX_Hard);
											PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
											SetEntityHealth(VictimClient, PlayerHealthAftergaoji);
											return Plugin_Handled;
										}
										SetEntityHealth(VictimClient, PlayerHealthAftergaoji);
										PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(kunnanhuixue));
										return Plugin_Handled;
									}
									else if(PlayerHealthAftergaoji > GetConVarInt(Hard_MAX_HP))
									{
										PlayerHealthAftergaoji = GetConVarInt(Hard_MAX_HP);
										PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
										SetEntityHealth(VictimClient, PlayerHealthAftergaoji);
										return Plugin_Handled;
									}
									SetEntityHealth(VictimClient, PlayerHealthAftergaoji);
									PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(kunnanhuixue));
								}
								else if(nandu == 3)
								{
									new PlayerHealthAfterzhuanjia = PlayerHealthBefore + GetConVarInt(zhuanjiahuixue);
									
									if(SerachClient(VictimClient))
									{
										if(PlayerHealthAfterzhuanjia > GetConVarInt(Incapped_MAX_Impossible))
										{
											PlayerHealthAfterzhuanjia = GetConVarInt(Incapped_MAX_Impossible);
											PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
											SetEntityHealth(VictimClient, PlayerHealthAfterzhuanjia);
											return Plugin_Handled;
										}
										SetEntityHealth(VictimClient, PlayerHealthAfterzhuanjia);
										PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(zhuanjiahuixue));
										return Plugin_Handled;
									}
									else if(PlayerHealthAfterzhuanjia > GetConVarInt(Impossible_MAX_HP))
									{
										PlayerHealthAfterzhuanjia = GetConVarInt(Impossible_MAX_HP);
										PrintToChat(VictimClient, "\x05[\x03回血\x05] 你的血量已经到达上限！");
										SetEntityHealth(VictimClient, PlayerHealthAfterzhuanjia);
										return Plugin_Handled;
									}
									SetEntityHealth(VictimClient, PlayerHealthAfterzhuanjia);
									PrintToChat(VictimClient, "\x05[\x03回血\x05] \x03%N\x05 攻击了你 帮你恢复了 \x04%d\x05 血量", AttackerClient, GetConVarInt(zhuanjiahuixue));
								}
							}
						}
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