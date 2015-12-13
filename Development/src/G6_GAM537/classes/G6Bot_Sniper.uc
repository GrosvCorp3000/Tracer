class G6Bot_Sniper extends G6Bot;

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

DefaultProperties
{
	PatrolPointReachedThreshold=50
	AggroDistance=1000
	EscapeDistance=1700
	AttackDistance=800
	approachDistance=500
	RetreatDistance=250
	FleeModifer=2
	CombatStyle=-1
}
