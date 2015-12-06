class G6BPawn_Healer extends G6BPawn;

DefaultProperties
{
	Begin Object Class=PointLightComponent Name=MyLight
		Brightness=6.0
		LightColor=(R=0,G=255,B=0)
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
	GroundSpeed=600
	RotationRate=(Pitch=10000,Yaw=10000,Roll=10000)

	Health=150
	HealthMax=150
	Mass=150
}
