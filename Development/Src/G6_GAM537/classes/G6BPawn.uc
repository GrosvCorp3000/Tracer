class G6BPawn extends UTPawn;

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local G6PlayerController P;

	P = G6PlayerController (EventInstigator);

	if (P==None)
		Damage = Damage * 0.25;
	
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

/*
simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
	//Mesh.SetSkeletalMesh(SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA');
	Mesh.SetSkeletalMesh(SkeletalMesh'VH_Scorpion.Mesh.SK_VH_Scorpion_001');
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
*/

simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
{
	
	super.SetCharacterClassFromInfo(Info);
}

DefaultProperties
{
}
