class G6PlayerController extends UTPlayerController;

//UI Toggles
var bool debug;
var int unitHE;
var bool bWUI;
var bool bBattleMode;
var bool bSkill;
var bool bMap;

//Character attributes
var int cEnergy;
var int cEnergyMax;
var int cExp;
var int cLevel;
var int cSkPts;

var int currentWeapon;
var UTWeapon curWeapon;

//Map Variables
var int curRoom;
var intPoint roomLoc[16];
var intPoint roomLoc2[16];
var String roomName[16];
//Player has entered room, currently in battle status
var int roomExplored[16];
//All enemies in room are dead, room cleared
var int roomCleared[16];
//Number of enemies left to kill
var int roomSpawns[16];
var int roomPoints[16];
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
/*var int cpExp;
var int cpLevel;
var int cpSkPts;
var int cpRoomExplored[16];
var int cpRoomCleared[16];
var int cpSkills[15];*/
var vector spawnPoints;

/* This really should be a 2D array, but UnrealScript, so this work around
 * Each Room has its own possible combination of enemies, the probablity is set by this variable
 */
var String enemyTypes[16];
var bool bAttemptRespawn;

var vector camOffset;
var bool bCamType;

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
	if(!bSkill && T >= 1 && T <= 4) {
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

exec function AttemptRespawn()
{
	bAttemptRespawn = true;
}

exec function GoToCheckpoint()
{
	Pawn.Health++;
	bBattleMode = false;
	Pawn.SetLocation(spawnPoints);
	IgnoreMoveInput(false);
}

exec function ToggleWUI() 
{
	if (Pawn != none) {
		bWUI = !bWUI;
	}
}

exec function ToggleCam() 
{
	if (Pawn != none) {
		bCamType = !bCamType;
	}
	if (bCamType) {
		camOffset.X = -300;
		camOffset.Y = 100;
		camOffset.Z = 300;
	} else {
		camOffset.X = -400;
		camOffset.Y = 300;
		camOffset.Z = 500;
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
	cLevel = 1
	cSkPts = 10
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
	skillNames[7] = "Recharge"
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
	roomLoc[0] = (X=-3327, Y=-3583)
	roomLoc2[0] = (X=-5375, Y=-2559)
	roomLoc[1] = (X=-5887, Y=-3711)
	roomLoc2[1] = (X=-7935, Y=-1663)
	roomLoc[2] = (X=-5887, Y=-1407)
	roomLoc2[2] = (X=-7935, Y=-639)
	roomLoc[3] = (X=-6015, Y=-225)
	roomLoc2[3] = (X=-7679, Y=768)
	roomLoc[4] = (X=-5119, Y=1024)
	roomLoc2[4] = (X=-7935, Y=3840)
	roomLoc[5] = (X=-3455, Y=-2303)
	roomLoc2[5] = (X=-5503, Y=-895) 
	roomLoc[6] = (X=-2815, Y=-767)
	roomLoc2[6] = (X=-4863, Y=1280)
	roomLoc[7] = (X=-255, Y=-3711)
	roomLoc2[7] = (X=-2815, Y=-639)
	roomLoc[8] = (X=-511, Y=0)
	roomLoc2[8] = (X=-2815, Y=512)
	roomLoc[9] = (X=-1535, Y=1664)
	roomLoc2[9] = (X=-4607, Y=3712)
	roomLoc[10] = (X=3200, Y=-3711)
	roomLoc2[10] = (X=128, Y=-895)
	roomLoc[11] = (X=2668, Y=-639)
	roomLoc2[11] = (X=-511, Y=1152)
	roomLoc[12] = (X=2560, Y=1536)
	roomLoc2[12] = (X=-511, Y=3584)
	roomLoc[13] = (X=6144, Y=-3711)
	roomLoc2[13] = (X=3584, Y=-2175)
	roomLoc[14] = (X=6016, Y=2688)
	roomLoc2[14] = (X=3200, Y=3712)
	roomLoc[15] = (X=7424, Y=-1791)
	roomLoc2[15] = (X=3328, Y=2304)
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
	roomSpawns[0] = 3
	roomSpawns[1] = 9
	roomSpawns[2] = 3
	roomSpawns[3] = 3
	roomSpawns[4] = 3
	roomSpawns[5] = 3
	roomSpawns[6] = 3
	roomSpawns[7] = 3
	roomSpawns[8] = 3
	roomSpawns[9] = 3
	roomSpawns[10] = 3
	roomSpawns[11] = 3
	roomSpawns[12] = 3
	roomSpawns[13] = 3
	roomSpawns[14] = 3
	roomSpawns[15] = 1
	roomPoints[0] = 3
	roomPoints[1] = 3
	roomPoints[2] = 3
	roomPoints[3] = 3
	roomPoints[4] = 3
	roomPoints[5] = 3
	roomPoints[6] = 3
	roomPoints[7] = 3
	roomPoints[8] = 3
	roomPoints[9] = 3
	roomPoints[10] = 3
	roomPoints[11] = 3
	roomPoints[12] = 3
	roomPoints[13] = 3
	roomPoints[14] = 3
	roomPoints[15] = 3

	/*
	 * Enemy Type:
	 *  0: G6Bot_Melee
	 *  1: G6Bot_Gunner
	 *  2: G6Bot_Grenadier
	 *  3: G6Bot_ShockBaller
	 *  4: G6Bot_Sniper
	 */
	enemyTypes[0] = "0"
	//enemyTypes[1] = "0001112233"
	enemyTypes[1] = "0011223344"
	enemyTypes[2] = "1111223355"
	enemyTypes[3] = "1111223355"
	enemyTypes[4] = "1111223355"
	enemyTypes[5] = "1111223355"
	enemyTypes[6] = "1111223355"
	enemyTypes[7] = "1111223355"
	enemyTypes[8] = "1111223355"
	enemyTypes[9] = "1111223355"
	enemyTypes[10] = "1111223355"
	enemyTypes[11] = "1111223355"
	enemyTypes[12] = "1111223355"
	enemyTypes[13] = "1111223355"
	enemyTypes[14] = "1111223355"
	enemyTypes[15] = "1111223355"
	mapZoom = 0.5;
	spawnPoints = (X=-3824,Y=-3376,Z=-441.5368)
	bMapPan = false;
	bCamType = true;
	camOffset = (X=-400, Y=300, z=500)
	//camOffset = (X=-300, Y=100, z=500)
	InputClass = class'G6PlayerInput'
}
