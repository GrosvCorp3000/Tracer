class W9Projectile extends UTProjectile;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	`Log("W9Projectile instantiated -> "$self);
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=ProjDisplay
		StaticMesh=StaticMesh'LT_Light.SM.Mesh.S_LT_Light_SM_Light01'
	End Object
	Components.Add(ProjDisplay)

	LifeSpan=10
	MaxSpeed=300
	Speed=150
	AccelRate=100
	Damage=50
	DamageRadius=50
	MomentumTransfer=1000
}
