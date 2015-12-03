class G6BPawn_Sniper extends G6BPawn;

DefaultProperties
{
	Begin Object Class=PointLightComponent Name=MyLight
		Brightness=5.0
		LightColor=(R=0,G=0,B=255)
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
	GroundSpeed=5000
	RotationRate=(Pitch=150000,Yaw=150000,Roll=150000)

	Health=120
	HealthMax=120
}