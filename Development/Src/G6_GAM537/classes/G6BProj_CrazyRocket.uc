class G6BProj_CrazyRocket extends UTProj_Rocket;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.3, true);
}

function Timer()
{
	local rotator r;
	local int rad1, rad2, rad3, rad4;
	r = self.Rotation;
	rad1 = Rand(2);
	rad2 = Rand(5);
	rad3 = Rand(10);
	rad4 = Rand(2);
    if (rad1 == 1)
    {
		r.Yaw += rad2 * 5000 - rad3 * 700 * rad4;
		speed += rad2 * 200 - rad3 * 10 * rad4;
		MaxSpeed += rad2 * 200 - rad3 * 10 * rad4;
    }
	else
	{
		r.Yaw -= rad2 * 5000 + rad3 * 700 * rad4;
		speed -= rad2 * 100 + rad3 * 10 * rad4;
		MaxSpeed -= rad2 * 100 + rad3 * 10 * rad4;
	}
	self.SetRotation(r);
	Velocity = Speed * Vector(r);
	Velocity.Z += TossZ;
	Acceleration = AccelRate * Normal(Velocity);
}

DefaultProperties
{
	speed=800.0
	MaxSpeed=1000.0
	Damage=55.0
	DamageRadius=250.0
	MomentumTransfer=75000
}
