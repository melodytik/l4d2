#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0.0"

/* 击杀特感参数 */
new BoomerKills;
new SmokerKills;
new HunterKills;
new SpitterKills;
new jockeyKills;
new ChargerKills;
new XSS;
/* 存档参数 */
new String:SavePath[256];
new Handle:SaveData = INVALID_HANDLE;

public Plugin:myinfo = 
{
	name = "保存服务器内玩家击杀特感数并定时播报",
	author = "Mandysa.",
	description = "保存服务器内玩家击杀特感数并定时播报",
	version = PLUGIN_VERSION,
	url = "qq3063276667"
};

public OnPluginStart()
{
	HookEvent("player_death", Client_Death);
	HookEvent("infected_death", InFected_Death);
	LoadSaveData();
}

public OnMapEnd()
{
    ClientSaveToFile();
    CloseHandle(SaveData);
}

public OnPluginEnd()
{
    ClientSaveToFile();
    CloseHandle(SaveData);
}

/* 地图开始 */
public OnMapStart()
{
    SaveData = CreateKeyValues("特感击杀数据");
    BuildPath(Path_SM, SavePath, 255, "data/infected_Save.txt");
    FileToKeyValues(SaveData, SavePath);
    ClientLoadToFile();
}

public OnClientPutInServer(client)
{
    CreateTimer(25.0, Print, client);
}

public Action:Print(Handle timer, client)
{
	PrintToChat(client, "\x05当前服务器所有玩家累计击杀特感数:");
	PrintToChat(client, "\x01Smoker:\x03 %d", SmokerKills);
	PrintToChat(client, "\x01Boomer:\x03 %d", BoomerKills);
	PrintToChat(client, "\x01Hunter:\x03 %d", HunterKills);
	PrintToChat(client, "\x01Jockey:\x03 %d", jockeyKills);
	PrintToChat(client, "\x01Spitter:\x03 %d", SpitterKills);
	PrintToChat(client, "\x01Charger:\x03 %d", ChargerKills);	
	PrintToChat(client, "\x01小僵尸:\x03 %d", XSS);
}

public Action:InFected_Death(Handle:event, const String:name[], bool:dontBroadcast)
{
    new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

    if(GetClientTeam(attacker) == 2)
    {
        XSS++;
    }
    return Plugin_Handled;
}

public Action:Client_Death(Handle:event, const String:name[], bool:dontBroadcast)
{
    new client = GetClientOfUserId(GetEventInt(event, "userid"));
    new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

    if(GetClientTeam(client) == 3)
    {
        new iClass = GetEntProp(client, Prop_Send, "m_zombieClass");
        if(GetClientTeam(attacker) == 2)
        {
            switch (iClass)
            {
            case 1: //smoker
                {
                    SmokerKills++;
                    return Plugin_Handled;
                }
            case 2: //boomer
                {
                    BoomerKills++;
                    return Plugin_Handled;
                }
            case 3: //hunter
                {
                    HunterKills++;
                    return Plugin_Handled;
                }
            case 4: //spitter
                {
                    SpitterKills++;
                    return Plugin_Handled;
                }
            case 5: //jockey
                {
                    jockeyKills++;
                    return Plugin_Handled;
                }
            case 6: //charger
                {
                    ChargerKills++;
                    return Plugin_Handled;
                }
            }
        }
    }
    return Plugin_Handled;
}

/************************************************************************
*													存档保存读取功能
************************************************************************/
stock LoadSaveData()
{
	/* 创建Save和Ranking的KeyValues */
	SaveData = CreateKeyValues("击杀数据");
	/* 设置Save和Ranking位置 */
	BuildPath(Path_SM, SavePath, 255, "data/infected_Save.txt");
	if (FileExists(SavePath))
		FileToKeyValues(SaveData, SavePath);
	else
		KeyValuesToFile(SaveData, SavePath);
}

/* 读取存档Function */
public ClientLoadToFile()
{
    /* 读取玩家资料 */
    KvGotoFirstSubKey(SaveData, true);
    BoomerKills	= KvGetNum(SaveData, "击杀Boomer数量", 0);
    SmokerKills	= KvGetNum(SaveData, "击杀Smoker数量", 0);
    HunterKills	= KvGetNum(SaveData, "击杀Hunter数量", 0);
    SpitterKills = KvGetNum(SaveData, "击杀Spitter数量", 0);
    jockeyKills	= KvGetNum(SaveData, "击杀jockey数量", 0);
    ChargerKills = KvGetNum(SaveData, "击杀Charger数量", 0);
    XSS = KvGetNum(SaveData, "击杀小僵尸数量", 0);

    KvGoBack(SaveData);
    KvRewind(SaveData);
}

/* 存档Function */
public ClientSaveToFile()
{
	/* 保存玩家资料 */
    KvGotoFirstSubKey(SaveData, true);
    KvSetNum(SaveData, "击杀Boomer数量", BoomerKills);
    KvSetNum(SaveData, "击杀Smoker数量", SmokerKills);
    KvSetNum(SaveData, "击杀Hunter数量", HunterKills);
    KvSetNum(SaveData, "击杀Spitter数量", SpitterKills);
    KvSetNum(SaveData, "击杀jockey数量", jockeyKills);
    KvSetNum(SaveData, "击杀Charger数量", ChargerKills);
    KvSetNum(SaveData, "击杀小僵尸数量", XSS);

    KvGoBack(SaveData);
    KvRewind(SaveData);
    KeyValuesToFile(SaveData, SavePath);
}