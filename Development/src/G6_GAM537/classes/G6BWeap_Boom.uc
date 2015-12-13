class G6BWeap_Boom extends UTWeap_RocketLauncher_Content;

DefaultProperties
{
	AttachmentClass=class'G6BAttach_Boom'
	AmmoCount=50
	MaxAmmoCount=50
	ShotCost[0]=0

	GrenadeSpreadDist=200

	FireInterval[0] = 0.1;
	FireInterval[1] = 0.1;

	SpreadDist=300

	WeaponProjectiles(0)=class'G6BProj_Boom'
	WeaponProjectiles(1)=class'G6BProj_Boom'
	LoadedRocketClass=class'G6BProj_Boom'
	SeekingRocketClass=class'G6BProj_Boom'

	bCanThrow = False
}
