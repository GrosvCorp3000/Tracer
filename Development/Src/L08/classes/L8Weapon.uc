class L8Weapon extends UTWeapon;

simulated function vector GetPhysicalFireStartLoc(optional vector AimDir) {
	local vector v;
	v = vect(0, 0, 500);
	return v; 
}

/**
 * GetAdjustedAim begins a chain of function class that allows the weapon, the pawn and the controller to make
 * on the fly adjustments to where this weapon is pointing.
 */
simulated function Rotator GetAdjustedAim( vector StartFireLoc )
{
	local rotator R;

	// Start the chain, see Pawn.GetAdjustedAimFor()
	/*
	if( Instigator != None )
	{
		R = Instigator.GetAdjustedAimFor( Self, StartFireLoc );
	}*/
	R = rotator(normal(Location -StartFireLoc));
	return AddSpread(R);
}

DefaultProperties
{
	WeaponFireTypes[0] = EWFT_Projectile
	WeaponProjectiles[0] = class'L8Projectile'
	FireInterval[0] = 0.1
	ShotCost[0] = 1
	WeaponFireAnim[0] = WeaponAltFireLaunch1End
	WeaponIdleAnims[0] = WeaponIdle

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
