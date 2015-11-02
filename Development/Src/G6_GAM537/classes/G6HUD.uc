class G6HUD extends HUD;

var CanvasIcon HealthIcon;
var CanvasIcon HealthBackgroundIcon;

var Texture2D DefaultTexture;
var Font PlayerFont;
var float PlayerNameScale;

/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	local Vector2D TextSize;
	local G6PlayerController p;
	p = G6PlayerController (PlayerOwner);

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

	//Draw Player health
	Canvas.DrawIcon(HealthIcon, 8, 8, 0.5);
	Canvas.Font = PlayerFont;
	Canvas.SetDrawColorStruct(WhiteColor);
	DrawIconStretched(HealthBackgroundIcon, 0, 0, 2.167, 0.875);
	Canvas.TextSize(p.Pawn.Health, TextSize.X, TextSize.Y);
	Canvas.SetPos(96 - (TextSize.X * PlayerNameScale / RatioX),0);
	Canvas.DrawText(PlayerOwner.Pawn.Health,,PlayerNameScale / RatioX,PlayerNameScale / RatioY);

	//Draw Player Name
	Canvas.SetPos(0, SizeY - 64);
	Canvas.DrawTileStretched(DefaultTexture,256, 64, 8, 72, 112, 48, ColorToLinearColor(GreenColor), true, true, 1.0);
	Canvas.TextSize(UTPlayerController(PlayerOwner).PlayerReplicationInfo.PlayerName, TextSize.X, TextSize.Y);
	Canvas.SetPos(128 - ((TextSize.X * PlayerNameScale / RatioX) / 2), SizeY - 28 - ((TextSize.Y * PlayerNameScale / RatioY) / 2));
	Canvas.DrawText(UTPlayerController(PlayerOwner).PlayerReplicationInfo.PlayerName,,PlayerNameScale / RatioX,PlayerNameScale / RatioY);
}

/**
 * Draw a CanvasIcon stretched at the desired canvas position.
 */
final function DrawIconStretched(CanvasIcon Icon, float X, float Y, optional float ScaleX, optional float ScaleY)
{
   if (Icon.Texture != None)
   {
      // verify properties are valid
      if (ScaleX <= 0.f)
      {
         ScaleX = 1.f;
      }

      if (ScaleY <= 0.f)
      {
         ScaleY = 1.f;
      }

      if (Icon.UL == 0.f)
      {
         Icon.UL = Icon.Texture.GetSurfaceWidth();
      }

      if (Icon.VL == 0.f)
      {
         Icon.VL = Icon.Texture.GetSurfaceHeight();
      }

      // set the canvas position
      Canvas.SetPos(X, Y);

      // and draw the texture
      Canvas.DrawTileStretched(Icon.Texture, Abs(Icon.UL) * ScaleX, Abs(Icon.VL) * ScaleY,
                           Icon.U, Icon.V, Icon.UL, Icon.VL,, true, true);
   }
}

DefaultProperties
{
	DefaultTexture=Texture2D'UDNHUDContent.UDN_HUDGraphics'
	PlayerFont="UI_Fonts.MultiFonts.MF_HudLarge"
	PlayerNameScale=0.25
	HealthIcon=(Texture=Texture2D'UDNHUDContent.UDN_HUDGraphics',U=72,V=8,UL=48,VL=48)
	HealthBackgroundIcon=(Texture=Texture2D'UDNHUDContent.UDN_HUDGraphics',U=8,V=8,UL=48,VL=48)
}
