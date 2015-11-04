class G6PlayerController extends UTPlayerController;

var bool debug;
var vector camOffset;

exec function ToggleDebug() 
{
	if (Pawn != none) {
		debug = !debug;
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
	debug = true;
	bBehindView = true
	camOffset = (X=-300, Y=300, z=500)
}