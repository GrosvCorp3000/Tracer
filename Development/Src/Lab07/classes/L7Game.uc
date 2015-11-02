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
}
