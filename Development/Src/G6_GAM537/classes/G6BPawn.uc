class G6BPawn extends UTPawn;

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local G6PlayerController P;
	local G6Bot_Healer B;

	P = G6PlayerController (EventInstigator);
	B = G6Bot_Healer (EventInstigator);

	if (P==None) {
		Damage = Damage * 0.25;
	} else if (P!=None && !P.bSpecial && P.skills[7]==1) {
		P.cSpecial = clamp(P.cSpecial + float (Damage) * 0.05, 0, 100);
	}

	if (B!=None)
		Health = Clamp(Health + 2, 0, HealthMax);
	
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

DefaultProperties
{
	RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
	Health=100
	HealthMax=100
	GroundSpeed=500
	JumpZ=+00450.000000
}
