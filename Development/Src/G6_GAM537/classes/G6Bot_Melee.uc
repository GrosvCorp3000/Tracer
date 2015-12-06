class G6Bot_Melee extends G6Bot;

var int randTaunt;
var int randTaunt2;

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	local int random;
	random = Rand(5);
	AggroDistance += random * 80;
	AttackDistance = 90;

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
		else if (!FastTrace(Enemy.Location, Pawn.location) || _dist < RetreatDistance)
		{
			MoveTo(determineFlee());
		}
		else if (FastTrace(Enemy.Location, Pawn.location) && _dist <= AttackDistance)
		{
			if (Pawn.Weapon != Pawn.InvManager.GetBestWeapon())
				SwitchToBestWeapon();
			FireWeaponAt(Enemy);

			randTaunt = Rand(3);
			randTaunt2 = Rand(2);
			if (randTaunt == 0) {
				G6BPawn (Pawn).PlayEmote('TauntA', -1);
			} else if (randTaunt == 1) {
				G6BPawn (Pawn).PlayEmote('TauntB', -1);
			} else {
				G6BPawn (Pawn).PlayEmote('TauntC', -1);
			}
			RetreatDistance = randTaunt * 50 * randTaunt2;
			randTaunt = Rand(3);
			approachDistance = randTaunt * 30 * randTaunt2 * randTaunt2;
			if (randTaunt==0 && randTaunt2==0)
				MoveToward(Enemy);
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
	AggroDistance=300
	EscapeDistance=600
	approachDistance=0
	RetreatDistance=0
}
