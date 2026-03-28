#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdktools_functions>
#include <adminmenu>
#include <geoip>

#define PLUGIN_VERSION "1.0.0"

new bool:Pass;

public Plugin:myinfo =
{
	name = "玩家进服显示地区IP与SteamId",
	author = "Mandysa.",
	description = "玩家进服显示地区IP与SteamId",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
} 

public OnMapStart()
{
	Pass = true;
	CreateTimer(18.0, PASS);
}

public Action:PASS(Handle timer)
{
	Pass = false;
}

public OnClientPutInServer(client)
{
	decl String:ClientIP[16];
	decl String:country[45];
	decl String:SteamId[32];
	
	if(!Pass)
	{
		if(!IsFakeClient(client))
		{
			GetClientIP(client, ClientIP, 16);
			GetClientAuthString (client, SteamId, 32);
			
			if(GeoipCountry(ClientIP, country, 45))
			{
				PrintToChatAll("\x04[提示]\x03%N\x04 加入了服务器 \x05IP:\x04%s 来自国家/地区:\x05%s \x04SteamId:\x05%s ", client, ClientIP, country, SteamId);
			}
			else
			{
				PrintToChatAll("\x04[提示]\x03%N\x04 加入了服务器 \x05IP:\x04%s 国家/地区:\x05Error SteamId:\x05%s -by Mandysa", client, ClientIP, SteamId);
			}
		}
	}
	return;
}