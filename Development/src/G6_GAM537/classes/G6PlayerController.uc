class G6PlayerController extends UTPlayerController;

//UI Toggles
var bool debug;
var int unitHE;
var bool bWUI;
var bool bBattleMode;
var bool bSkill;
var bool bMap;
var bool bCamType;
var bool bSkinType;
var bool bSpecial;

//Character attributes
var int cEnergy;
var int cEnergyMax;
var float cSpecial;
var float cSpecialMax;
var int cSkPts;

var int currentWeapon;
var UTWeapon curWeapon;

//Map Variables
var int curRoom;
var intPoint roomLoc[17];
var intPoint roomLoc2[17];
var intPoint hallLoc[19];
var intPoint hallLoc2[19];
var int hallExplored[19];
var String roomName[17];
//Player has entered room, currently in battle status
var int roomExplored[17];
//All enemies in room are dead, room cleared
var int roomCleared[17];
//Number of enemies Needed to kill
var int roomSpawns[17];
//Kills in the current Room
var int roomCurKill;
var int roomPerSpawn[17];
var int roomPoints[17];
var float mapZooming;
var float mapZoom;
var bool bMapPan;
var intPoint mapFocus;
var intPoint playerMapLoc;

//Skill tree components
/* skills[0] - Health
 * skills[1] - Health2
 * skills[2] - Endure
 * skills[3] - Laser
 * skills[4] - Laser Upgrade
 * skills[5] - Energy
 * skills[6] - Energy2
 * skills[7] - Recharge
 * skills[8] - Shotgun
 * skills[9] - Shotgun Upgrade
 * skills[10] - Speed
 * skills[11] - Speed2
 * skills[12] - Slow
 * skills[13] - Rocket
 * skills[14] - Rocket Upgrade */
var int skills[15];
var string skillNames[15];
var int skillRequirement[15];

//Checkpoint Variables
var int cpSkPts;
var int cpSkills[15];
var float cpSpecial;
var int cpHallExplored[19];
var int cpRoomExplored[17];
var int cpRoomCleared[17];
var int cpRoomSpawns[17];

var int lastCheckPoint;
var vector spawnPoints[19];
var bool bRespawning;
var bool bRespawn;

/* This really should be a 2D array, but UnrealScript, so this work around
 * Each Room has its own possible combination of enemies, the probablity is set by this variable
 */
var String enemyTypes[17];

//Just a check to see if the player has purchased upgraded this weapon;
var int weaponStatus[4];

var vector camOffset;
var int camX;
var int camY;
var int camZ;

//This fixes weapons' projetiles to pawn's rotation, not the camera
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	return Rotation;
}

function UpdateRotation( float DeltaTime )
{
	local Rotator DeltaRot, newRotation, ViewRotation;
	local G6PlayerInput p_input;
	p_input = G6PlayerInput (PlayerInput);

	if(!p_input.bControllingCursor) {
		ViewRotation = Rotation;
		if (Pawn!=none)
		{
			Pawn.SetDesiredRotation(ViewRotation);
		}

		// Calculate Delta to be applied on ViewRotation
		DeltaRot.Yaw	= PlayerInput.aTurn;
		//DeltaRot.Pitch	= PlayerInput.aLookUp;

		ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
		SetRotation(ViewRotation);

		ViewShake( deltaTime );

		NewRotation = ViewRotation;
		NewRotation.Roll = Rotation.Roll;

		if ( Pawn != None )
			Pawn.FaceRotation(NewRotation, deltatime);
	}
	if(camOffset.X != camX){
		camOffset.X = camOffset.X - (camOffset.X - camX)/4;
		if((camOffset.X - camX < 0.005 && camOffset.X > camX) || (camX - camOffset.X < 0.005 && camOffset.X < camX)){
			camOffset.X = camX;
		}
	}
	if(camOffset.Y != camY){
		camOffset.Y = camOffset.Y - (camOffset.Y - camY)/4;
		if((camOffset.Y - camY < 0.005 && camOffset.Y > camY) || (camY - camOffset.Y < 0.005 && camOffset.Y < camY)){
			camOffset.Y = camY;
		}
	}
	if(camOffset.Z != camZ){
		camOffset.Z = camOffset.Z - (camOffset.Z - camZ)/4;
		if((camOffset.Z - camZ < 0.005 && camOffset.Z > camZ) || (camZ - camOffset.Z < 0.005 && camOffset.Z < camZ)){
			camOffset.Z = camZ;
		}
	}
}

exec function PrevWeapon() {
	if(mapZoom > 0.35){
		mapZoom -= 0.15;
	}
	if(mapZoom < 0.35){
		mapZoom = 0.35;
	}
}

exec function NextWeapon() {
	if(mapZoom < 1){
		mapZoom += 0.15;
	}
	if(mapZoom > 1){
		mapZoom = 1;
	}
}

exec function StartFire( optional byte FireModeNum )
{
	local G6PlayerInput p_input;
	p_input = G6PlayerInput (PlayerInput);

	if(!p_input.bControllingCursor) {
		if(Pawn.Weapon == Pawn.InvManager.FindInventoryType(class'G6Weap_Laser')){
			super.StartFire( 1 );
		}else{
			super.StartFire(FireModeNum);
		}
	}
}

exec function StopFire( optional byte FireModeNum )
{
	super.StopFire( 0 );
	super.StopFire( 1 );
}

exec function SwitchWeapon(byte T)
{
	if(!bSkill && T >= 1 && T <= 4 && weaponStatus[T-1]==1) {
		currentWeapon = T;
		super.SwitchWeapon(T);
		curWeapon = UTWeapon (Pawn.Weapon);
		curWeapon.MaxAmmoCount = cEnergyMax;
		StopFire();
	}
}

exec function ToggleSkillTree()
{
	local G6PlayerInput p_input;
	p_input = G6PlayerInput (PlayerInput);
	if (Pawn != none && !bBattleMode && !bMap) {
		p_input.bControllingCursor = !p_input.bControllingCursor;
		bSkill = !bSkill;
		IgnoreMoveInput(bSkill);
	}
}

exec function ToggleMapDisplay()
{
	local G6PlayerInput p_input;
	p_input = G6PlayerInput (PlayerInput);
	if (Pawn != none && !bBattleMode && !bSkill) {
		p_input.bControllingCursor = !p_input.bControllingCursor;
		bMap = !bMap;
		IgnoreMoveInput(bMap);
		mapZoom = 0.5;
		mapZooming = mapZoom;
		playerMapLoc.Y = (8191-Pawn.Location.X) / 16;
		playerMapLoc.X = (Pawn.Location.Y + 4095) / 16;
		Clamp(playerMapLoc.X, 0, 512);
		Clamp(playerMapLoc.Y, 0, 1024);
		mapFocus.X = playerMapLoc.X;
		mapFocus.Y = playerMapLoc.Y;
	}
}

exec function StartMapPan()
{
	if(bMap){
		bMapPan = true;
	}
}

exec function StopMapPan()
{
	bMapPan = false;
}

exec function toggleSpecial()
{
	if (bBattleMode && !bSpecial && cSpecial >= 75)
		bSpecial = True;
	else
		bSpecial = False;

	if (bSpecial) {
		WorldInfo.Game.SetGameSpeed(0.25);
		ToggleCam();
		PlaySound(SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_Berzerk_EndCue');
	}
	else if(WorldInfo.Game.GameSpeed != 1){
		WorldInfo.Game.SetGameSpeed(1);
		ToggleCam();
		PlaySound(SoundCue'A_Pickups_Powerups.PowerUps.A_Powerup_Berzerk_PickupCue');
	}
}


exec function giveSpecial()
{
	if (!bSpecial)
		cSpecial=95;
}

exec function ToggleCam() 
{
	if (bSpecial) {
		camX = -300;
		camY = 200;
		camZ = 400;
	} else {
		camX = -400;
		camY = 300;
		camZ = 500;
	}
}
exec function ToggleBattle() 
{
	if (Pawn != none) {
		 bBattleMode = !bBattleMode;
		 if(bSkill){
			ToggleSkillTree();
		 }
		 if(bMap){
			ToggleMapDisplay();
		 }
	}
}

exec function KillAllEnemies()
{
	local G6Bot enemyPawn;
	foreach AllActors(class'G6Bot', enemyPawn){
		enemyPawn.Pawn.Suicide();
	}
}

exec function KillAllEnemiesNoBoss()
{
	local G6Bot enemyPawn;
	local G6Bot_Boss Boss;
	foreach AllActors(class'G6Bot', enemyPawn){
		Boss = G6Bot_Boss(enemyPawn);
		if (Boss==None)
			enemyPawn.Pawn.Suicide();
	}
}

exec function AttemptRespawn()
{
	local G6Pawn p;
	local G6Spawner S;
	p = G6Pawn (Pawn);

	if(!p.bFeigningDeath){
		bBattleMode = true;
		p.FeignDeath();
		IgnoreMoveInput(true);
	}
	foreach AllActors( class'G6Spawner', S )
	{
		S.bSpawn = False;
	}
	bRespawning=True;
	SetTimer(3, true, nameof(Respawn));
}

function Respawn()
{
	local G6Pawn p;
	local Trigger T;
	p = G6Pawn (Pawn);

	if (bRespawning)
	{
		if(bRespawn){
			Pawn.SetHidden(true);
			if(p.bFeigningDeath){
				p.FeignDeath();
			}
			GoToCheckpoint();
			KillAllEnemies();
			bRespawn = false;
		}
		SwitchWeapon(1);
		foreach AllActors( class'Trigger', T )
		{
			T.SetCollision(True);
		}
		if(p.Health == p.HealthMax){
			bRespawning = False;
			Pawn.SetHidden(false);
			PlayTeleportEffect(true, true);
			IgnoreMoveInput(false);
		}
		roomCurKill = 0;
		SetTimer(0.1, true, nameof(Respawn));
	}
}

exec function CheckPointSave()
{
	local int counter;

	cpSkPts = cSkPts;
	cpSpecial = cSpecial;
	for(counter = 0; counter < 15; counter++){
		cpSkills[counter] = skills[counter];
	}
	for(counter = 0; counter < 17; counter++){
		cpRoomExplored[counter] = roomExplored[counter];
		cpRoomCleared[counter] = roomCleared[counter];
		cpRoomSpawns[counter] = roomSpawns[counter];
	}
	for(counter = 0; counter < 19; counter++){
		cpHallExplored[counter] = hallExplored[counter];
	}
}

exec function GoToCheckpoint()
{	
	CheckPointLoad();

	bBattleMode = false;
	Pawn.SetLocation(spawnPoints[lastCheckPoint]);
	//IgnoreMoveInput(false);
}

exec function TeleportTo(int T) 
{
	if (!bBattleMode) {
		Pawn.SetLocation(spawnPoints[T]);
	}
}

exec function SetSkillPoints(int T)
{
	cSkPts = T;
}

exec function CheckPointLoad()
{
	local int counter;

	cSkPts = cpSkPts;
	cSpecial = cpSpecial;
	for(counter = 0; counter < 15; counter++){
		skills[counter] = cpSkills[counter];
	}
	for(counter = 0; counter < 17; counter++){
		roomExplored[counter] = cpRoomExplored[counter];
		roomCleared[counter] = cpRoomCleared[counter];
		roomSpawns[counter] = cpRoomSpawns[counter];
	}
	for(counter = 0; counter < 19; counter++){
		hallExplored[counter] = cpHallExplored[counter];
	}
}

exec function ToggleWUI() 
{
	if (Pawn != none) {
		bWUI = !bWUI;
	}
}

exec function ToggleSkin() 
{
	if (Pawn != none) {
		bSkinType = !bSkinType;
	}
}

exec function ToggleDebug() 
{
	if (Pawn != none) {
		debug = !debug;
	}
}

exec function ToggleUnitHE() 
{
	if (Pawn != none) {
		unitHE = (unitHE + 1) % 3;
	}
}

exec function IncCamOffsetX()
{
	if (debug)
		camOffset.X += 100;
}

exec function DecCamOffsetX()
{
	if (debug)
		camOffset.X -= 100;
}

exec function IncCamOffsetY()
{
	if (debug)
		camOffset.Y += 100;
}

exec function DecCamOffsetY()
{
	if (debug)
		camOffset.Y -= 100;
}

exec function IncCamOffsetZ()
{
	if (debug)
		camOffset.Z += 100;
}

exec function DecCamOffsetZ()
{
	if (debug)
		camOffset.Z -= 100;
}

// Player movement.
// Player Standing, walking, running, falling.
state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;
	function PlayerMove( float DeltaTime )
	{
		local vector			X,Y,Z, NewAccel;
		local eDoubleClickDir	DoubleClickMove;
		local rotator			OldRotation;
		local bool				bSaveJump;

		if( Pawn == None )
		{
			GotoState('Dead');
		}
		else
		{
			GetAxes(Pawn.Rotation,X,Y,Z);

			//Movement is now independent of camera and pawn rotation
			X = vect(1, 0, 0);
            Y = vect(0, 1, 0);

			// Update acceleration.
			NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;
			NewAccel.Z	= 0;
			NewAccel = Pawn.AccelRate * Normal(NewAccel);

			if (IsLocalPlayerController())
			{
				AdjustPlayerWalkingMoveAccel(NewAccel);
			}

			DoubleClickMove = PlayerInput.CheckForDoubleClickMove( DeltaTime/WorldInfo.TimeDilation );

			// Update rotation.
			OldRotation = Rotation;
			UpdateRotation( DeltaTime );
			bDoubleJump = false;

			if( bPressedJump && Pawn.CannotJumpNow() )
			{
				bSaveJump = true;
				bPressedJump = false;
			}
			else
			{
				bSaveJump = false;
			}

			if( Role < ROLE_Authority ) // then save this move and replicate it
			{
				ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
			}
			else
			{
				ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation - Rotation);
			}
			bPressedJump = bSaveJump;
		}
	}
}

DefaultProperties
{
	cSkPts = 0
	skills[0] = 0
	skills[1] = 0
	skills[2] = 0
	skills[3] = 0
	skills[4] = 0
	skills[5] = 0
	skills[6] = 0
	skills[7] = 0
	skills[8] = 0
	skills[9] = 0
	skills[10] = 0
	skills[11] = 0
	skills[12] = 0
	skills[13] = 0
	skills[14] = 0
	skillNames[0] = " Health"
	skillNames[1] = " Health2"
	skillNames[2] = " Endure"
	skillNames[3] = "  Laser"
	skillNames[4] = " Laser+"
	skillNames[5] = " Energy"
	skillNames[6] = " Energy2"
	skillNames[7] = "Vengence"
	skillNames[8] = "Shotgun"
	skillNames[9] = "Shotgun+"
	skillNames[10] = " Speed"
	skillNames[11] = " Speed2"
	skillNames[12] = "  Slow"
	skillNames[13] = "Rocket"
	skillNames[14] = "Rocket+"
	skillRequirement[0] = 1
	skillRequirement[1] = 1
	skillRequirement[2] = 2
	skillRequirement[3] = 1
	skillRequirement[4] = 2
	skillRequirement[5] = 1
	skillRequirement[6] = 1
	skillRequirement[7] = 2
	skillRequirement[8] = 1
	skillRequirement[9] = 2
	skillRequirement[10] = 1
	skillRequirement[11] = 1
	skillRequirement[12] = 2
	skillRequirement[13] = 1
	skillRequirement[14] = 2
	cEnergy = 100
	cEnergyMax = 100
	bSkill = false
	bBattleMode = false
	bMap = false
	debug = false
	unitHE = 0
	bBehindView = true
	currentWeapon = 1
	curRoom = 0
	roomLoc[0]   =  (X=-3327, Y=-3583)
	roomLoc2[0]  =  (X=-5375, Y=-2559)
	roomLoc[1]   =  (X=-5887, Y=-3711)
	roomLoc2[1]  =  (X=-7935, Y=-1663)
	roomLoc[2]   =  (X=-5887, Y=-1407)
	roomLoc2[2]  =  (X=-7935, Y=-639)
	roomLoc[3]   =  (X=-6015, Y=-225)
	roomLoc2[3]  =  (X=-7679, Y=768)
	roomLoc[4]   =  (X=-5119, Y=1024)
	roomLoc2[4]  =  (X=-7935, Y=3840)
	roomLoc[5]   =  (X=-3455, Y=-2303)
	roomLoc2[5]  =  (X=-5503, Y=-895) 
	roomLoc[6]   =  (X=-2815, Y=-767)
	roomLoc2[6]  =  (X=-4863, Y=1280)
	roomLoc[7]   =  (X=-255, Y=-3711)
	roomLoc2[7]  =  (X=-2815, Y=-639)
	roomLoc[8]   =  (X=-511, Y=0)
	roomLoc2[8]  =  (X=-2815, Y=512)
	roomLoc[9]   =  (X=-1535, Y=1664)
	roomLoc2[9]  =  (X=-4607, Y=3712)
	roomLoc[10]  =  (X=3200, Y=-3711)
	roomLoc2[10] =  (X=128, Y=-895)
	roomLoc[11]  =  (X=2668, Y=-639)
	roomLoc2[11] =  (X=-511, Y=1152)
	roomLoc[12]  =  (X=2560, Y=1536)
	roomLoc2[12] =  (X=-511, Y=3584)
	roomLoc[13]  =  (X=6144, Y=-3711)
	roomLoc2[13] =  (X=3584, Y=-2175)
	roomLoc[14]  =  (X=6016, Y=2688)
	roomLoc2[14] =  (X=3200, Y=3712)
	roomLoc[15]  =  (X=7424, Y=-1791)
	roomLoc2[15] =  (X=3328, Y=2304)
	roomLoc[16]  =  (X=-1535, Y=896)
	roomLoc2[16] =  (X=-2559, Y=1408)
	hallLoc[0]   =  (X=-5375, Y=-3199)
	hallLoc2[0]  =  (X=-5887, Y=-2943)
	hallLoc[1]   =  (X=-5503, Y=-2175)
	hallLoc2[1]  =  (X=-5887, Y=-1919)
	hallLoc[2]   =  (X=-6015, Y=-1663)
	hallLoc2[2]  =  (X=-6271, Y=-1407)
	hallLoc[3]   =  (X=-5503, Y=-1279)
	hallLoc2[3]  =  (X=-5887, Y=-1023)
	hallLoc[4]   =  (X=-7679, Y=-639)
	hallLoc2[4]  =  (X=-7935, Y=1024)
	//hall 5 overlaps with hall 6
	hallLoc[5]   =  (X=-5119, Y=-895)
	hallLoc2[5]  =  (X=-5375, Y=1024)
	hallLoc[6]   =  (X=-4863, Y=128)
	hallLoc2[6]  =  (X=-6015, Y=384)
	hallLoc[7]   =  (X=-4607, Y=2432)
	hallLoc2[7]  =  (X=-5119, Y=2944)
	//hall 8 overlaps with room 8
	hallLoc[8]   =  (X=-1919, Y=-639)
	hallLoc2[8]  =  (X=-2175, Y=896)
	hallLoc[9]   =  (X=-511, Y=512)
	hallLoc2[9]  =  (X=-1535, Y=3456)
	hallLoc[10]  =  (X=-767, Y=-639)
	hallLoc2[10] =  (X=-1023, Y=0)
	hallLoc[11]  =  (X=128, Y=-2559)
	hallLoc2[11] =  (X=-255, Y=-2047)
	hallLoc[12]  =  (X=2432, Y=-895)
	hallLoc2[12] =  (X=2176, Y=-383)
	hallLoc[13]  =  (X=2432, Y=896)
	hallLoc2[13] =  (X=2176, Y=1536)
	hallLoc[14]  =  (X=3584, Y=-3071)
	hallLoc2[14] =  (X=3200, Y=-2815)
	hallLoc[15]  =  (X=3200, Y=3072)
	hallLoc2[15] =  (X=2560, Y=3328)
	hallLoc[16]  =  (X=5632, Y=-2175)
	hallLoc2[16] =  (X=5120, Y=-1791)
	hallLoc[17]  =  (X=5632, Y=2304)
	hallLoc2[17] =  (X=5120, Y=2688)
	hallLoc[18]  =  (X=3328, Y=0)
	hallLoc2[18] =  (X=2688, Y=512)
	roomName[0] = "Player Start"
	roomName[1] = "The Sphere"
	roomName[2] = "The Gallery"
	roomName[3] = "Containment"
	roomName[4] = "Maze"
	roomName[5] = "Scaffolding"
	roomName[6] = "Midlife"
	roomName[7] = "Mist"
	roomName[8] = "Grand Crossing"
	roomName[9] = "Dais"
	roomName[10] = "Pond"
	roomName[11] = "Twins"
	roomName[12] = "Two Bridges"
	roomName[13] = "Alien"
	roomName[14] = "Crash Site"
	roomName[15] = "Final"
	roomName[16] = "Secret Room"
	roomExplored[0] = 0
	roomExplored[1] = 0
	roomExplored[2] = 0
	roomExplored[3] = 0
	roomExplored[4] = 0
	roomExplored[5] = 0
	roomExplored[6] = 0
	roomExplored[7] = 0
	roomExplored[8] = 0
	roomExplored[9] = 0
	roomExplored[10] = 0
	roomExplored[11] = 0
	roomExplored[12] = 0
	roomExplored[13] = 0
	roomExplored[14] = 0
	roomExplored[15] = 0
	roomExplored[16] = 0
	roomCleared[0] = 0
	roomCleared[1] = 0
	roomCleared[2] = 0
	roomCleared[3] = 0
	roomCleared[4] = 0
	roomCleared[5] = 0
	roomCleared[6] = 0
	roomCleared[7] = 0
	roomCleared[8] = 0
	roomCleared[9] = 0
	roomCleared[10] = 0
	roomCleared[11] = 0
	roomCleared[12] = 0
	roomCleared[13] = 0
	roomCleared[14] = 0
	roomCleared[15] = 0
	roomCleared[16] = 0
	roomSpawns[0] = -1
	roomSpawns[1] = 9
	roomSpawns[2] = 6
	roomSpawns[3] = -1
	roomSpawns[4] = 12
	roomSpawns[5] = 6
	roomSpawns[6] = 8
	roomSpawns[7] = 16
	roomSpawns[8] = 6
	roomSpawns[9] = 12
	roomSpawns[10] = 8
	roomSpawns[11] = 12
	roomSpawns[12] = 12
	roomSpawns[13] = 9
	roomSpawns[14] = 6
	roomSpawns[15] = 1
	roomSpawns[16] = 1

	//The Number of enemies spawn in each room is:
	//roomPerSpawn[i] * number of spawners placed in map
	roomPerSpawn[0] = 3 // 0
	roomPerSpawn[1] = 3 // 3
	roomPerSpawn[2] = 2 // 3
	roomPerSpawn[3] = 0 // 0
	roomPerSpawn[4] = 3 // 4
	roomPerSpawn[5] = 2 // 3
	roomPerSpawn[6] = 2 // 4
	roomPerSpawn[7] = 4 // 4
	roomPerSpawn[8] = 2 // 3
	roomPerSpawn[9] = 4 // 3
	roomPerSpawn[10] = 2 // 4
	roomPerSpawn[11] = 4 // 3
	roomPerSpawn[12] = 3 // 4
	roomPerSpawn[13] = 3 // 3
	roomPerSpawn[14] = 2 // 3
	roomPerSpawn[15] = 1 // 1
	roomPerSpawn[16] = 1 // 1
	roomPoints[0] = 0
	roomPoints[1] = 2
	roomPoints[2] = 1
	roomPoints[3] = 0
	roomPoints[4] = 3
	roomPoints[5] = 2
	roomPoints[6] = 2
	roomPoints[7] = 5
	roomPoints[8] = 1
	roomPoints[9] = 3
	roomPoints[10] = 2
	roomPoints[11] = 2
	roomPoints[12] = 2
	roomPoints[13] = 3
	roomPoints[14] = 2
	roomPoints[15] = 0
	roomPoints[16] = 0

	/*
	 * Enemy Type:
	 *  0: G6Bot_Melee
	 *  1: G6Bot_Gunner
	 *  2: G6Bot_Grenadier
	 *  3: G6Bot_ShockBaller
	 *  4: G6Bot_Sniper
	 *  5: G6Bot_Boomer
	 *  6: G6Bot_Rocker
	 *  7: G6Bot_Healer
	 *  8: G6Bot_Boss
	 */
	enemyTypes[0] = "0"
	enemyTypes[1] = "1111111333"
	enemyTypes[2] = "1111333377"
	enemyTypes[3] = "0"
	enemyTypes[4] = "2222222222"
	enemyTypes[5] = "5555555555"
	enemyTypes[6] = "001223666"
	enemyTypes[7] = "1122345556"
	enemyTypes[8] = "4444444444"
	enemyTypes[9] = "0011155566"
	enemyTypes[10] = "1114446666"
	enemyTypes[11] = "0004445577"
	enemyTypes[12] = "1122344677"
	enemyTypes[13] = "0111234567"
	enemyTypes[14] = "0112334567"
	enemyTypes[15] = "8888888888"
	enemyTypes[16] = "0000000000"
	mapZoom = 0.5
	lastCheckPoint = 0;
	//spawnPoints[0] = (X=-3824,Y=-3376,Z=-464.8500)
	spawnPoints[0] = (X=-5631,Y=-3071,Z=-464.8500)
	spawnPoints[1] = (X=-5695,Y=-2047,Z=-464.8500)
	spawnPoints[2] = (X=-6143,Y=-1535,Z=-464.8500)
	spawnPoints[3] = (X=-5695,Y=-1151,Z=-464.8500)
	spawnPoints[4] = (X=-7807,Y=256,Z=-464.8500)
	spawnPoints[5] = (X=-5247,Y=0,Z=-480.8500)
	spawnPoints[6] = (X=-5375,Y=256,Z=-336.8500)
	spawnPoints[7] = (X=-4863,Y=2688,Z=-464.8500)
	spawnPoints[8] = (X=-2047,Y=128,Z=-480.8500)
	spawnPoints[9] = (X=-895,Y=2304,Z=-336.8500)
	spawnPoints[10] = (X=-895,Y=-318,Z=-336.8500)
	spawnPoints[11] = (X=-63,Y=-2303,Z=-416.8500)
	spawnPoints[12] = (X=2304,Y=-639,Z=-336.8500)
	spawnPoints[13] = (X=2304,Y=1216,Z=-336.8500)
	spawnPoints[14] = (X=3392,Y=-2943,Z=-336.8500)
	spawnPoints[15] = (X=2880,Y=3200,Z=-336.8500)
	spawnPoints[16] = (X=5376,Y=-1983,Z=-416.8500)
	spawnPoints[17] = (X=5376,Y=2496,Z=-416.8500)
	spawnPoints[18] = (X=3008,Y=256,Z=-400.8500)
	bMapPan = false
	bCamType = true
	camOffset = (X=-400, Y=300, z=500)
	camX = -400
	camY = 300
	camZ = 500
	//camOffset = (X=-300, Y=100, z=500)
	InputClass = class'G6PlayerInput'
	bSkinType = true

	bRespawning = False
	bSpecial = False
	cSpecial = 75
	cSpecialMax = 100

	weaponStatus[0] = 1
	weaponStatus[1] = 0
	weaponStatus[2] = 0
	weaponStatus[3] = 0
}
