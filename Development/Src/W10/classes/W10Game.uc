class W10Game extends UTGame;

exec function AddBots(int Num)
{
	local int i;

	DesiredPlayerCount += Num;

	for (i=0; i <Num && AddBot(, true, 1) != None; i++)
	{
		`log("custom added bot"$i);
	}
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local W10Bot myBot;
	local W10Spawner spawner;

	myBot = W10Bot(Player);

	if (myBot != None)
	{
		foreach AllActors(class'W10Spawner', spawner)
		{
			`Log("returning spawner");
			return spawner;
		}
	}

	return super.FindPlayerStart(Player, inTeam, incomingName);
}

DefaultProperties
{
	MapPrefixes[0] = "W10"
	BotClass = class'W10Bot'
}
