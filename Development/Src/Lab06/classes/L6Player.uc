class L6Player extends UTPlayerController;

var int MsgCalled;
var Pawn closestPawn;

function IncrementSpecialMessage()
{
    MsgCalled++;
	`log("IncrementSpecialMessage() function called!!!!!!!!!!!!!!!!!!!!!!!");
}

DefaultProperties
{
	bBehindView = true
}
