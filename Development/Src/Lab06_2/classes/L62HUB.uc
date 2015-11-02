class L62HUB extends HUD;

/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	
	local L62Player p;
	local Color myColor;

	p = L62Player (PlayerOwner);

	Canvas.SetPos(SizeX * 0.7, SizeY * 0.1);
	Canvas.SetDrawColor(0, 0, 255);
	Canvas.DrawBox(SizeX * 0.2, SizeY * 0.5);

	myColor.A = 255;
	myColor.R = 255;


	Canvas.SetDrawColor(255, 255, 0);
	Canvas.SetPos(SizeX * 0.72, SizeY * 0.20);
	if (p.L62CamLocked) {
		Canvas.DrawText("Camera Lock is ON");
	} else {
		Canvas.DrawText("Camera Lock is OFF");
	}
}

DefaultProperties
{
}
