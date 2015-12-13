class G6BPawn_Rocker extends G6BPawn;

DefaultProperties
{
	Begin Object Class=PointLightComponent Name=MyLight
		Brightness=5.0
		LightColor=(R=255,G=192,B=203)
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
	GroundSpeed=1500
	RotationRate=(Pitch=150000,Yaw=150000,Roll=150000)

	Health=150
	HealthMax=150
	Mass=200
}
