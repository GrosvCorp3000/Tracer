class W9PlayerInput extends UTPlayerInput;

var vector2d MousePosition;

event PlayerInput(float deltaTime)
{
	super.PlayerInput(deltatime);

	MousePosition.X += aMouseX * 0.1;
	MousePosition.Y -= aMouseY * 0.1;

	MousePosition.X = clamp(MousePosition.X, 0, myHud.SizeX);
	MousePosition.Y = clamp(MousePosition.Y, 0, myHud.SizeY);
}

DefaultProperties
{
}
