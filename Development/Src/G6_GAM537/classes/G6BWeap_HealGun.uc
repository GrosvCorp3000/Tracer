class G6BWeap_HealGun extends UTWeap_LinkGun;

function bool CanAttack(Actor Other)
{
	return vsize(other.Location - instigator.Location) <= WeaponRange;
}

function byte BestMode()
{
	return 1;
}

DefaultProperties
{
	AttachmentClass=class'G6BAttach_HealGun'
	/*
	InstantHitDamage(0)=0
	InstantHitDamageTypes(0)=class'UTDmgType_LinkBeam'
	FiringStatesArray(0)=WeaponBeamFiring
	*/
	FireInterval(0)=+1
	FireInterval(1)=+1
	ShotCost[0] = 0
	ShotCost[1] = 0
	WeaponRange=500
	AmmoCount = 500
	MaxAmmoCount = 500
	BeamAmmoUsePerSecond=0.5
	MomentumTransfer=500.0

	bCanThrow = False
}
