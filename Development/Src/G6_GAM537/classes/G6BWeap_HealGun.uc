class G6BWeap_HealGun extends UTWeap_LinkGun;

function bool CanAttack(Actor Other)
{
	return vsize(other.Location - instigator.Location) <= WeaponRange;
}

function byte BestMode()
{
	return 1;
}

simulated function UpdateBeam(float DeltaTime)
{
	local Vector		StartTrace, EndTrace, AimDir;
	local ImpactInfo	RealImpact, NearImpact;
	local G6BPawn B;
	local G6BPawn target;
	local float dist, shortest;

	// define range to use for CalcWeaponFire()
	StartTrace	= Instigator.GetWeaponStartTraceLocation();
	AimDir = Vector(GetAdjustedAim( StartTrace ));
	EndTrace	= StartTrace + AimDir * 300;

	foreach AllActors( class'G6BPawn', B )
	{
		dist = VSize(B.Location - EndTrace);
		if (B.IsAliveAndWell() && dist < 200) {
			if (target == none || dist < shortest) {
				target = B;
				shortest = dist;
			}
		}
	}
	
	if (target != None)
		EndTrace = target.Location;

	target = None;

	// Trace a shot
	RealImpact = CalcWeaponFire( StartTrace, EndTrace );
	bUsingAimingHelp = false;

	if ( (RealImpact.HitActor == None) || !RealImpact.HitActor.bProjTarget )
	{
		// console aiming help
		NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);

	}
	if ( NearImpact.HitActor != None )
	{
		bUsingAimingHelp = true;
		ProcessBeamHit(StartTrace, AimDir, NearImpact, DeltaTime);
		UpdateBeamEmitter(NearImpact.HitLocation, NearImpact.HitNormal, NearImpact.HitActor);
	}
	else
	{
		// Allow children to process the hit
		ProcessBeamHit(StartTrace, AimDir, RealImpact, DeltaTime);
		UpdateBeamEmitter(RealImpact.HitLocation, RealImpact.HitNormal, RealImpact.HitActor);
	}
}

DefaultProperties
{
	AttachmentClass=class'G6BAttach_HealGun'
	/*
	InstantHitDamage(0)=0
	InstantHitDamageTypes(0)=class'UTDmgType_LinkBeam'
	FiringStatesArray(0)=WeaponBeamFiring
	*/
	FireInterval(0)=+1
	FireInterval(1)=+1
	ShotCost[0] = 0
	ShotCost[1] = 0
	WeaponRange=550
	AmmoCount = 500
	MaxAmmoCount = 500
	BeamAmmoUsePerSecond=0.5
	MomentumTransfer=500.0

	bCanThrow = False
}
