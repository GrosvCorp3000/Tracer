class G6Spawner_BossWave extends G6PatrolPath
	placeable
	ClassGroup(GROUP6);

var int BotsToSpawn;
var(Spawner) float SpawnInterval;

var bool bSpawn;
var int enemyGroup;


function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(SpawnInterval, true);
}


function Timer()
{
	local int random;

	random = Rand(10);

	if (!bSpawn || BotsToSpawn <= 0 || random < 5)
		return;

	if (SpawnBot() != None)	BotsToSpawn--;
}

function UTBot SpawnBot()
{
	local UTBot NewBot;
	local G6PlayerController P;
	local Pawn NewPawn;
	local rotator StartRotation;

	switch (enemyGroup)
	{
		case 1:
			NewBot = Spawn(class'G6Bot_Sniper');
			break;
		case 2:
			NewBot = Spawn(class'G6Bot_Healer');
			break;
		case 3:
			NewBot = Spawn(class'G6Bot_Rocker');
			break;
		default:
			NewBot = Spawn(class'G6Bot_Rocker');
			break;
	}

	if (NewBot == None)
	{
		`log("Couldn't spawn at "$self);
		return None;
	}

	StartRotation = Rotation;
	StartRotation.Yaw = Rotation.Yaw;

	switch (enemyGroup)
	{
		case 1:
			NewPawn = Spawn(class'G6BPawn_Sniper',,,Location,StartRotation);
			break;
		case 2:
			NewPawn = Spawn(class'G6BPawn_Healer',,,Location,StartRotation);
			break;
		case 3:
			NewPawn = Spawn(class'G6BPawn_Rocker',,,Location,StartRotation);
			break;
		default:
			NewPawn = Spawn(class'G6BPawn_Rocker',,,Location,StartRotation);
			break;
	}

	if ( NewPawn == None )
	{
		`log("Couldn't spawn "$class'UTPawn'$" at "$self);
		NewBot.Destroy();
		return None;
	}

	NewPawn.SetAnchor(self);
	NewPawn.LastStartTime = WorldInfo.TimeSeconds;
	NewBot.Possess(NewPawn, false);
	NewBot.Pawn.PlayTeleportEffect(true, true);
	NewBot.ClientSetRotation(NewBot.Pawn.Rotation, TRUE);
	WorldInfo.Game.AddDefaultInventory(NewPawn);
	WorldInfo.Game.SetPlayerDefaults(NewPawn);

	switch (enemyGroup)
	{
		case 1:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_Rifle');
			G6Bot_Sniper (NewBot).EnterPatrolPath(self);
			break;
		case 2:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_HealGun');
			G6Bot_Healer (NewBot).EnterPatrolPath(self);
			break;
		case 3:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_CrazyRocket');
			G6Bot_Rocker (NewBot).EnterPatrolPath(self);
			break;
		default:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_CrazyRocket');
			G6Bot_Rocker (NewBot).EnterPatrolPath(self);
			break;
	}

	foreach AllActors( class'G6PlayerController', P )
	{
		P.roomSpawns[15]++;
	}

	return NewBot;
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=DisplayMesh
		//StaticMesh=StaticMesh'NodeBuddies.NodeBuddy_PerchUp'
	End Object
	Components.Add(DisplayMesh)

	BotsToSpawn = 2
	SpawnInterval = 3

	bStatic = false
	bSpawn = false
}
