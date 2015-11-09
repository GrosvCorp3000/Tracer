class L7Player extends UTPlayerController;


function UpdateRotation( float DeltaTime )
{
	local L7PlayerInput p_input;
	p_input = L7PlayerInput (PlayerInput);

	if(!p_input.bControllingCursor) {
		super.UpdateRotation(DeltaTime);
	}
}

exec function StartFire( optional byte FireModeNum )
{
	local L7PlayerInput p_input;
	p_input = L7PlayerInput (PlayerInput);

	if(!p_input.bControllingCursor) {
		super.StartFire(FireModeNum);
	}
}

DefaultProperties
{
	InputClass = class'L7PlayerInput'
}
