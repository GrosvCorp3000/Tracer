class W9Weapon extends UTWeapon;

function PostBeginPlay()
{
	`Log("created weapon");
	super.PostBeginPlay();
}

DefaultProperties
{
	WeaponFireTypes[0] = EWFT_Projectile
	WeaponProjectiles[0] = class'W9Projectile'
	FireInterval[0] = 0.1
	ShotCost[0] = 1
	WeaponFireAnim[0] = WeaponFire

	AmmoCount = 100
	MaxAmmoCount = 500

	Begin Object Class=AnimNodeSequence Name=FPDMAnimNode
		bCauseActorAnimEnd=true
	End Object

	Begin Object Class=SkeletalMeshComponent Name=FPDisplayMesh
		SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_1P'
		AnimSets[0]=AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_1P_Base'
		Animations=FPDMAnimNode
	End Object
	Mesh=FPDisplayMesh
}
