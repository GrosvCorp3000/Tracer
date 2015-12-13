class G6Bot_Boss extends G6Bot;

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	local int random;
	random = Rand(5);
	AggroDistance += random * 80;
	AttackDistance += random * 60;
	approachDistance += random * 50;

	super.Possess(aPawn, bVehicleTransition);
	if (NextPatrolPoint != None)
		GotoState('FollowingPatrolPath', 'Begin');
}

DefaultProperties
{
	PatrolPointReachedThreshold=50
	AggroDistance=1500
	EscapeDistance=2800
	AttackDistance=1200
	approachDistance=600
	RetreatDistance=350
	FleeModifer=2
}
