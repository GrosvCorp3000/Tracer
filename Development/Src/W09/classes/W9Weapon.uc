class W9Weapon extends UTWeapon;

var StaticMeshComponent myDisplay;

simulated function PostBeginPlay()
{
	`Log("created weapon");
	super.PostBeginPlay();
}
/**
 * This function is called from the pawn when the visibility of the weapon changes
 */
simulated function ChangeVisibility(bool bIsVisible)
{
	super.ChangeVisibility(bIsVisible);
	myDisplay.SetHidden(false);
}

simulated function vector InstantFireStartTrace()
{
	return GetPhysicalFireEndTrace();
}

simulated function vector InstantFireEndTrace()
{

}


DefaultProperties
{
	WeaponFireTypes[0] = EWFT_Projectile
	WeaponProjectiles[0] = class'W9Projectile'
	FireInterval[0] = 0.1
	ShotCost[0] = 1
	WeaponFireAnim[0] = WeaponFire

	WeaponFireTypes[1] = EWFT_InstantHit
	FireInterval[0] = 0.5
	ShotCost[1] = 1
	WeaponFireAnim[1] = WeaponFire
	InstantHitDamage[1]=10
	InstantHitMomentum[1]=20000
	InstatnHitDamageTypes=class'UTDmgType_Drowned'


	AttachmentClass=class'W9WeaponShockAttachment'

	AmmoCount = 100
	MaxAmmoCount = 500

	WeaponRange = 1000;

	Begin Object Class=AnimNodeSequence Name=FPDMAnimNode
		bCauseActorAnimEnd=true
	End Object

	Begin Object Class=SkeletalMeshComponent Name=FPDisplayMesh
		SkeletalMesh=SkeletalMesh'WP_RocketLauncher.Mesh.SK_WP_RocketLauncher_1P'
		AnimSets[0]=AnimSet'WP_RocketLauncher.Anims.K_WP_RocketLauncher_1P_Base'
		Animations=FPDMAnimNode
	End Object
	Mesh=FPDisplayMesh

	Begin Object Class=StaticMeshComponent Name=MySM
		StaticMesh=StaticMesh'NodeBuddies.3D_Icons.NodeBuddy_Climb'
		Translation=(Z=-96)
	End Object
	Components.Add(MySM)
}
