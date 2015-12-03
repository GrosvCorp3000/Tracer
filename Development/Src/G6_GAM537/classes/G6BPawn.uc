class G6BPawn extends UTPawn;

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local G6PlayerController P;

	P = G6PlayerController (EventInstigator);

	if (P==None)
		Damage = Damage * 0.25;
	
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

DefaultProperties
{
	Health=80
	HealthMax=80
}
