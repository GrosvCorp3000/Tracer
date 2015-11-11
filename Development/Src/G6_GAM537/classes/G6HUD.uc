class G6HUD extends HUD;

var float ColorBlink;
var int intColorBlink;
var int ColorBlinkPositive;
var Font PlayerFont;
var float PlayerNameScale;
var String MapLocationName;
var Vector PawnLocation;

/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	local vector playerProject;
	local Vector2D TextSize;
	local G6PlayerController p;
	local float HealthPercent;

	p = G6PlayerController (PlayerOwner);
	HealthPercent = p.Pawn.Health / float(p.Pawn.HealthMax);

	super.DrawHUD();

	if (p.debug) {
		Canvas.SetPos(SizeX * 0.1, SizeY * 0.1);
		Canvas.SetDrawColor(0, 0, 255);
		Canvas.DrawBox(SizeX * 0.2, SizeY * 0.5);

		Canvas.SetDrawColor(255, 255, 0);
		Canvas.SetPos(SizeX * 0.12, SizeY * 0.20);
		Canvas.DrawText("Camera Offset X: "$p.camOffset.X);
		Canvas.DrawText("Camera Offset Y: "$p.camOffset.Y);
		Canvas.DrawText("Camera Offset Z: "$p.camOffset.Z);

		Canvas.DrawText("Player Location X: "$p.Pawn.Location.X);
		Canvas.DrawText("Player Location Y: "$p.Pawn.Location.Y);
		Canvas.DrawText("Player Location Z: "$p.Pawn.Location.Z);

		Canvas.DrawText("Player Speed: "$p.Pawn.GroundSpeed);
	}

	//Determine the location via a very slow and manual way
	PawnLocation = p.Pawn.Location;
	if (PawnLocation.X > -5335 && PawnLocation.X < -3360 && PawnLocation.Y > -3550 && PawnLocation.Y < -2595) {
		MapLocationName = "Player Start";
	} else if (PawnLocation.X > -7899 && PawnLocation.X < -5923 && PawnLocation.Y > -3675 && PawnLocation.Y < -1700) {
		MapLocationName = "The Sphere";
	} else if (PawnLocation.X > -5467 && PawnLocation.X < -3492 && PawnLocation.Y > -2267 && PawnLocation.Y < -933) {
		MapLocationName = "Scaffolding";
	} else if (PawnLocation.X > -7900 && PawnLocation.X < -5925 && PawnLocation.Y > -1372 && PawnLocation.Y < -677) {
		MapLocationName = "The Gallery";
	} else if (PawnLocation.X > -7615 && PawnLocation.X < -6000 && PawnLocation.Y > -202 && PawnLocation.Y < 715) {
		MapLocationName = "Containment";
	} else if (PawnLocation.X > -4811 && PawnLocation.X < -2868 && PawnLocation.Y > -668 && PawnLocation.Y < 1185) {
		MapLocationName = "Midlife";
	} else if (PawnLocation.X > -2850 && PawnLocation.X < -500 && PawnLocation.Y > 36 && PawnLocation.Y < 475) {
		MapLocationName = "Grand Crossing";
	} else if (PawnLocation.X > -500 && PawnLocation.X < 2652 && PawnLocation.Y > -532 && PawnLocation.Y < 1045) {
		MapLocationName = "Twins";
	} else if (PawnLocation.X > -7900 && PawnLocation.X < -5156 && PawnLocation.Y > 1060 && PawnLocation.Y < 3802) {
		MapLocationName = "Maze";
	} else if (PawnLocation.X > -4570 && PawnLocation.X < -1588 && PawnLocation.Y > 1717 && PawnLocation.Y < 3659) {
		MapLocationName = "Dais";
	} else if (PawnLocation.X > -475 && PawnLocation.X < 2522 && PawnLocation.Y > 1573 && PawnLocation.Y < 3547) {
		MapLocationName = "Two Bridges";
	} else if (PawnLocation.X > 3235 && PawnLocation.X < 5979 && PawnLocation.Y > 2723 && PawnLocation.Y < 3675) {
		MapLocationName = "Crash Site";
	} else if (PawnLocation.X > 3300 && PawnLocation.X < 7371 && PawnLocation.Y > -1740 && PawnLocation.Y < 2252) {
		MapLocationName = "Final";
	} else if (PawnLocation.X > -2780 && PawnLocation.X < -292 && PawnLocation.Y > -3655 && PawnLocation.Y < -675) {
		MapLocationName = "Mist";
	} else if (PawnLocation.X > 162 && PawnLocation.X < 3163 && PawnLocation.Y > -3675 && PawnLocation.Y < 932) {
		MapLocationName = "Pond";
	} else if (PawnLocation.X > 3620 && PawnLocation.X < 6107 && PawnLocation.Y > -3675 && PawnLocation.Y < -2212) {
		MapLocationName = "Alien";
	} else {
		MapLocationName = "";
	}

	//Display the location on HUD
	Canvas.Font = PlayerFont;
	Canvas.SetDrawColorStruct(WhiteColor);
	//Canvas.TextSize(MapLocationName, TextSize.X, TextSize.Y);
	Canvas.SetPos(SizeX*0.015, SizeY*0.015);
	Canvas.DrawText(MapLocationName,,PlayerNameScale * 1.1 / RatioX,PlayerNameScale * 1.1 / RatioY);

	if(p.Pawn.Health > 0){

		//Player unit health bar and energy bar
		if (p.unitHE == 0 || p.unitHE == 2) {
			playerProject = Canvas.Project(p.Pawn.Location);
			//Unit Health meter
			Canvas.SetDrawColor(255,0,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50);
			Canvas.DrawRect(p.Pawn.Health*0.8,8);
			//Unit Health meter outline
			Canvas.SetDrawColor(128,0,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50);
			Canvas.DrawBox(p.Pawn.HealthMax*0.8,10);
			//Unit Energy meter
			Canvas.SetDrawColor(128,128,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50+10);
			Canvas.DrawRect(p.Pawn.Health*0.8,8);
			//Unit Energy meter outline
			Canvas.SetDrawColor(128,0,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50+10);
			Canvas.DrawBox(p.Pawn.HealthMax*0.8,10);
		}

		if (p.unitHE == 0 || p.unitHE == 1) {
			//Health Bar Background
			if(HealthPercent > 0.65){
				Canvas.SetDrawColor(0,0,0);
				ColorBlink = 0;
			}else{
				if(ColorBlink < 0){
					ColorBlink = 0;
				}else if(ColorBlink > 192){
					ColorBlink = 192;
				}
				intColorBlink = Round(ColorBlink);
				if(intColorBlink == 0){
					ColorBlinkPositive = 1;
				}else if(intColorBlink == 192){
					ColorBlinkPositive = -1;
				}
				ColorBlink += ColorBlinkPositive * (2.1**((1-HealthPercent)*4)-1);
				Canvas.SetDrawColor(intColorBlink,intColorBlink,intColorBlink);
			}
			Canvas.SetPos(50 - (TextSize.X * PlayerNameScale / RatioX),SizeY-200);
			Canvas.DrawRect(p.Pawn.HealthMax*2,64);
			//Health Bar
			Canvas.SetDrawColor(255,0,0);
			Canvas.SetPos(50 - (TextSize.X * PlayerNameScale / RatioX),SizeY-200);
			Canvas.DrawRect(p.Pawn.Health*2,64);
			//Health Bar Outline
			Canvas.SetDrawColor(128,0,0);
			Canvas.SetPos(50 - (TextSize.X * PlayerNameScale / RatioX),SizeY-200);
			Canvas.DrawBox(p.Pawn.HealthMax*2,64);
	
			//Energy Bar Background
			Canvas.SetDrawColor(0,0,0);
			Canvas.SetPos(50 - (TextSize.X * PlayerNameScale / RatioX),SizeY-120);
			Canvas.DrawRect(p.Pawn.HealthMax*2,64);
			//Energy Bar
			Canvas.SetDrawColor(128,128,0);
			Canvas.SetPos(50 - (TextSize.X * PlayerNameScale / RatioX),SizeY-120);
			Canvas.DrawRect(p.Pawn.Health*2,64);
			//Energy Bar Outline
			Canvas.SetDrawColor(192,192,0);
			Canvas.SetPos(50 - (TextSize.X * PlayerNameScale / RatioX),SizeY-120);
			Canvas.DrawBox(p.Pawn.HealthMax*2,64);

			//Draw Numbers
			//Energy Number
			Canvas.Font = PlayerFont;
			Canvas.SetDrawColorStruct(WhiteColor);
			Canvas.TextSize(p.Pawn.Health, TextSize.X, TextSize.Y);
			Canvas.SetPos(70 - (TextSize.X * PlayerNameScale / RatioX) + p.Pawn.HealthMax,SizeY-108);
			Canvas.DrawText(PlayerOwner.Pawn.Health,,PlayerNameScale / RatioX,PlayerNameScale / RatioY);
			//Health Number
			Canvas.SetPos(70 - (TextSize.X * PlayerNameScale / RatioX) + p.Pawn.HealthMax,SizeY-188);
			Canvas.DrawText(PlayerOwner.Pawn.Health,,PlayerNameScale / RatioX,PlayerNameScale / RatioY);
		}
	}else{
		Canvas.SetPos(SizeX*0.355 - (TextSize.X * PlayerNameScale / RatioX), SizeY*0.4);
		Canvas.DrawText("YOU ARE DEAD",,PlayerNameScale * 2 / RatioX,PlayerNameScale * 2 / RatioY);
	}

	//Draw the skill tree
	if (p.bSkill) {
		Canvas.Font = Canvas.GetDefaultCanvasFont();
		
		Canvas.SetPos(SizeX * 0.5, SizeY * 0.1);
		Canvas.SetDrawColor(0, 0, 0, 200);
		Canvas.DrawRect(SizeX * 0.38, SizeY * 0.7);

		Canvas.SetPos(SizeX * 0.5, SizeY * 0.1);
		Canvas.SetDrawColor(0, 255, 0);
		Canvas.DrawBox(SizeX * 0.38, SizeY * 0.7);

		Canvas.SetPos(SizeX * 0.52, SizeY * 0.15);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawRect(SizeX * 0.1, SizeY * 0.07);
		Canvas.SetPos(SizeX * 0.55, SizeY * 0.17);
		Canvas.SetDrawColor(0, 0, 0);
		Canvas.DrawText("Health");

		Canvas.SetPos(SizeX * 0.64, SizeY * 0.15);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawRect(SizeX * 0.1, SizeY * 0.07);
		Canvas.SetPos(SizeX * 0.67, SizeY * 0.17);
		Canvas.SetDrawColor(0, 0, 0);
		Canvas.DrawText("Energy");

		Canvas.SetPos(SizeX * 0.76, SizeY * 0.15);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawRect(SizeX * 0.1, SizeY * 0.07);
		Canvas.SetPos(SizeX * 0.79, SizeY * 0.17);
		Canvas.SetDrawColor(0, 0, 0);
		Canvas.DrawText("Speed");

		Canvas.SetPos(SizeX * 0.52, SizeY * 0.25);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawRect(SizeX * 0.1, SizeY * 0.07);
		Canvas.SetPos(SizeX * 0.55, SizeY * 0.27);
		Canvas.SetDrawColor(0, 0, 0);
		Canvas.DrawText("Health 2");

		Canvas.SetPos(SizeX * 0.64, SizeY * 0.25);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawRect(SizeX * 0.1, SizeY * 0.07);
		Canvas.SetPos(SizeX * 0.67, SizeY * 0.27);
		Canvas.SetDrawColor(0, 0, 0);
		Canvas.DrawText("Energy 2");

		Canvas.SetPos(SizeX * 0.76, SizeY * 0.25);
		Canvas.SetDrawColor(255, 255, 255);
		Canvas.DrawRect(SizeX * 0.1, SizeY * 0.07);
		Canvas.SetPos(SizeX * 0.79, SizeY * 0.27);
		Canvas.SetDrawColor(0, 0, 0);
		Canvas.DrawText("Speed 2");

	}
}

DefaultProperties
{
	PlayerFont="UI_Fonts.MultiFonts.MF_HudLarge"
	PlayerNameScale=0.25
	ColorBlink = 0
	intColorBlink = 0
	ColorBlinkPositive = 1
}