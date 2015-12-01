class G6Bot_Grenadier extends UTBot;

var float AggroDistance;
var float EscapeDistance;
var float AttackDistance;
var float PatrolPointReachedThreshold;
var G6PatrolPath NextPatrolPoint;
var G6Spawner MySpawner;

var private Actor _intermediate;
var private float _dist;

function EnterPatrolPath(G6PatrolPath path)
{
	NextPatrolPoint = path;
	MySpawner = G6Spawner(path);

	if (path != None)
	{
		if (!IsInState('FollowingPatrolPath'))
		{
			GotoState('FollowingPatrolPath');
		}
	}
	else
	{
		GotoState('');
	}
}

/*
function PawnDied(Pawn p)
{
	if (MySpawner != None)
		MySpawner.BotsToSpawn++;
	super.PawnDied(p);
}
*/

function HuntEnemy(Pawn p)
{
	if (P == None) return;
	Enemy = P;
	Focus = P;
	GotoState('HuntingPlayer', 'Begin');
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> damageType, Vector momentum)
{
	super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, damageType, Momentum);
	if (InstigatedBy != None && InstigatedBy.Pawn != None)
	{
		HuntEnemy(InstigatedBy.Pawn);
	}
}

function bool IsPawnTouchingActor(Actor other)
{
	if (other == None || Pawn == None) return false;

	return VSize(other.Location - Pawn.Location) <= PatrolPointReachedThreshold;
}

protected event ExecuteWhatToDoNext()
{
	local PlayerController pc;

	if (Pawn == None)
	{
		Destroy();
		return;
	}

	// Should we chase and attack the player?
	pc = GetALocalPlayerController();
	if (pc != None && pc.Pawn != None && VSize(Pawn.Location - pc.pawn.Location) <= AggroDistance)
	{
		HuntEnemy(Pc.Pawn);
		return;
	}

	// If not attacking, follow route
	if (NextPatrolPoint != None)
	{
		if (IsPawnTouchingActor(NextPatrolPoint))
		{
			NextPatrolPoint = NextPatrolPoint.NextNode;
		}

		if (NextPatrolPoint != None) GotoState('FollowingPatrolPath', 'Begin');
	}
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	super.Possess(aPawn, bVehicleTransition);
	if (NextPatrolPoint != None)
		GotoState('FollowingPatrolPath', 'Begin');
}

auto state FollowingPatrolPath
{
Begin:
	if (NextPatrolPoint != None)
	{
		if (ActorReachable(NextPatrolPoint))
		{
			MoveToward(NextPatrolPoint);
		}
		else
		{
			_intermediate = FindPathToward(NextPatrolPoint);
			MoveToward(_intermediate);
		}
	}

	LatentWhatToDoNext();
}

state HuntingPlayer
{
Begin:
	if (Enemy != None && Pawn != None)
	{
		_dist = VSize(Enemy.Location - Pawn.Location);
		if (!FastTrace(Enemy.Location, Pawn.location) && _dist > EscapeDistance)
		{
			Enemy = None;
		}
		else if (_dist <= AttackDistance)
		{
			if (Pawn.Weapon != Pawn.InvManager.GetBestWeapon())
				SwitchToBestWeapon();
			FireWeaponAt(Enemy);
		}
		else
		{
			if (ActorReachable(Enemy))
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
	AggroDistance=1000
	EscapeDistance=1800
	AttackDistance=900
}
