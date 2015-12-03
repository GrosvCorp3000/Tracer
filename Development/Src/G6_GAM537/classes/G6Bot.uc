class G6Bot extends UTBot;

var float AggroDistance;
var float EscapeDistance;
var float AttackDistance;
var float approachDistance;
var float RetreatDistance;
var float PatrolPointReachedThreshold;
var int FleeModifer;
var G6PatrolPath NextPatrolPoint;
var G6Spawner MySpawner;

var Actor _intermediate;
var float _dist;

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
	local int random;
	random = Rand(5);
	AttackDistance += random * 60;
	AggroDistance += random * 80;
	approachDistance += random * 50;

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
	local vector fleeLocation;
	local int fleeChaos;
	local int fleeDirection;
Begin:
	if (Enemy != None && Pawn != None)
	{
		_dist = VSize(Enemy.Location - Pawn.Location);
		if (!FastTrace(Enemy.Location, Pawn.location) || _dist > EscapeDistance)
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
		else if (FastTrace(Enemy.Location, Pawn.location) && _dist <= AttackDistance)
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
	AggroDistance=800
	EscapeDistance=1200
	AttackDistance=600
	approachDistance=350
	RetreatDistance=100
	FleeModifer=1
}