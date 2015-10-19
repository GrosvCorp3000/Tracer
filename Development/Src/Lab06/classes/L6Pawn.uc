class L6Pawn extends UTPawn;

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
	//out: more life time than function

	// current camera lock
	//out_CamLoc = vect(0, 0, 50);
	out_CamLoc = location + vect(0, -500, 0);
	return true;
}

DefaultProperties
{
}
