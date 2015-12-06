class G6Bot_Rocker extends G6Bot;

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
	AggroDistance=800
	EscapeDistance=1500
	AttackDistance=700
	approachDistance=500
	RetreatDistance=300
	FleeModifer=2
}
