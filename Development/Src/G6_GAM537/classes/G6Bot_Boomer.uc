class G6Bot_Boomer extends G6Bot;

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	local int random;
	random = Rand(5);
	AggroDistance += random * 80;
	AttackDistance = 120;
	approachDistance += random * 50;
	RetreatDistance += random * 20;

	super.Possess(aPawn, bVehicleTransition);
	if (NextPatrolPoint != None)
		GotoState('FollowingPatrolPath', 'Begin');
}

DefaultProperties
{
	CombatStyle=1
	PatrolPointReachedThreshold=50
	AggroDistance=850
	EscapeDistance=1100
	//AttackDistance=70
	approachDistance=0
	RetreatDistance=0
}
