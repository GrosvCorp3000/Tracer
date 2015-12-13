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
	FireInterval[0] = 1
	ShotCost[0] = 0
	WeaponRange=100
	AmmoCount = 500
	MaxAmmoCount = 500

	WeaponFireSnd(0)=SoundCue'A_Vehicle_Scorpion.SoundCues.A_Vehicle_Scorpion_BladeExtend'
	WeaponFireSnd(1)=SoundCue'A_Vehicle_Scorpion.SoundCues.A_Vehicle_Scorpion_BladeExtend'

	bCanThrow = False
}
