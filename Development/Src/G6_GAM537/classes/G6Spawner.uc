class G6Spawner extends G6PatrolPath
	placeable
	ClassGroup(GROUP6);

var(Spawner) int BotsToSpawn;
var(Spawner) float SpawnInterval;

var bool bSpawn;
var String enemySelect;


function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(SpawnInterval, true);
}


function Timer()
{
	local int random;

	random = Rand(12);

	if (!bSpawn || BotsToSpawn <= 0 || random < 5)
		return;

	if (SpawnBot() != None)	BotsToSpawn--;
}

function UTBot SpawnBot()
{
	local UTBot NewBot;
	local Pawn NewPawn;
	local rotator StartRotation;
	local int random;
	local int selected;

	random = Rand(10);

	selected = Int (Mid(enemySelect, random, 1));

	switch (selected)
	{
		case 1:
			NewBot = Spawn(class'G6Bot_Gunner');
			break;
		case 2:
			NewBot = Spawn(class'G6Bot_Grenadier');
			break;
		case 3:
			NewBot = Spawn(class'G6Bot_ShockBaller');
			break;
		case 4:
			NewBot = Spawn(class'G6Bot_Sniper');
			break;
		default:
			NewBot = Spawn(class'G6Bot_Melee');
			break;
	}

	if (NewBot == None)
	{
		`log("Couldn't spawn at "$self);
		return None;
	}

	StartRotation = Rotation;
	StartRotation.Yaw = Rotation.Yaw;

	switch (selected)
	{
		case 1:
			NewPawn = Spawn(class'G6BPawn',,,Location,StartRotation);
			break;
		case 2:
			NewPawn = Spawn(class'G6BPawn',,,Location,StartRotation);
			break;
		case 3:
			NewPawn = Spawn(class'G6BPawn',,,Location,StartRotation);
			break;
		case 4:
			NewPawn = Spawn(class'G6BPawn_Sniper',,,Location,StartRotation);
			break;
		default:
			NewPawn = Spawn(class'G6BPawn',,,Location,StartRotation);
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

	switch (selected)
	{
		case 1:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_MachineGun');
			G6Bot_Gunner (NewBot).EnterPatrolPath(self);
			break;
		case 2:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_GrenadeLauncher_Content');
			G6Bot_Grenadier (NewBot).EnterPatrolPath(self);
			break;
		case 3:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_ShockBall');
			G6Bot_ShockBaller (NewBot).EnterPatrolPath(self);
			break;
		case 4:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_Rifle');
			G6Bot_Sniper (NewBot).EnterPatrolPath(self);
			break;
		default:
			NewPawn.InvManager.CreateInventory(class'G6BWeap_Sword');
			G6Bot_Melee (NewBot).EnterPatrolPath(self);
			break;
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
	SpawnInterval = 3

	bStatic = false
	bSpawn = false
}
