class G6Bot_Grenadier extends G6Bot;

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
			fleeDirection = Rand(2);
			fleeChaos = Rand(5);
			if (fleeDirection == 1) {
				fleeLocation.X = Enemy.Location.X + 100 * fleeChaos * FleeModifer;
				fleeLocation.Y = Enemy.Location.Y + 100 * fleeChaos * FleeModifer;
			} else {
				fleeLocation.X = Enemy.Location.X - 100 * fleeChaos * FleeModifer;
				fleeLocation.Y = Enemy.Location.Y - 100 * fleeChaos * FleeModifer;
			}
			fleeLocation.Z = Enemy.Location.Z;
			MoveTo(fleeLocation);
		}
		else if (_dist <= AttackDistance)
		{
			if (Pawn.Weapon != Pawn.InvManager.GetBestWeapon())
				SwitchToBestWeapon();
			FireWeaponAt(Enemy);
		}
		else
		{
			if (ActorReachable(Enemy) && _dist > approachDistance)
			{
				MoveToward(Enemy);
			}
			else
			{
				_intermediate = FindPathToward(Enemy);
				MoveToward(Enemy);
			}
		}
	}
	LatentWhatToDoNext();
}

DefaultProperties
{
	PatrolPointReachedThreshold=50
	AggroDistance=900
	EscapeDistance=1700
	AttackDistance=800
	approachDistance=500
	RetreatDistance=300
}
