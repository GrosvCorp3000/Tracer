class G6Pawn extends UTPawn;

/**
 *	Calculate camera view point, when viewing this pawn.
 *
 * @param	fDeltaTime	delta time seconds since last update
 * @param	out_CamLoc	Camera Location
 * @param	out_CamRot	Camera Rotation
 * @param	out_FOV		Field of View
 *
 * @return	true if Pawn should provide the camera point of view.
 */
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local G6PlayerController p;
	p = G6PlayerController (Controller);

	if (p.Pawn != None) {
		
		/*
		if (p.Pawn.GroundSpeed < 2500) {
			p.Pawn.GroundSpeed += 300; //make the player's pawn faster
		}
		*/

		out_CamLoc = p.Pawn.Location + p.camOffset;
		out_CamRot = rotator(normal(p.Pawn.Location - out_CamLoc));
	}
	return true;
}

DefaultProperties
{
	GroundSpeed = 1200
}
