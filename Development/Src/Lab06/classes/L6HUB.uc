class L6HUB extends HUD;

/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	
	local L6Player p;
	local Color myColor;
	local String enemy;
	
	enemy = "None";

	p = L6Player (PlayerOwner);

	Canvas.SetPos(SizeX * 0.7, SizeY * 0.1);
	Canvas.SetDrawColor(0, 0, 255);
	Canvas.DrawBox(SizeX * 0.2, SizeY * 0.5);

	//Draw the line from player to nearest bot
	myColor.A = 255;
	myColor.R = 255;

	
	if (p.closestPawn != none) {
		Draw3DLine(p.Pawn.Location, p.closestPawn.Location, myColor);
		enemy = p.closestPawn.PlayerReplicationInfo.PlayerName;
	}

	Canvas.SetPos(SizeX * 0.72, SizeY * 0.15);
	Canvas.SetDrawColor(255, 0, 0);
	Canvas.DrawText("Closest enemy is : "$enemy);

	Canvas.SetDrawColor(255, 255, 0);
	Canvas.SetPos(SizeX * 0.72, SizeY * 0.20);
	Canvas.DrawText("Counter: "$p.MsgCalled);
	

}

DefaultProperties
{
}
