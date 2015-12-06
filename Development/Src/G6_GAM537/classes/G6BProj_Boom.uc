class G6BProj_Boom extends UTProj_Rocket;

var bool bAlive;

function Tick( float DeltaTime ) {
	if (bAlive && LifeSpan < 0.1)
	{
		self.Explode(Instigator.Location, Instigator.Location);
		bAlive = false;
	}
	super.Tick(DeltaTime);	
}


DefaultProperties
{
	speed=3500.0
	MaxSpeed=3500.0
	LifeSpan=0.1
	Damage=90.0
	DamageRadius=300.0
	bAlive=true
}
