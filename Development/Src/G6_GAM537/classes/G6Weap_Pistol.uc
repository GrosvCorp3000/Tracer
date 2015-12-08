class G6Weap_Pistol extends UTWeapon;

simulated function WeaponEmpty(){}

simulated function bool HasAnyAmmo()
{
	return true;
}

function bool canStillFire()
{
	return True;
}

simulated function Projectile ProjectileFire()
{
	local Array<vector> RealStartLoc;
	local Array<Projectile>	SpawnedProjectile;
	local rotator tRotator;
	local int i;
	local G6PlayerController p;
	
	p = G6PlayerController (Instigator.Controller);

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		RealStartLoc[0] = GetPhysicalFireStartLoc();
		if (p!=None && p.skills[4] == 1 && p.skills[14] == 1 && p.skills[9] == 1)
		{
			tRotator = GetAdjustedAim(RealStartLoc[0]);
			tRotator.Yaw = tRotator.Yaw + 3000;
			RealStartLoc[1] = RealStartLoc[0] + vector(tRotator) * 100;
			tRotator.Yaw = tRotator.Yaw - 6000;
			RealStartLoc[2] = RealStartLoc[0] + vector(tRotator) * 100;
		}

		// Spawn projectile
		for (i=0; i<RealStartLoc.Length; i++) {
			SpawnedProjectile[i] = Spawn(GetProjectileClass(),,, RealStartLoc[i]);
			if( SpawnedProjectile[i] != None && !SpawnedProjectile[i].bDeleteMe )
			{
				SpawnedProjectile[i].Init( Vector(GetAdjustedAim( RealStartLoc[i] )) );
			}
		}

		// Return it up the line
		return SpawnedProjectile[0];
	}

	return None;
}

simulated function vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	return Instigator.Location;
}

defaultproperties
{
	WeaponColor=(R=255,G=0,B=0,A=255)
	FireInterval(0)=+0.18
	PlayerViewOffset=(X=16.0,Y=-18,Z=-18.0)

	AttachmentClass=class'G6Attachment_Pistol'

	FireOffset=(X=12,Y=10,Z=-10)

	WeaponFireTypes(0)=EWFT_Projectile
	WeaponProjectiles(0)=class'G6Proj_Pistol' // UTProj_LinkPowerPlasma if linked (see GetProjectileClass() )

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
