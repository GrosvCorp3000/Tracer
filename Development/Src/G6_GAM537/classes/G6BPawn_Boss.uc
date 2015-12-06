class G6BPawn_Boss extends G6BPawn;

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
	GroundSpeed=850
	Mass = 500
	Health=1500
	HealthMax=1500
}
