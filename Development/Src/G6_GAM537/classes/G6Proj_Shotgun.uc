class G6Proj_Shotgun extends UTProjectile;

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent1
		StaticMesh=StaticMesh'LT_Light.SM.Mesh.S_LT_Light_SM_Light01'
	End Object
	Components.Add(StaticMeshComponent1)

	LifeSpan=10
	MaxSpeed=300
	Speed=150
	AccelRate=100
	Damage=50
	DamageRadius=10
	MomentumTransfer=10000
	bRotationFollowsVelocity=true
	bCollideActors=true
	bCollideWorld=true
}
