class W10Spawner extends PathNode
	placeable
	ClassGroup(Week10);

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=DisplayMesh
		StaticMesh=StaticMesh'KismetGame_Assets.Meshes.SM_SunFlower_02'
	End Object
	Components.Add(DisplayMesh)

	bBlockActors=false
	bCollideWorld=false
}
