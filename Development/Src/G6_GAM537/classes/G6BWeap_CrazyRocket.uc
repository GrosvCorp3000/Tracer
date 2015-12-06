class G6BWeap_CrazyRocket extends UTWeap_RocketLauncher_Content;

DefaultProperties
{
	AttachmentClass=class'G6BAttach_CrazyRocket'
	AmmoCount=50
	MaxAmmoCount=50
	ShotCost[0]=0

	GrenadeSpreadDist=200

	FireInterval[0] = 2.5;
	FireInterval[1] = 2.5;

	SpreadDist=300

	WeaponProjectiles(0)=class'G6BProj_CrazyRocket'
	WeaponProjectiles(1)=class'G6BProj_CrazyRocket'
	LoadedRocketClass=class'G6BProj_CrazyRocket'
	SeekingRocketClass=class'G6BProj_CrazyRocket'

	bCanThrow = False
}
