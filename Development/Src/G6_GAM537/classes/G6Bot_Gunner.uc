class G6Bot_Gunner extends G6Bot;

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	local int random;
	random = Rand(5);
	AttackDistance += random * 60;
	AggroDistance += random * 80;
	approachDistance += random * 50;
	RetreatDistance += random * 20;

	super.Possess(aPawn, bVehicleTransition);
	if (NextPatrolPoint != None)
		GotoState('FollowingPatrolPath', 'Begin');
}

DefaultProperties
{
	PatrolPointReachedThreshold=50
	AggroDistance=600
	EscapeDistance=1500
	AttackDistance=380
	approachDistance=100
	RetreatDistance=50
}
