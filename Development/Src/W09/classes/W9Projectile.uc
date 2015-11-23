class W9Projectile extends UTProjectile;

simulated function PostBeginPlay()
{
	`Log("created projective"$self);
}


DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=ProjDisplay
		StaticMesh=StaticMesh'LT_Light.SM.Mesh.S_LT_Light_SM_Light01'
	End Object
	Components.Add(ProjDisplay)

	LifeSpan=10
	MaxSpeed=1000
	Speed=300
	AccelRate=100
	Damage=5
	DamageRadius=50
	MomentumTransfer=1000 
}
