class G6BWeap_BossRocket extends UTWeap_RocketLauncher_Content;

simulated function Projectile ProjectileFire()
{
	local Array<vector> RealStartLoc;
	local Array<Projectile>	SpawnedProjectile;
	local rotator tRotator;
	local int i;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		RealStartLoc[0] = GetPhysicalFireStartLoc();
		tRotator = GetAdjustedAim(RealStartLoc[0]);
		tRotator.Yaw = tRotator.Yaw + 3000;
		RealStartLoc[1] = RealStartLoc[0] + vector(tRotator) * 100;
		tRotator.Yaw = tRotator.Yaw + 3000;
		RealStartLoc[2] = RealStartLoc[0] + vector(tRotator) * 100;
		tRotator.Yaw = tRotator.Yaw - 9000;
		RealStartLoc[3] = RealStartLoc[0] + vector(tRotator) * 100;
		tRotator.Yaw = tRotator.Yaw - 3000;
		RealStartLoc[4] = RealStartLoc[0] + vector(tRotator) * 100;

		// Spawn projectile
		for (i=0; i<RealStartLoc.Length; i++) {
			SpawnedProjectile[i] = Spawn(GetProjectileClass(),,, RealStartLoc[i]);
			if( SpawnedProjectile[i] != None && !SpawnedProjectile[i].bDeleteMe )
			{
				SpawnedProjectile[i].Init( Vector(GetAdjustedAim( RealStartLoc[i] )) );
			}
		}

		// Return it up the line
		return SpawnedProjectile[1];
	}

	return None;
}

simulated function vector GetPhysicalFireStartLoc(optional vector AimDir)
{
	return Instigator.Location;
}

function byte BestMode()
{
	return 0;
}

simulated function bool HasAnyAmmo(){
	return true;
}

DefaultProperties
{
	AmmoCount=50
	MaxAmmoCount=50
	ShotCost[0]=0

	GrenadeSpreadDist=50

	FireInterval[0] = 2;
	FireInterval[1] = 2;

	SpreadDist=350

	WeaponProjectiles(0)=class'G6BProj_BossRocket'
	WeaponProjectiles(1)=class'G6BProj_BossRocket'
	LoadedRocketClass=class'G6BProj_BossRocket'
	SeekingRocketClass=class'G6BProj_BossRocket'

	bCanThrow = False
}
