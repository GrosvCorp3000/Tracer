class W9HUD extends HUD;

function DrawHUD()
{
	local W9PlayerInput pi;

	super.DrawHUD();

	pi = W9PlayerInput(PlayerOwner.PlayerInput);

	Canvas.SetPos(pi.MousePosition.X - 1,
		pi.MousePosition.Y - 1, 0);
	Canvas.SetDrawColor(255, 255, 0, 128);
	Canvas.DrawRect(2, 2);
	Canvas.SetPos(pi.MousePosition.X - 2,
		pi.MousePosition.Y - 2, 0);
	Canvas.SetDrawColor(0, 0, 0, 255);
	Canvas.DrawBox(4, 4);
}

DefaultProperties
{
}
