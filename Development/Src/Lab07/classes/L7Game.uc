class L7Game extends UTGame;

exec function CreateBall()
{
	spawn(class'Ball');
}

exec function CreateBox()
{
	spawn(class'Ball');
}

exec function IterateSelectable()
{
	local Actor actor;
	local W8Selectable selectable;

	foreach AllActors(class'Actor', actor, class'W8Selectable')
	{
		selectable = W8Selectable(actor);
		`Log("sdfsdf"$selectable.SaySomething());
	}
}

DefaultProperties
{
	PlayerControllerClass = class'L7Player'
	bUseClassicHUD = true
	HUDType=class'L7HUD'
	MapPrefixes[0] = "L7"
	DefaultPawnClass = class'L7Pawn' 
}
