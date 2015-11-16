class G6PlayerController extends UTPlayerController;

//UI Toggles
var bool debug;
var int unitHE;
var bool bWUI;
var bool bBattleMode;
var bool bSkill;

//Character attributes
var int cEnergy;
var int cEnergyMax;
var int cExp;
var int cLevel;
var int cSkPts;

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

var vector camOffset;


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

exec function StartFire( optional byte FireModeNum )
{
	local G6PlayerInput p_input;
	p_input = G6PlayerInput (PlayerInput);

	if(!p_input.bControllingCursor) {
		super.StartFire(FireModeNum);
	}
}

exec function ToggleSkillTree()
{
	local G6PlayerInput p_input;
	p_input = G6PlayerInput (PlayerInput);
	if (Pawn != none && !bBattleMode) {
		p_input.bControllingCursor = !p_input.bControllingCursor;
		bSkill = !bSkill;
		IgnoreMoveInput(bSkill);
	}
}

exec function ToggleBattle() 
{
	if (Pawn != none) {
		 bBattleMode = !bBattleMode;
	}
}

exec function ToggleWUI() 
{
	if (Pawn != none) {
		bWUI = !bWUI;
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
	camOffset.X += 100;
}

exec function DecCamOffsetX()
{
	camOffset.X -= 100;
}

exec function IncCamOffsetY()
{
	camOffset.Y += 100;
}

exec function DecCamOffsetY()
{
	camOffset.Y -= 100;
}

exec function IncCamOffsetZ()
{
	camOffset.Z += 100;
}

exec function DecCamOffsetZ()
{
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
	cEnergy = 100
	cEnergyMax = 100
	bSkill = false
	bBattleMode = false
	debug = false
	unitHE = 0
	bBehindView = true
	camOffset = (X=-400, Y=300, z=500)
	InputClass = class'G6PlayerInput'
}
