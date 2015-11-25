class W9Weapon extends UTWeapon;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	`Log("W9Weapon instantiated");
}

simulated function vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	return instigator.Location + vector(GetAdjustedAim(Vect(0,0,0))) * 150;
}

simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
	local rotator outRotation;

	outRotation = instigator.Rotation;
	outRotation.Pitch = 0;

	return outRotation;
}

simulated function vector InstantFireStartTrace()
{
	return GetPhysicalFireStartLoc();
}

simulated function vector InstantFireEndTrace(vector StartTrace)
{
	return startTrace + Vector(GetAdjustedAim(vect(0,0,0))) * WeaponRange;
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	`Log("Hit actor "$impact.HitActor$", location "$impact.HitLocation$", normal "$impact.HitNormal);
	super.ProcessInstantHit(FiringMode, Impact, NumHits);
}

DefaultProperties
{
	WeaponFireTypes[0] = EWFT_Projectile
	WeaponProjectiles[0] = class'W9Projectile'
	FireInterval[0] = 0.1
	ShotCost[0] = 1
	WeaponFireAnim[0]=WeaponFire

	WeaponFireTypes[1] = EWFT_InstantHit
	FireInterval[1] = 0.5
	ShotCost[1] = 1
	WeaponFireAnim[1]=WeaponFire
	InstantHitDamage[1]=10
	InstantHitMomentum[1]=20000
	InstantHitDamageTypes[1]=class'UTDmgType_Drowned'

	AttachmentClass=class'W9WeaponShockAttachment'

	AmmoCount = 100
	MaxAmmoCount = 500

	WeaponRange = 10000

	Begin Object Class=AnimNodeSequence Name=FPDMAnimNode
		bCauseActorAnimEnd=true
	End Object

	Begin Object Class=SkeletalMeshComponent Name=FPDisplayMesh
		SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_1P'
		AnimSets[0]=AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_1P_Base'
		Animations=FPDMAnimNode
	End Object
	//Mesh=FPDisplayMesh
}
