class G6Bot_Grenadier extends G6Bot;

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
	AggroDistance=900
	EscapeDistance=1700
	AttackDistance=800
	approachDistance=600
	RetreatDistance=350
}
