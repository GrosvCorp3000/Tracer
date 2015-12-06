class G6BWeap_Sword extends UTWeap_LinkGun;


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
	AttachmentClass=class'G6BAttach_Sword'
	
	WeaponProjectiles(0)=class'G6BProj_Sword'
	FireInterval[0] = 1.0
	ShotCost[0] = 0
	WeaponRange=100
	AmmoCount = 500
	MaxAmmoCount = 500

	bCanThrow = False
}
