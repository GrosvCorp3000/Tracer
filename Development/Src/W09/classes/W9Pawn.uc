class W9Pawn extends UTPawn;

function bool CalcCamera(float fDeltaTime, out vector out_CamLoc,
	out rotator out_CamRot, out float out_fov)
{
	out_CamLoc = Location + Vect(100, 0, 500);
	out_CamRot = Rotator(Location - out_CamLoc);

	return true;
}

simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	local PlayerController pc;
	local W9PlayerInput pi;
	local vector v;

	pc = PlayerController(controller);

	if (pc != None)
	{
		pi = W9PlayerInput(pc.playerinput);
		if (pi != None)
		{
			v.Y = -(pi.MousePosition.X - pc.myHUD.SizeX * 0.5);
			v.X = pi.MousePosition.Y - pc.myHUD.SizeY * 0.5;

			NewRotation = Rotator(v);
		}
	}

	NewRotation.Pitch = 0;
	SetRotation(NewRotation);
}

DefaultProperties
{
}
