class G6BPawn_ShockBaller extends G6BPawn;

DefaultProperties
{
	Begin Object Class=PointLightComponent Name=MyLight
		Brightness=5.0
		LightColor=(R=255,G=125,B=125)
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

	Health=120
	HealthMax=120
}
