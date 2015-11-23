class L8SpawnerBase extends Actor
	placeable
	ClassGroup(Lab08);

function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local L8CounterItem item;
	local Pawn p;

	`Log("Touch Start "$Other);
	p = Pawn(Other);
	if (p != None){
		if (p.InvManager.FindInventoryType(class'L8CounterItem') == None)
		{
			p.InvManager.CreateInventory(class'L8CounterItem');
		}
		if (p.InvManager.FindInventoryType(class'L8Weapon') == None)
		{
			p.InvManager.CreateInventory(class'L8Weapon');
		}
		item = L8CounterItem(p.InvManager.FindInventoryType(class'L8CounterItem'));
		item.increment();
		item.announce();
	}
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MySM
		StaticMesh=StaticMesh'E3_Demo.Meshes.SM_Barrel_01'
		Translation=(Z=-96)
	End Object
	Components.Add(MySM)

	bCollideActors = true
	bBlockActors = false
}
