class G6Game extends UTDeathmatch;

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
