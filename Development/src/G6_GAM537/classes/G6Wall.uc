class G6Wall extends Actor
	placeable
	ClassGroup(GROUP6);

function Touch(Actor Other, PrimitiveComponent OtherComp,
	Vector HitLocation, Vector HitNormal)
{	
}

function PostTouch(Actor Other)
{
	//`Log("post touch... "$Other);
}

function Untouch(Actor Other)
{
	//`Log("Touch END "$Other);
}

function Bump(Actor Other, PrimitiveComponent OtherComp,
	Vector HitNormal)
{
	//`Log("BUMP "$other);
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MySM
		StaticMesh=StaticMesh'LT_Bridge.SM.Mesh.S_LT_Bridge_SM_Bridgepanel01e'
		
	End Object
	Components.Add(MySM)
	bCollideActors = True
	bBlockActors = False
	bHidden = True
}
