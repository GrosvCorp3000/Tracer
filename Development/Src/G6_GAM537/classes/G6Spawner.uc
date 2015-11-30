class G6Spawner extends G6PatrolPath
	placeable
	ClassGroup(GROUP6);

var(Spawner) int BotsToSpawn;
var(Spawner) float SpawnInterval;

var bool bSpawn;


function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(SpawnInterval, true);
}


function Timer()
{
	local int random;

	random = Rand(10);

	if (!bSpawn || BotsToSpawn <= 0 || random <= 3)
		return;

	if (SpawnBot() != None)	BotsToSpawn--;
}

function UTBot SpawnBot()
{
	local UTBot NewBot;
	local Pawn NewPawn;
	local rotator StartRotation;
	local int random;

	random = Rand(10);

	if (random < 3)
		NewBot = Spawn(class'G6Bot_Gunner');
	else
		NewBot = Spawn(class'G6Bot_Melee');

	if (NewBot == None)
	{
		`log("Couldn't spawn at "$self);
		return None;
	}

	StartRotation = Rotation;
	StartRotation.Yaw = Rotation.Yaw;

	NewPawn = Spawn(class'UTPawn',,,Location,StartRotation);
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

	if (random < 3)
	{
		NewPawn.InvManager.CreateInventory(class'G6BWeap_MachineGun');
		G6Bot_Gunner (NewBot).EnterPatrolPath(self);
	}
	else
	{
		NewPawn.InvManager.CreateInventory(class'G6BWeap_Sword');
		G6Bot_Melee (NewBot).EnterPatrolPath(self);
	}

	return NewBot;
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=DisplayMesh
		StaticMesh=StaticMesh'NodeBuddies.NodeBuddy_PerchUp'
	End Object
	Components.Add(DisplayMesh)

	BotsToSpawn = 3
	SpawnInterval = 5

	bStatic = false
	bSpawn = false
}
