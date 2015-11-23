class W9Pawn extends UTPawn;

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local W9Player p;
	p = W9Player (Controller);

	if (p != None && p.Pawn != None) {
		out_CamLoc = p.Pawn.Location + p.camOffset;
		out_CamRot = rotator(normal(p.Pawn.Location - out_CamLoc));

	}
	return true;
}

DefaultProperties
{
}
