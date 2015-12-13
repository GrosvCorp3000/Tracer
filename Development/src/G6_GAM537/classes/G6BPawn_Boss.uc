class G6BPawn_Boss extends G6BPawn;

var bool check1, check2, check3;

function bool Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local G6PlayerController PC;
	local G6Spawner_BossWave S;

	foreach AllActors( class'G6PlayerController', PC )
	{
		PC.KillAllEnemiesNoBoss();
	}

	foreach AllActors( class'G6Spawner_BossWave', S )
	{
		S.bSpawn = False;
	}
	Super.Died(Killer, damageType, HitLocation);

	return false;
}

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local float HealthPercent;
	local G6Spawner_BossWave S;

	HealthPercent = Health / float(HealthMax);

	if (HealthPercent < 0.75 && check1) {
		foreach AllActors( class'G6Spawner_BossWave', S )
		{
			S.BotsToSpawn = 2;
			S.enemyGroup = 1;
			S.bSpawn = True;
		}
		check1 = False;
	} else if (HealthPercent < 0.5 && check2) {
		foreach AllActors( class'G6Spawner_BossWave', S )
		{
			S.BotsToSpawn = 1;
			S.enemyGroup = 2;
			S.bSpawn = True;
		}	
		check2 = False;
	} else if (HealthPercent < 0.25 && check3) {
		foreach AllActors( class'G6Spawner_BossWave', S )
		{
			S.BotsToSpawn = 3;
			S.enemyGroup = 3;
			S.bSpawn = True;
		}
		check3 = False;
	}
	
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
	Mesh.SetSkeletalMesh(SkeletalMesh'VH_Manta.Mesh.SK_VH_Manta');

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

DefaultProperties
{
	Begin Object Class=SpotLightComponent Name=MyFlashLight
		Brightness=15.0
		LightColor=(R=255,G=0,B=0)
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

	RotationRate=(Pitch=80000,Yaw=80000,Roll=80000)
	GroundSpeed=950
	Mass = 500
	Health=2500
	HealthMax=2500

	check1 = true
	check2 = true
	check3 = true
}
