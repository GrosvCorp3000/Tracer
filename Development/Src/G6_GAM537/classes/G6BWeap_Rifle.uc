class G6BWeap_Rifle extends UTWeap_ShockRifle;

function byte BestMode()
{
	return 0;
}

DefaultProperties
{
	InstantHitDamage(0)=35
	InstantHitDamage(1)=35
	WeaponFireTypes(0)=EWFT_InstantHit
	WeaponFireTypes(1)=EWFT_InstantHit
	InstantHitDamageTypes(0)=class'UTDmgType_ShockPrimary'
	InstantHitDamageTypes(1)=class'UTDmgType_ShockPrimary'
	FireInterval(0)=+3
	FireInterval(1)=+3
	ShotCost[0] = 0
	ShotCost[1] = 0
	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=0
	WeaponFireSnd[0]=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_FireCue'
	WeaponFireSnd[1]=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_FireCue'
	bCanThrow = False
}
