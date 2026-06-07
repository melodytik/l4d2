#include <sourcemod>
#include <sdktools>
new DoorClose[MAXPLAYERS+1];
public Plugin:myinfo =
{
	name = "自动骂玩门的傻逼",
	author = "Mandysa.",
	description = "",
	version = "1.0",
	url = "qq3063276667"
};

public OnPluginStart()
{
	HookEvent("door_close", DL_Event_DoorClose);
	HookEvent("round_start",					Event_RoundStart);
}

public Action: DL_Event_DoorClose(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (GetEventBool(event, "checkpoint"))
	{
		new Client = GetClientOfUserId(GetEventInt(event, "userid"));
		if(IsValidPlayer(Client) && !IsFakeClient(Client))
		{
			DoorClose[Client]++;
			if(DoorClose[Client]>1)
			{
				MaRen(Client);
			}
		}
	}
}

void MaRen(Client)
{
	new Rand = GetRandomInt(0, 15);
	switch(Rand)
	{
		case 0:PrintToChat(Client,"\x04死妈东西玩你妈门呢？");
		case 1:PrintToChat(Client,"\x04不会吧不会吧，不会真有傻逼搁那玩门吧");
		case 2:PrintToChat(Client,"\x04还玩门？再玩门给你妈来一拳");
		case 3:PrintToChat(Client,"\x04你全家烂逼死空你母亲深逼流大量逼水被你爹用鸡巴插穿孔你妈一分");
		case 4:PrintToChat(Client,"\x04杀砍头的血逼把你爹杀了操你奶奶的内脏把你奶奶的大肠崩坏你奶奶粪便露出你爷爷日穿你奶奶的肝i");
		case 5:PrintToChat(Client,"\x04你妈的巨幅度动作不小心把你妈日死从你妈的死逼里生出来的你鸡");
		case 6:PrintToChat(Client,"\x04死烂逼杂种日你妈的血鸡巴杀你妈血脑壳把你妈脑浆挤出来喂狗吃");
		case 7:PrintToChat(Client,"\x04为什么要玩门？一定是性功能不全 找不到事做吧？");
		case 8:PrintToChat(Client,"\x04臭弟弟 喜欢玩门？ 我马上开车把你妈撞死");
		case 9:PrintToChat(Client,"\x04玩门的傻逼我是你爹");
		case 10:PrintToChat(Client,"\x04你怎么不去icu给你妈买一个骨灰盒给你妈当生日礼物送给她");
		case 11:PrintToChat(Client,"\x04我拿你妈的骨灰盒水弄个沙堡玩玩");
		case 12:PrintToChat(Client,"\x04我的小鲤鱼在你妈的臭嗨里漫游");
		case 13:PrintToChat(Client,"\x04死烂逼杂种日你妈的血鸡巴杀你妈血脑壳把你妈脑浆挤出来喂狗吃");
		case 14:PrintToChat(Client,"\x04日你妈你在服里什么地位不清楚？还玩门？");
		case 15:PrintToChat(Client,"\x04真想亲自把你们这种玩门傻逼的妈都给杀了 可惜她早已在阴间了");
	}
}

public OnClientPutInServer(client)
{
	DoorClose[client] = 0;
}

public OnClientDisconnect(client)
{
	DoorClose[client] = 0;
}

public Event_RoundStart(Handle:event, const String:strName[], bool:DontBroadcast)
{
	CreateTimer(1.0,PlayerSpawnsX);
}

public Action:PlayerSpawnsX(Handle:timer)
{
	for( new i = 1; i <= MaxClients; i++ )
	{
		DoorClose[i] = 0;
	}
}

stock bool:IsValidPlayer(Client, bool:AllowBot = true, bool:AllowDeath = true)
{
	if (Client < 1 || Client > MaxClients)
		return false;
	if (!IsClientConnected(Client))
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