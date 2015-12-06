class G6BWeap_MachineGun extends UTWeap_LinkGun;


function bool CanAttack(Actor Other)
{
	return super.CanAttack(other) && vsize(other.Location - instigator.Location) <= WeaponRange;
}

function byte BestMode()
{
	return 0;
}

DefaultProperties
{
	AttachmentClass=class'G6BAttach_MachineGun'
	
	WeaponProjectiles(0)=class'G6BProj_MachineGun'
	FireInterval[0] = 0.2
	ShotCost[0] = 0
	WeaponRange=500
	AmmoCount = 500
	MaxAmmoCount = 500

	bCanThrow = False
}
