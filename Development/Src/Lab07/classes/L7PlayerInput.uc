class L7PlayerInput extends UTPlayerInput within L7Player;

var IntPoint MousePosition;
var bool bControllingCursor;
var bool bAttemptSelect;

exec function ToggleControllingCursor()
{
	bControllingCursor = !bControllingCursor;
}

exec function StartAttemptSelect()
{
	if (bControllingCursor) {
		bAttemptSelect =  true;
	}
}

// Postprocess the player's input.
event PlayerInput( float DeltaTime )
{
	Super.PlayerInput(DeltaTime);
	if (bControllingCursor) {
		if (myHUD != None) 
		{
			// Add the aMouseX to the mouse position and clamp it within the viewport width
			MousePosition.X = Clamp(MousePosition.X + aMouseX * 0.1, 0, myHUD.SizeX - 20); 
			// Add the aMouseY to the mouse position and clamp it within the viewport height
			MousePosition.Y = Clamp(MousePosition.Y - aMouseY * 0.1, 0, myHUD.SizeY - 20); 
		}
	}
}

DefaultProperties
{
	bControllingCursor = false
	bAttemptSelect = false
}
