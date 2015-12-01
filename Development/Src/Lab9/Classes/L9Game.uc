class L9Game extends UTGame;

function RestartPlayer(Controller aPlayer)
{
	if (L9Bot(aPlayer) != None && aPlayer.IsInState('Dead'))
	{
		aPlayer.Destroy();
	}
	else
	{
		super.RestartPlayer(aPlayer);
	}
}

function Logout(controller Exiting)
{
	if (L9Bot(Exiting) != None) return;

	super.Logout(Exiting);
}

DefaultProperties
{
	MapPrefixes[0]="L9"
	BotClass=class'L9Bot'
	DefaultInventory[0]=class'L9LinkGun'
}
