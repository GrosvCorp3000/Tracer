class G6HUD extends HUD;

var float ColorBlink;
var int intColorBlink;
var int ColorBlinkPositive;
var Font PlayerFont;
var float PlayerNameScale;

/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	local float HealthPercent;
	local Vector2D TextSize;
	local G6PlayerController p;
	p = G6PlayerController (PlayerOwner);
	HealthPercent = p.Pawn.Health / float(p.Pawn.HealthMax);

	super.DrawHUD();

	if (p.debug) {
		Canvas.SetPos(SizeX * 0.7, SizeY * 0.1);
		Canvas.SetDrawColor(0, 0, 255);
		Canvas.DrawBox(SizeX * 0.2, SizeY * 0.5);

		Canvas.SetDrawColor(255, 255, 0);
		Canvas.SetPos(SizeX * 0.72, SizeY * 0.20);
		Canvas.DrawText("Camera Offset X:"$p.camOffset.X);
		Canvas.DrawText("Camera Offset Y:"$p.camOffset.Y);
		Canvas.DrawText("Camera Offset Z:"$p.camOffset.Z);
	}

	if(p.Pawn.Health > 0){
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
	}else{
		Canvas.SetPos(SizeX*0.355 - (TextSize.X * PlayerNameScale / RatioX), SizeY*0.4);
		Canvas.DrawText("YOU ARE DEAD",,PlayerNameScale * 2 / RatioX,PlayerNameScale * 2 / RatioY);
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