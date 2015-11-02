class L62Player extends UTPlayerController;

var vector offset;
var bool L62CamLocked;
var rotator L62CamRot;

exec function ToggleCamLocked() 
{
	if (Pawn != none) {
		L62CamLocked = !L62CamLocked;
	}
}

exec function IncCamOffsetX()
{
	offset.X += 100;
}

exec function DecCamOffsetX()
{
	offset.X -= 100;
}

exec function IncCamOffsetY()
{
	offset.Y += 100;
}

exec function DecCamOffsetY()
{
	offset.Y -= 100;
}

exec function IncCamOffsetZ()
{
	offset.Z += 100;
}

exec function DecCamOffsetZ()
{
	offset.Z -= 100;
}

exec function IncCamOffsetPitch()
{
	L62CamRot.Pitch += 2500;
}

exec function DecCamOffsetPitch()
{
	L62CamRot.Pitch -= 2500;
}

exec function IncCamOffsetYaw()
{
	L62CamRot.Yaw += 2500;
}

exec function DecCamOffsetYaw()
{
	L62CamRot.Yaw -= 2500;
}

exec function IncCamOffsetRoll()
{
	L62CamRot.Roll += 2500;
}

exec function DecCamOffsetRoll()
{
	L62CamRot.Roll -= 2500;
}

DefaultProperties
{
	bBehindView = true
	offset = (Y=0, x=200, z=100)
	L62CamRot = (Pitch=0, Yaw=0, Roll=0)
	L62CamLocked = false
}
