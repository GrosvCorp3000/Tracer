class L6Player extends UTPlayerController;

var int MsgCalled;
var Pawn closestPawn;

exec function IncrementSpecialMessage()
{
    MsgCalled++;
	`log("IncrementSpecialMessage() function called!!!!!!!!!!!!!!!!!!!!!!!");
}


function PlayerTick( float DeltaTime )
{
	local Pawn A;

	// Go through all pawns in the level.
	
	foreach AllActors( class'Pawn', A )
	{
		if (A != Pawn && A.IsAliveAndWell()) {
			if (closestPawn == none || (VSize(A.Location - Pawn.location) < VSize(closestPawn.Location - Pawn.location))) {
				closestPawn = A;
			}
		}
	}
	
	super.PlayerTick(DeltaTime);
}


DefaultProperties
{
		MsgCalled = 0;
}
