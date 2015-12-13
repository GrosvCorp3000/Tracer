class G6Bot_Healer extends G6Bot;

var G6BPawn target;
var float targetDistance;

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	local int random;
	random = Rand(5);
	AttackDistance += random * 60;
	AggroDistance += random * 80;
	approachDistance += random * 50;

	super.Possess(aPawn, bVehicleTransition);
	if (NextPatrolPoint != None)
		GotoState('FollowingPatrolPath', 'Begin');
}

function G6BPawn findPatient()
{
	local G6BPawn l_target;
	local G6BPawn B;
	local G6BPawn_Healer H;
	local float lowestHealth;
	local float curTargetHealth;
	local float distance;

	lowestHealth = 1;

	foreach AllActors( class'G6BPawn', B )
	{
		H = G6BPawn_Healer (B);
		if (B!=Pawn && B.IsAliveAndWell() && H==None) {
			curTargetHealth = B.Health / float(B.HealthMax);
			distance = VSize(B.Location - Pawn.location);
			if (l_target == none) {
				l_target = B;
			} else if (curTargetHealth < lowestHealth && distance < 800) {
				l_target = B;
				lowestHealth = curTargetHealth;
			}
		}
	}
	return l_target;
}

state HuntingPlayer
{
Begin:
	if (Enemy != None && Pawn != None)
	{
		_dist = VSize(Enemy.Location - Pawn.Location);

		if (_dist > EscapeDistance)
		{
			_intermediate = FindPathToward(NextPatrolPoint);
			MoveToward(_intermediate);
		}
		else if (_dist < RetreatDistance)
		{
			MoveTo(determineFlee());
		}
		else 
		{
			target = findPatient();
			if (target != none)
			{
				targetDistance = VSize(target.Location - Pawn.location);
				if (FastTrace(target.Location, Pawn.location) && targetDistance <= AttackDistance) {
					FireWeaponAt(target);
				} else if (ActorReachable(target) && targetDistance > approachDistance) {
					MoveToward(Target);
				} else {
					_intermediate = FindPathToward(Target);
					MoveToward(_intermediate);
				}
			} else {
				MoveTo(determineFlee());
			}
		}
	}
	LatentWhatToDoNext();
}

function bool CanAttack(Actor Other)
{
	return true;
}

function bool FireWeaponAt(Actor A)
{
	Focus = A;
	return WeaponFireAgain(false);
}
		
DefaultProperties
{
	StrafingAbility=0.8
	PatrolPointReachedThreshold=50
	AggroDistance=950
	EscapeDistance=1300
	AttackDistance=500
	approachDistance=250
	RetreatDistance=200
}
