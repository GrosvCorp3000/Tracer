class W9PlaceableThing extends Actor
	placeable
	ClassGroup(Week9);


function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	`Log("Touch Start "$Other);
}

function Untouch(Actor Other)
{
	`Log("Torch End "$Other);
}

function Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	`Log("Bump"$Other);
}



DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MySM
		StaticMesh=StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_Climb'
		Translation=(Z=-96)
	End Object
	Components.Add(MySM)

	bCollideActors = true
	bBlockActors = true
}
