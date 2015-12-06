class G6BWeap_GrenadeLauncher_Content extends UTWeap_RocketLauncher_Content;

simulated function bool HasAnyAmmo(){
	return true;
}

DefaultProperties
{
	AmmoCount=50
	MaxAmmoCount=50
	ShotCost[0]=0

	GrenadeSpreadDist=50

	FireInterval[0] = 2.5;
	FireInterval[1] = 2.5;

	SpreadDist=350

	WeaponProjectiles(0)=class'G6BProj_Grenade'
	WeaponProjectiles(1)=class'G6BProj_Grenade'
	LoadedRocketClass=class'G6BProj_Grenade'
	SeekingRocketClass=class'G6BProj_Grenade'

	bCanThrow = False
}
