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
	//out_CamLoc = location + vect(-500, -500, 400);

	local L6Player p;

	out_CamLoc = location;

	p = L6Player (Controller);
	if (p != None) {
		out_CamLoc += p.offset;
	}
	


	//out_CamRot = rot(-8192, 8192, 0);
	out_CamRot = rotator(normal(location - out_CamLoc));
	//Pitch, Yaw, Roll;
	return true;
}

DefaultProperties
{

}
