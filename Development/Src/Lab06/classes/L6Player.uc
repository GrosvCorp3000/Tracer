class L6Player extends UTPlayerController;

var int MsgCalled;
var Pawn closestPawn;
var vector offset;

function IncrementSpecialMessage()
{
    MsgCalled++;
	`log("IncrementSpecialMessage() function called!!!!!!!!!!!!!!!!!!!!!!!");
}

exec function IncX()
{
	offset.X += 100;
}

exec function DecX()
{
	offset.X -= 100;
}

exec function IncY()
{
	offset.Y += 100;
}

exec function DecY()
{
	offset.Y += 100;
}

exec function IncZ()
{
	offset.Z += 100;
}

exec function DecZ()
{
	offset.Z -= 100;
}

event PlayerTick( float DeltaTime )
{
	
	local Pawn A;
	
	// Go through all actors in the level.
	log( "Physics:" );
	foreach AllActors( class 'Pawn', A )
	{
		cloestPawn = A;
		if( A.Physics != PHYS_Interpolating )
			log( A );
	}
	local NavigationPoint point;
    foreach AllActors(class'NavigationPoint', point)
    {
        `Log("Iterating over navigation point "$point);
    }
}

DefaultProperties
{
	bBehindView = true
	offset = (Y=-500, x=-500, z=400)
}
