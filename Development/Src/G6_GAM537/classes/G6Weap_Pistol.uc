class G6Weap_Pistol extends UTWeapon;

defaultproperties
{
	WeaponColor=(R=255,G=0,B=0,A=255)
	FireInterval(0)=+0.24
	PlayerViewOffset=(X=16.0,Y=-18,Z=-18.0)

	AttachmentClass=class'G6Attachment_Pistol'

	FireOffset=(X=12,Y=10,Z=-10)

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponProjectiles(0)=class'UTProj_LinkPlasma' // UTProj_LinkPowerPlasma if linked (see GetProjectileClass() )

	WeaponEquipSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_RaiseCue'
	WeaponPutDownSnd=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_LowerCue'
	WeaponFireSnd(0)=SoundCue'A_Weapon_Link.Cue.A_Weapon_Link_FireCue'

	MaxDesireability=0.7
	CurrentRating=+0.3
	bFastRepeater=true
	bInstantHit=false
	bSplashJump=false
	bRecommendSplashDamage=false
	bSniping=false
	ShouldFireOnRelease(0)=0
	InventoryGroup=1

	WeaponRange=500

	PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Link_Cue'

	AmmoCount=100
	LockerAmmoCount=100
	MaxAmmoCount=100
	ShotCost[0] = 0

	EffectSockets(0)=MuzzleFlashSocket

	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Primary'
	bMuzzleFlashPSCLoops=true
	MuzzleFlashLightClass=class'UTGame.UTLinkGunMuzzleFlashLight'

	bShowAltMuzzlePSCWhenWeaponHidden=TRUE

	MuzzleFlashColor=(R=120,G=255,B=120,A=255)
	MuzzleFlashDuration=0.33;

	IconX=412
	IconY=82
	IconWidth=40
	IconHeight=36

	LockerRotation=(pitch=0,yaw=0,roll=-16384)
	IconCoordinates=(U=453,V=467,UL=147,VL=41)
}
