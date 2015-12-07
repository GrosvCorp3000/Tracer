class G6Pawn extends UTPawn;

var UTWeapon preHeld;

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local G6PlayerController P;
	local G6Bot B;

	P = G6PlayerController (Controller);
	B = G6Bot (EventInstigator);

	if (P!=None && B!=None && !P.bSpecial) {
		if (P.skills[2]==1)
			P.cSpecial = clamp(P.cSpecial + float (Damage) * 0.22, 0, 100);
		else
			P.cSpecial = clamp(P.cSpecial + float (Damage) * 0.12, 0, 100);
	}
	
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
	local G6PlayerController p;
	p = G6PlayerController (Controller);

	if (p != None && p.bSkinType)
		Mesh.SetSkeletalMesh(SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA');
		//Mesh.SetSkeletalMesh(SkeletalMesh'VH_Manta.Mesh.SK_VH_Manta');
	else
		Mesh.SetSkeletalMesh(SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode');

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (VerifyBodyMaterialInstance())
		{
			BodyMaterialInstances[0].SetParent(HeadMaterial);
			if (BodyMaterialInstances.length > 1)
			{
			   BodyMaterialInstances[1].SetParent(BodyMaterial);
			}
		}
		else
		{
			`log("VerifyBodyMaterialInstance failed on pawn"@self);
		}
	}
}

simulated function StartFire(byte FireModeNum)
{
	local G6PlayerController PC;
	PC = G6PlayerController(Controller);
	
	if(PC.bRespawning && bFeigningDeath && PC.bBattleMode){
		PC.bRespawn = true;
	}
	if( bNoWeaponFIring )
	{
		return;
	}

	if( Weapon != None )
	{
		Weapon.StartFire(FireModeNum);
	}
}

function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local G6PlayerController PC;
	PC = G6PlayerController(Controller);

	if (PC != None)
	{
		if (PC.bSpecial)
			PC.toggleSpecial();
		PC.cSpecial *= 0.6;
		PC.roomSpawns[16] = 1;
		PC.AttemptRespawn();
	}
	return false;
}

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local G6PlayerController p;
	local UTWeapon curHeld;
	p = G6PlayerController (Controller);

	if (p != None && p.Pawn != None) {	
		out_CamLoc = p.Pawn.Location + p.camOffset;
		out_CamRot = rotator(normal(p.Pawn.Location - out_CamLoc));

		if(p.skills[11] == 1){
			GroundSpeed = 1200;
		}else if(p.skills[10] == 1){
			GroundSpeed = 1000;
		}

		if(p.skills[1] == 1){
			HealthMax = 500;
		}else if(p.skills[0] == 1){
			HealthMax = 400;
		}
	
		if(p.skills[6] == 1){
			p.cEnergyMax = 300;
		}else if(p.skills[5] == 1){
			p.cEnergyMax = 200;
		}

		if(p.skills[3] == 1){
			if(p.Pawn.FindInventoryType(class'G6Weap_Laser') == None){
				InvManager.CreateInventory(class'G6Weap_Laser');
			}
		}

		if(p.skills[8] == 1){
			if(p.Pawn.FindInventoryType(class'G6Weap_Shotgun') == None){
				InvManager.CreateInventory(class'G6Weap_Shotgun');
			}
		}

		if(p.skills[13] == 1){
			if(p.Pawn.FindInventoryType(class'G6Weap_RocketLauncher_Content') == None){
				InvManager.CreateInventory(class'G6Weap_RocketLauncher_Content');
			}
		}
		
		curHeld = UTWeapon (Weapon);
		curHeld.MaxAmmoCount = p.cEnergyMax;
		if(curHeld != preHeld){
			curHeld.AmmoCount = p.cEnergy;
			p.StopFire();
		}else if(p.bBattleMode){
			p.cEnergy = curHeld.AmmoCount;
		}else{
			curHeld.AmmoCount = p.cEnergy;
		}

		preHeld = curHeld;

		if(!p.bBattleMode){
			if(Health < HealthMax){
				Health++;
			}
			if(p.cEnergy < p.cEnergyMax){
				p.cEnergy++;
			}
		}
	}
	return true;
}

function PossessedBy(Controller C, bool bVehicleTransition) {
	local G6PlayerController PC;

	super.PossessedBy(C, bVehicleTransition);

	PC = G6PlayerController(C);
	if (PC != None)
	{
		InvManager.CreateInventory(class'G6Weap_Pistol');
		//InvManager.CreateInventory(class'G6BWeap_BossRocket');
		//InvManager.CreateInventory(class'G6Weap_Laser');
		//InvManager.CreateInventory(class'G6Weap_Shotgun');
		//InvManager.CreateInventory(class'G6Weap_RocketLauncher_Content');
		//InvManager.CreateInventory(class'UTWeap_ShockRifle');

		//Why doesn't this work?
		PC.SwitchWeapon(1);
		
	}
}

DefaultProperties
{
	Begin Object Class=SpotLightComponent Name=MyFlashLight
		Brightness=20.0
		LightColor=(R=255,G=255,B=255)
		Radius=768.0
		InnerConeAngle=0
		OuterConeAngle=22
		LightShaftConeAngle=55
		bEnabled=TRUE

		// for now we are leaving this as people may be depending on it in script and we just
		// set the specific default settings in each light as they are all pretty different
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bCastCompositeShadow=FALSE
		bAffectCompositeShadowDirection=FALSE
		bForceDynamicLight=FALSE
		UseDirectLightMap=FALSE
		bPrecomputedLightingIsValid=TRUE
	End Object
	Components.Add(MyFlashLight)

	Begin Object Class=PointLightComponent Name=MyLight
		Brightness=8.0
		LightColor=(R=255,G=255,B=255)
		Radius=70.0
		bEnabled=TRUE

		// for now we are leaving this as people may be depending on it in script and we just
		// set the specific default settings in each light as they are all pretty different
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bCastCompositeShadow=FALSE
		bAffectCompositeShadowDirection=FALSE
		bForceDynamicLight=FALSE
		UseDirectLightMap=FALSE
		bPrecomputedLightingIsValid=TRUE
	End Object
	Components.Add(MyLight)

	RotationRate=(Pitch=120000,Yaw=120000,Roll=120000)
	Health = 300
	HealthMax = 300
	GroundSpeed = 800
	Mass = 380
	JumpZ=+00450.000000
}
