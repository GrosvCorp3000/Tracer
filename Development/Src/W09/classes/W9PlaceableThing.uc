class W9PlaceableThing extends Actor
	placeable
	ClassGroup(Week9);

function Touch(Actor Other, PrimitiveComponent OtherComp,
	Vector HitLocation, Vector HitNormal)
{
	local Pawn P;
	
	`Log("Touch START "$Other);	
	P = Pawn(Other);
	if (P != None)
	{
		if (P.InvManager.FindInventoryType(
			class'W9Weapon') == None)
		{
			P.InvManager.CreateInventory(class'W9Weapon');
		}
	}
}

function PostTouch(Actor Other)
{
	`Log("post touch... "$Other);
}

function Untouch(Actor Other)
{
	`Log("Touch END "$Other);
}

function Bump(Actor Other, PrimitiveComponent OtherComp,
	Vector HitNormal)
{
	`Log("BUMP "$other);
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MySM
		StaticMesh=StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_Climb'
		Translation=(Z=-96)
	End Object
	Components.Add(MySM)
	bCollideActors = True
}
