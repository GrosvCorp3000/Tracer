class G6Weap_Shotgun extends UTWeapon;

simulated function WeaponEmpty(){}

simulated function bool HasAnyAmmo()
{
	local G6PlayerController p;
	p = G6PlayerController (Instigator.Controller);
	if(p.skills[8] == 1){
		return true;
	}else{
		return false;
	}
}

simulated function vector InstantFireStartTrace()
{
	return Instigator.GetWeaponStartTraceLocation();
}

simulated function Array<vector> InstantFireEndTraceA(Array<vector> StartTrace)
{
	local Array<vector> EndTrace;
	local rotator tRotator;

	EndTrace[0] = StartTrace[0] + vector(GetAdjustedAim(StartTrace[0])) * GetTraceRange();

	tRotator = GetAdjustedAim(StartTrace[1]);
	tRotator.Yaw = tRotator.Yaw + 2000;
	EndTrace[1] = StartTrace[1] + vector(tRotator) * GetTraceRange();

	tRotator.Yaw = tRotator.Yaw + 2000;
	EndTrace[2] = StartTrace[2] + vector(tRotator) * GetTraceRange();

	tRotator.Yaw = tRotator.Yaw - 6000;
	EndTrace[3] = StartTrace[3] + vector(tRotator) * GetTraceRange();

	tRotator.Yaw = tRotator.Yaw - 2000;
	EndTrace[4] = StartTrace[4] + vector(tRotator) * GetTraceRange();

	if (StartTrace.Length > 5)
	{
		tRotator = GetAdjustedAim(StartTrace[0]);
		tRotator.Yaw = tRotator.Yaw + 6000;
		EndTrace[5] = StartTrace[5] + vector(tRotator) * GetTraceRange();

		tRotator.Yaw = tRotator.Yaw - 12000;
		EndTrace[6] = StartTrace[6] + vector(tRotator) * GetTraceRange();

	}

	return EndTrace;
}

simulated function InstantFire()
{
	local Array<vector> StartTrace;
	local Array<vector> EndTrace;
	local Array<ImpactInfo>	ImpactList;
	local ImpactInfo RealImpact, NearImpact;
	local int i, j, k, volly, FinalImpactIndex;
	local G6PlayerController p;

	// define range to use for CalcWeaponFire()
	
	volly = 5;

	p = G6PlayerController (Instigator.Controller);
	if (p != None && p.skills[9] == 1)
		volly = 7;

	for (k=0; k<volly; k++) {
		StartTrace[k] = InstantFireStartTrace();
	}
	
	EndTrace = InstantFireEndTraceA(StartTrace);
	
	bUsingAimingHelp = false;

	// Perform shot
	for (j=0; j<StartTrace.Length; j++) 
	{
		ImpactList.Length=0;

		RealImpact = CalcWeaponFire(StartTrace[j], EndTrace[j], ImpactList);
		FinalImpactIndex = ImpactList.length - 1;

		if (FinalImpactIndex >= 0 && (ImpactList[FinalImpactIndex].HitActor == None || !ImpactList[FinalImpactIndex].HitActor.bProjTarget))
		{
			// console aiming help
			NearImpact = InstantAimHelp(StartTrace[j], EndTrace[j], RealImpact);
			if ( NearImpact.HitActor != None )
			{
				bUsingAimingHelp = true;
				ImpactList[FinalImpactIndex] = NearImpact;
			}
		}

		for (i = 0; i < ImpactList.length; i++)
		{
			ProcessInstantHit(CurrentFireMode, ImpactList[i]);
		}

		if (Role == ROLE_Authority)
		{
			// Set flash location to trigger client side effects.
			// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
			// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
			// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
			// would probably have to run a full simulation on remote clients.
			if ( NearImpact.HitActor != None )
			{
				SetFlashLocation(NearImpact.HitLocation);
			}
			else
			{
				SetFlashLocation(RealImpact.HitLocation);
			}
		}
	}
}

DefaultProperties
{
	WeaponFireTypes[0] = EWFT_InstantHit
	FireInterval[0] = 0.7
	ShotCost[0] = 5
	WeaponFireAnim[0]=WeaponFire
	InstantHitDamage[0]=38
	InstantHitMomentum[0]=100000
	InstantHitDamageTypes[0]=class'UTDmgType_CicadaLaser'
	WeaponFireSnd[0]=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_FireCue'

	WeaponFireTypes[1] = EWFT_InstantHit
	FireInterval[1] = 0.7
	ShotCost[1] = 5
	WeaponFireAnim[1]=WeaponFire
	InstantHitDamage[1]=38
	InstantHitMomentum[1]=100000
	InstantHitDamageTypes[1]=class'UTDmgType_CicadaLaser'
	WeaponFireSnd[1]=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_FireCue'
	
	WeaponEquipSnd=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_RaiseCue'
	MuzzleFlashSocket=MF
	MuzzleFlashPSCTemplate=WP_ShockRifle.Particles.P_ShockRifle_MF_Alt
	MuzzleFlashAltPSCTemplate=WP_ShockRifle.Particles.P_ShockRifle_MF_Alt
	MuzzleFlashColor=(R=200,G=120,B=255,A=255)
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'UTGame.UTShockMuzzleFlashLight'

	AttachmentClass=class'G6Attachment_Shotgun'

	InventoryGroup=3

	AmmoCount = 100
	MaxAmmoCount = 200

	WeaponRange = 350
}
