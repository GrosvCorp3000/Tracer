class W9Projectile extends UTProjectile;

simulated function PostBeginPlay()
{
	`Log("created projective"$self);
}


DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=ProjDisplay
		StaticMesh=StaticMesh'WP_BioRifle.Mesh.S_Bio_Blob_01'
	End Object
	Components.Add(ProjDisplay)

	LifeSpan=10
	MaxSpeed=300
	Speed=150
	AccelRate=100
	Damage=5
	DamageRadius=50
	MomentumTransfer=1000 
}
