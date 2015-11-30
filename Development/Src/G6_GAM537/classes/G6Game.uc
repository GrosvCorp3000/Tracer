class G6Game extends UTDeathmatch;

function RestartPlayer(Controller aPlayer)
{
	local G6PlayerController P;

	if (UTBot(aPlayer) != None && aPlayer.IsInState('Dead'))
	{
		foreach AllActors( class'G6PlayerController', P ) {
			P.roomSpawns[P.curRoom]--;
		}
		aPlayer.Destroy();
	}
	else
	{
		super.RestartPlayer(aPlayer);
	}
}

function Logout(controller Exiting)
{
	if (UTBot(Exiting) != None) return;

	super.Logout(Exiting);
}

DefaultProperties
{
	PlayerControllerClass = class'G6PlayerController'
	bUseClassicHUD = true
	HUDType=class'G6HUD'
	MapPrefixes[0] = "G6"
	DefaultPawnClass = class'G6Pawn' 
	//DefaultInventory(0)=class'G6Weap_Pistol'
	DefaultInventory(0) = None
}
