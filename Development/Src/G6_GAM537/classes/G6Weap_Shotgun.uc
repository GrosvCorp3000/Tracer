class G6Weap_Shotgun extends UTWeapon;

simulated function vector InstantFireStartTrace()
{
	return Instigator.GetWeaponStartTraceLocation();
}

simulated function Array<vector> InstantFireEndTraceA(Array<vector> StartTrace)
{
	local Array<vector> EndTrace;
	local color myColor;
	local G6PlayerController p;
	local rotator tRotator;
	
	p = G6PlayerController (Instigator.Controller);

	EndTrace[0] = StartTrace[0] + vector(GetAdjustedAim(StartTrace[0])) * GetTraceRange();
	myColor.R = 255;
	myColor.A = 255;
	if (p != None)
		p.myHUD.Draw3DLine(StartTrace[0], EndTrace[0], myColor);

	tRotator = GetAdjustedAim(StartTrace[1]);
	tRotator.Yaw = tRotator.Yaw + 2500;
	EndTrace[1] = StartTrace[1] + vector(tRotator) * GetTraceRange();
	myColor.B = 255;
	myColor.A = 255;
	if (p != None)
		p.myHUD.Draw3DLine(StartTrace[1], EndTrace[1], myColor);

	tRotator.Yaw = tRotator.Yaw - 5000;
	EndTrace[2] = StartTrace[2] + vector(tRotator) * GetTraceRange();
	myColor.G = 255;
	myColor.A = 255;
	if (p != None)
		p.myHUD.Draw3DLine(StartTrace[2], EndTrace[2], myColor);

	if (StartTrace.Length > 3)
	{
		tRotator = GetAdjustedAim(StartTrace[0]);
		tRotator.Yaw = tRotator.Yaw + 5000;
		EndTrace[3] = StartTrace[3] + vector(tRotator) * GetTraceRange();
		myColor.B = 255;
		myColor.R = 255;
		myColor.A = 255;
		if (p != None)
			p.myHUD.Draw3DLine(StartTrace[3], EndTrace[3], myColor);

		tRotator.Yaw = tRotator.Yaw - 10000;
		EndTrace[4] = StartTrace[4] + vector(tRotator) * GetTraceRange();
		myColor.R = 255;
		myColor.G = 255;
		myColor.A = 255;
		if (p != None)
			p.myHUD.Draw3DLine(StartTrace[4], EndTrace[4], myColor);
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
	
	volly = 3;

	p = G6PlayerController (Instigator.Controller);
	if (p != None && p.skills[9] == 1)
		volly = 5;

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
	FireInterval[0] = 0.8
	ShotCost[0] = 1
	WeaponFireAnim[0]=WeaponFire
	InstantHitDamage[0]=35
	InstantHitMomentum[0]=80000
	InstantHitDamageTypes[0]=class'UTDmgType_CicadaLaser'

	WeaponFireTypes[1] = EWFT_InstantHit
	FireInterval[1] = 0.8
	ShotCost[1] = 1
	WeaponFireAnim[1]=WeaponFire
	InstantHitDamage[1]=35
	InstantHitMomentum[1]=80000
	InstantHitDamageTypes[1]=class'UTDmgType_CicadaLaser'

	AttachmentClass=class'G6Attachment_Shotgun'

	InventoryGroup=3

	AmmoCount = 100
	MaxAmmoCount = 200

	WeaponRange = 300
}
