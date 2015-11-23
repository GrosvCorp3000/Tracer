class W9Player extends UTplayerController;

var vector camOffset;

//This fixes weapons' projetiles to pawn's rotation, not the camera
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	return Rotation;
}

DefaultProperties
{
	camOffset = (X=-400, Y=300, z=500)
	bBehindView = true
}
