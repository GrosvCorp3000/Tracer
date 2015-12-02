class G6BWeap_GrenadeLauncher_Content extends G6Weap_RocketLauncher_Content;

DefaultProperties
{
	AmmoCount=50
	MaxAmmoCount=50
	ShotCost[0]=0

	GrenadeSpreadDist=50

	FireInterval[0] = 2;
	FireInterval[1] = 2;

	SpreadDist=500

	WeaponProjectiles(0)=class'G6BProj_Grenade'
	WeaponProjectiles(1)=class'G6BProj_Grenade'

	bCanThrow = False
}
