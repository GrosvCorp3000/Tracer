class G6BPawn_Boomer extends G6BPawn;

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
	Mesh.SetSkeletalMesh(SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA');
	//SkeletalMesh'VH_Cicada.Mesh.SK_VH_Cicada'
	//Mesh.SetSkeletalMesh(SkeletalMesh'VH_Hoverboard.Mesh.SK_VH_Hoverboard');
	//SkeletalMesh'VH_Hoverboard.Mesh.SK_VH_Hoverboard'
	//Mesh.SetSkeletalMesh(SkeletalMesh'KismetGame_Assets.Anims.SK_Jazz');
	//SkeletalMesh'KismetGame_Assets.Anims.SK_Turtle'
	//SkeletalMesh'KismetGame_Assets.Anims.SK_TurtleBomb_01'
	//SkeletalMesh'KismetGame_Assets.Anims.SK_SnakeGib'
	//SkeletalMesh'FoliageDemo.Animated.SP_Bird1_SKMesh'
    //Mesh.SetSkeletalMesh(SkeletalMesh'KismetGame_Assets.Anims.SK_Jazz');
	//SkeletalMesh'VH_Manta.Mesh.SK_VH_Manta'
	//SkeletalMesh'VH_Scorpion.Mesh.SK_VH_Scorpion_001'

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
	Begin Object Class=PointLightComponent Name=MyLight
		Brightness=6.0
		LightColor=(R=255,G=0,B=0)
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

	//HearingThreshold=+5000.0
	GroundSpeed=200
	Mass = 500
	Health=80
	HealthMax=80
	RotationRate=(Pitch=250000,Yaw=250000,Roll=250000)
}
