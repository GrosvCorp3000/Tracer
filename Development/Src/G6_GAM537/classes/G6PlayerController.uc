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
var bool bsHealth;
var bool bsHealth2;
var bool bsEndure;
var bool bsEnergy;
var bool bsEnergy2;
var bool bsRecharge;
var bool bsSpeed;
var bool bsSpeed2;
var bool bsSlow;
var bool bsLaser;
var bool bsLaserUp;
var bool bsShotgun;
var bool bsShotgunUp;
var bool bsRocket;
var bool bsRocketUp;

var vector camOffset;

function UpdateRotation( float DeltaTime )
{
	local G6PlayerInput p_input;
	p_input = G6PlayerInput (PlayerInput);

	if(!p_input.bControllingCursor) {
		super.UpdateRotation(DeltaTime);
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
	bsHealth = false
	bsHealth2 = false
	bsEndure = false
	bsEnergy = false
	bsEnergy2 = false
	bsRecharge = false
	bsSpeed = false
	bsSpeed2 = false
	bsSlow = false
	bsLaser = false
	bsLaserUp = false
	bsShotgun = false
	bsShotgunUp = false
	bsRocket = false
	bsRocketUp = false
	cEnergy = 100
	cEnergyMax = 100
	bSkill = false
	bBattleMode = false
	debug = false
	unitHE = 0
	bBehindView = true
	camOffset = (X=-300, Y=300, z=500)
	InputClass = class'G6PlayerInput'
}
