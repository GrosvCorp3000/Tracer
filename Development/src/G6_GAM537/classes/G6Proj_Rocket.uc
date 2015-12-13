/**
 * Copyright 1998-2015 Epic Games, Inc. All Rights Reserved.
 */
class G6Proj_Rocket extends UTProjectile;

simulated function PostBeginPlay()
{
	local G6PlayerController P;
	// force ambient sound if not vehicle game mode
	bImportantAmbientSound = !WorldInfo.bDropDetail;
	Super.PostBeginPlay();
	foreach AllActors( class'G6PlayerController', P )
	{
		if (P != None && P.skills[14] == 1)
			SetTimer(0.1, true);
	}	
}

function Timer()
{
	local G6BPawn target;
	local G6BPawn B;
	local float dist, shortest;
	local rotator adjusted;

	dist = 0;
	shortest = 0;

	foreach AllActors( class'G6BPawn', B )
	{
		dist = VSize(B.Location - Location);
		if (B.IsAliveAndWell() && dist < 500) {
			if (target == none || dist < shortest) {
				target = B;
				shortest = dist;
			}
		}
	}
	
	adjusted = self.Rotation;

	if (target != None)
	{
		adjusted = rotator(normal(target.Location - self.Location));
	}
	
	self.SetRotation(adjusted);
	Velocity = Speed * Vector(adjusted);
	Velocity.Z += TossZ;
	Acceleration = AccelRate * Normal(Velocity);

	target = None;
}

defaultproperties
{
	ProjFlightTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketTrail'
	ProjExplosionTemplate=ParticleSystem'WP_RocketLauncher.Effects.P_WP_RocketLauncher_RocketExplosion'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'
	DecalWidth=128.0
	DecalHeight=128.0
	speed=2500.0
	MaxSpeed=5000.0
	Damage=110.0
	DamageRadius=320.0
	MomentumTransfer=85000
	MyDamageType=class'UTDmgType_Rocket'
	LifeSpan=8.0
	AmbientSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Travel_Cue'
	ExplosionSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Impact_Cue'
	RotationRate=(Roll=50000)
	bCollideWorld=true
	CheckRadius=42.0
	bCheckProjectileLight=true
	ProjectileLightClass=class'UTGame.UTRocketLight'
	ExplosionLightClass=class'UTGame.UTRocketExplosionLight'

	bWaitForEffects=true
	bAttachExplosionToVehicles=false
}
