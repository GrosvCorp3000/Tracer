class G6BPawn_ShockBaller extends G6BPawn;

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
	//Mesh.SetSkeletalMesh(SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA');
	//SkeletalMesh'VH_Cicada.Mesh.SK_VH_Cicada'
	Mesh.SetSkeletalMesh(SkeletalMesh'VH_Hoverboard.Mesh.SK_VH_Hoverboard');
	//SkeletalMesh'VH_Hoverboard.Mesh.SK_VH_Hoverboard'
	//Mesh.SetSkeletalMesh(SkeletalMesh'VH_Scorpion.Mesh.SK_VH_Scorpion_001');
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
		LightColor=(R=0,G=128,B=128)
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

	GroundSpeed=800
	RotationRate=(Pitch=80000,Yaw=80000,Roll=80000)

	Health=130
	HealthMax=130
}
