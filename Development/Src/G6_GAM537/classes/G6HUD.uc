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
	local G6PlayerInput p_input;
	local float HealthPercent;
	local float EnergyPercent;
	local int drawSkillTree1;
	local int drawSkillTree2;
	local int drawSkillTree3;
	local bool insideSkillBox;
	local Texture2D weaponTex;
	local float weaponUIscale;
	local UTWeapon cur_weap;

	p = G6PlayerController (PlayerOwner);
	p_input = G6PlayerInput (p.PlayerInput);
	HealthPercent = p.Pawn.Health / float(p.Pawn.HealthMax);
	EnergyPercent = p.cEnergy / float(p.cEnergyMax);

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

		Canvas.DrawText("Battle Mode: "$p.bBattleMode);

		cur_weap = UTWeapon (p.pawn.Weapon);
		Canvas.DrawText("Weapon: "$cur_weap.Name);
		Canvas.DrawText("Weapon Ammo: "$cur_weap.GetAmmoCount());
		Canvas.DrawText("Weapon Max Ammo: "$cur_weap.MaxAmmoCount);
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
	} else if (PawnLocation.X > -475 && PawnLocation.X < 2523 && PawnLocation.Y > 1573 && PawnLocation.Y < 3547){
		MapLocationName = "Two Bridges";
	} else if (PawnLocation.X > 3235 && PawnLocation.X < 5979 && PawnLocation.Y > 2723 && PawnLocation.Y < 3675) {
		MapLocationName = "Crash Site";
	} else if (PawnLocation.X > 3300 && PawnLocation.X < 7371 && PawnLocation.Y > -1740 && PawnLocation.Y < 2252) {
		MapLocationName = "Final";
	} else if (PawnLocation.X > -2780 && PawnLocation.X < -292 && PawnLocation.Y > -3655 && PawnLocation.Y < -675) {
		MapLocationName = "Mist";
	} else if (PawnLocation.X > 162 && PawnLocation.X < 3163 && PawnLocation.Y > -3675 && PawnLocation.Y < -932) {
		MapLocationName = "Pond";
	} else if (PawnLocation.X > 3620 && PawnLocation.X < 6107 && PawnLocation.Y > -3675 && PawnLocation.Y < -2212) {
		MapLocationName = "Alien";
	} else {
		MapLocationName = "";
	}

	//Display the location on HUD
	Canvas.Font = PlayerFont;
	Canvas.SetDrawColorStruct(WhiteColor);
	Canvas.SetPos(SizeX*0.015, SizeY*0.015);
	Canvas.DrawText(MapLocationName,,PlayerNameScale * 1.1 / RatioX,PlayerNameScale * 1.1 / RatioY);

	if(p.Pawn.Health > 0){

		//Player unit health bar and energy bar
		if (p.unitHE == 0 || p.unitHE == 2) {
			playerProject = Canvas.Project(p.Pawn.Location);
			//Unit Health meter
			Canvas.SetDrawColor(255,0,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50);
			Canvas.DrawRect(HealthPercent*80,8);
			//Unit Health meter outline
			Canvas.SetDrawColor(128,0,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50);
			Canvas.DrawBox(80,10);
			//Unit Energy meter
			Canvas.SetDrawColor(128,128,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50+10);
			Canvas.DrawRect(EnergyPercent*80,8);
			//Unit Energy meter outline
			Canvas.SetDrawColor(128,0,0);
			Canvas.SetPos(playerProject.X-45, playerProject.Y+50+10);
			Canvas.DrawBox(80,10);
		}

		if (p.unitHE == 0 || p.unitHE == 1) {
			//Health Bar Background
			if(HealthPercent > 0.65){
				Canvas.SetDrawColor(0,0,0);
				ColorBlink = 0;
			}else{
				FClamp(ColorBlink, 0, 192);
				intColorBlink = Round(ColorBlink);
				if(intColorBlink == 0){
					ColorBlinkPositive = 1;
				}else if(intColorBlink == 192){
					ColorBlinkPositive = -1;
				}
				ColorBlink += ColorBlinkPositive * (2.1**((1-HealthPercent)*4)-1);
				Canvas.SetDrawColor(intColorBlink,intColorBlink,intColorBlink);
			}
			Canvas.SetPos(30 - (TextSize.X * PlayerNameScale / RatioX),SizeY-100);
			Canvas.DrawRect(200,32);
			//Health Bar
			Canvas.SetDrawColor(255,0,0);
			Canvas.SetPos(30 - (TextSize.X * PlayerNameScale / RatioX),SizeY-100);
			Canvas.DrawRect(HealthPercent*200,32);
			//Health Bar Outline
			Canvas.SetDrawColor(128,0,0);
			Canvas.SetPos(30 - (TextSize.X * PlayerNameScale / RatioX),SizeY-100);
			Canvas.DrawBox(200,32);
	
			//Energy Bar Background
			Canvas.SetDrawColor(0,0,0);
			Canvas.SetPos(30 - (TextSize.X * PlayerNameScale / RatioX),SizeY-48);
			Canvas.DrawRect(200,32);
			//Energy Bar
			Canvas.SetDrawColor(128,128,0);
			Canvas.SetPos(30 - (TextSize.X * PlayerNameScale / RatioX),SizeY-48);
			Canvas.DrawRect(EnergyPercent*200,32);
			//Energy Bar Outline
			Canvas.SetDrawColor(192,192,0);
			Canvas.SetPos(30 - (TextSize.X * PlayerNameScale / RatioX),SizeY-48);
			Canvas.DrawBox(200,32);

			//Draw Numbers
			Canvas.Font = PlayerFont;
			Canvas.SetDrawColorStruct(WhiteColor);
			Canvas.TextSize(p.Pawn.Health, TextSize.X, TextSize.Y);
			//Health Number
			Canvas.SetPos(70 - (TextSize.X * PlayerNameScale / RatioX) + 100 - (Clamp(1-FCeil(p.Pawn.Health/100),0,1) * 10) - (Clamp(1-FCeil(p.Pawn.Health/10),0,1) * 10),SizeY-95);
			Canvas.DrawText(p.Pawn.Health,,(PlayerNameScale/2) / RatioX,(PlayerNameScale/2) / RatioY);
			//Energy Number
			Canvas.SetPos(70 - (TextSize.X * PlayerNameScale / RatioX) + 100 - (Clamp(1-FCeil(p.Pawn.Health/100),0,1) * 10) - (Clamp(1-FCeil(p.Pawn.Health/10),0,1) * 10),SizeY-43);
			Canvas.DrawText(p.cEnergy,,(PlayerNameScale/2) / RatioX,(PlayerNameScale/2) / RatioY);
		}
		
		
	}else{
		Canvas.Font = PlayerFont;
		Canvas.SetDrawColorStruct(WhiteColor);
		Canvas.TextSize(p.Pawn.Health, TextSize.X, TextSize.Y);
		Canvas.SetPos(SizeX*0.355 - (TextSize.X * PlayerNameScale / RatioX), SizeY*0.4);
		Canvas.DrawText("YOU ARE DEAD",,PlayerNameScale * 2 / RatioX,PlayerNameScale * 2 / RatioY);
	}

	//Draw the level and skill points display
	Canvas.Font = PlayerFont;
	Canvas.SetDrawColorStruct(WhiteColor);
	Canvas.SetPos(SizeX*0.85, SizeY*0.9);
	if (p.bSkill) {
		Canvas.DrawText("Skill Pts: "$p.cSkPts,,PlayerNameScale / RatioX,PlayerNameScale * 1.1 / RatioY);		
	} else {
		Canvas.DrawText("Level: "$p.cLevel,,PlayerNameScale / RatioX,PlayerNameScale * 1.1 / RatioY);
	}
	
	//Draw the skill tree
	if (p.bSkill) {
		Canvas.Font = Canvas.GetDefaultCanvasFont();
		
		Canvas.SetPos(SizeX * 0.5, SizeY * 0.1);
		Canvas.SetDrawColor(0, 0, 0, 200);
		Canvas.DrawRect(SizeX * 0.38, SizeY * 0.67);

		Canvas.SetPos(SizeX * 0.5, SizeY * 0.1);
		Canvas.SetDrawColor(0, 255, 0);
		Canvas.DrawBox(SizeX * 0.38, SizeY * 0.67);

		insideSkillBox = false;
		for(drawSkillTree1=0; drawSkillTree1<3; drawSkillTree1++)
		{
			for(drawSkillTree2=0; drawSkillTree2<5; drawSkillTree2++)
			{
				drawSkillTree3 = drawSkillTree2;
				if(drawSkillTree2>2){
					drawSkillTree3++;
				}
				if(p_input.MousePosition.X > SizeX * (0.52+drawSkillTree1*0.12) && p_input.MousePosition.X < SizeX * (0.62+drawSkillTree1*0.12) && p_input.MousePosition.Y > SizeY * (0.15+drawSkillTree3*0.1) && p_input.MousePosition.Y < SizeY * (0.22+drawSkillTree3*0.1)){
					insideSkillBox = true;
				}
			}
		}

		if(p_input.bAttemptSelect && !insideSkillBox){
			p_input.bAttemptSelect = false;
		}

		for(drawSkillTree1=0; drawSkillTree1<3; drawSkillTree1++)
		{
			for(drawSkillTree2=0; drawSkillTree2<5; drawSkillTree2++)
			{
				drawSkillTree3 = drawSkillTree2;
				if(drawSkillTree2>2){
					drawSkillTree3++;
				}
				Canvas.SetPos(SizeX * (0.52+drawSkillTree1*0.12), SizeY * (0.15+drawSkillTree3*0.1));
				if(p_input.MousePosition.X > SizeX * (0.52+drawSkillTree1*0.12) && p_input.MousePosition.X < SizeX * (0.62+drawSkillTree1*0.12) && p_input.MousePosition.Y > SizeY * (0.15+drawSkillTree3*0.1) && p_input.MousePosition.Y < SizeY * (0.22+drawSkillTree3*0.1)){
					Canvas.SetDrawColor(200, 200, 225);
					if(p_input.bAttemptSelect && p.skills[drawSkillTree1*5+drawSkillTree2] == 0 && p.cSkPts >= p.skillRequirement[drawSkillTree1*5+drawSkillTree2]){
						//Health Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 0){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Health2 Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 1 && p.skills[0] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Endure Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 2 && p.skills[1] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Laser Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 3){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Laser Upgrade Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 4 && p.skills[3] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Energy Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 5){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Energy2 Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 6 && p.skills[5] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Recharge Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 7 && p.skills[6] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Shotgun Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 8){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Shotgun Upgrade Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 9 && p.skills[8] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Speed Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 10){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Speed2 Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 11 && p.skills[10] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Slow Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 12 && p.skills[11] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Rocket Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 13){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						//Rocket Upgrade Requirement
						if(drawSkillTree1*5+drawSkillTree2 == 14 && p.skills[13] == 1){
							p.skills[drawSkillTree1*5+drawSkillTree2] = 1;
							p.cSkPts -= p.skillRequirement[drawSkillTree1*5+drawSkillTree2];
						}
						p_input.bAttemptSelect = false;
					}
				}else{
					Canvas.SetDrawColor(255, 255, 255);
				}
				if(p.skills[drawSkillTree1*5+drawSkillTree2] == 1){
					Canvas.SetDrawColor(230, 230, 75);
				}
				Canvas.DrawRect(SizeX * 0.1, SizeY * 0.07);
				if(drawSkillTree1*5+drawSkillTree2 != 2 && drawSkillTree1*5+drawSkillTree2 != 4 && drawSkillTree1*5+drawSkillTree2 != 7 && drawSkillTree1*5+drawSkillTree2 != 9 && drawSkillTree1*5+drawSkillTree2 != 12 && drawSkillTree1*5+drawSkillTree2 != 14){
					if(p.skills[drawSkillTree1*5+drawSkillTree2] == 1){
						Canvas.SetDrawColor(230, 230, 75);
					}else{
						Canvas.SetDrawColor(255, 255, 255);
					}
					Canvas.SetPos(SizeX * (0.5695+drawSkillTree1*0.12), SizeY * (0.22+drawSkillTree3*0.1));
					Canvas.DrawBox(SizeX * 0.001, SizeY * 0.03);
				}
				//Skill Text
				Canvas.SetPos(SizeX * (0.55+drawSkillTree1*0.12), SizeY * (0.17+(drawSkillTree3)*0.1));
				Canvas.SetDrawColor(0, 0, 0);
				Canvas.DrawText(""$p.skillNames[drawSkillTree1*5+drawSkillTree2]);
				Canvas.SetPos(SizeX * (0.525+drawSkillTree1*0.12), SizeY * (0.19+(drawSkillTree3)*0.1));
				Canvas.DrawText(""$p.skillRequirement[drawSkillTree1*5+drawSkillTree2]);

				if(drawSkillTree1*5+drawSkillTree2 != 0 && drawSkillTree1*5+drawSkillTree2 != 3 && drawSkillTree1*5+drawSkillTree2 != 5 && drawSkillTree1*5+drawSkillTree2 != 8 && drawSkillTree1*5+drawSkillTree2 != 10 && drawSkillTree1*5+drawSkillTree2 != 13){
					Canvas.SetDrawColor(255, 255, 255);
					Canvas.SetPos(SizeX * (0.57+drawSkillTree1*0.12), SizeY * (0.120+drawSkillTree3*0.1));
					Canvas.DrawRect(SizeX * 0.001, SizeY * 0.03);
				}
			}
		}

		//Now draw the cursor on screen
		Canvas.SetDrawColor(0,0,230);
		Canvas.SetPos(p_input.MousePosition.X, p_input.MousePosition.Y);
		Canvas.DrawTexture(Texture2D'UDKHUD.cursor_png', 1);
		
	}

	//Draw Weapon HUD
	Canvas.SetDrawColor(255,255,255);
	weaponUIscale = 0.9;
	//First weapon
	weaponTex = Texture2D'UDKHUD.ut3_weapon4_color';
	Canvas.SetPos(SizeX * 0.3 + weaponTex.SizeX * weaponUIscale * 0.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
	if(p.currentWeapon == 1){
		Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
	}
	Canvas.SetPos(SizeX * 0.3 + weaponTex.SizeX * weaponUIscale * 0.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
	Canvas.Font = PlayerFont;
	Canvas.DrawText("1",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
	Canvas.SetPos(SizeX * 0.3, SizeY * 0.85);
	Canvas.DrawTexture(weaponTex, weaponUIscale);
	//Second weapon
	Canvas.SetPos(SizeX * 0.32 + weaponTex.SizeX * weaponUIscale * 1.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
	if(p.currentWeapon == 2){
		Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
	}
	Canvas.SetPos(SizeX * 0.32 + weaponTex.SizeX * weaponUIscale * 1.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
	Canvas.DrawText("2",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
	Canvas.SetPos(SizeX * 0.32 + weaponTex.SizeX * weaponUIscale, SizeY * 0.85);
	Canvas.DrawTexture(Texture2D'UDKHUD.ut3_weapon10_color', weaponUIscale);
	//Third weapon
	Canvas.SetPos(SizeX * 0.34 + weaponTex.SizeX * weaponUIscale * 2.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
	if(p.currentWeapon == 3){
		Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
	}
	Canvas.SetPos(SizeX * 0.34 + weaponTex.SizeX * weaponUIscale * 2.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
	Canvas.DrawText("3",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
	Canvas.SetPos(SizeX * 0.34 + weaponTex.SizeX * weaponUIscale * 2, SizeY * 0.85);
	Canvas.DrawTexture(Texture2D'UDKHUD.ut3_weapon6_color', weaponUIscale);
	//Fourth weapon
	Canvas.SetPos(SizeX * 0.36 + weaponTex.SizeX * weaponUIscale * 3.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
	if(p.currentWeapon == 4){
		Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
	}
	Canvas.SetPos(SizeX * 0.36 + weaponTex.SizeX * weaponUIscale * 3.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
	Canvas.DrawText("4",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
	Canvas.SetPos(SizeX * 0.36 + weaponTex.SizeX * weaponUIscale * 3, SizeY * 0.85);
	Canvas.DrawTexture(Texture2D'UDKHUD.ut3_weapon8_color', weaponUIscale);

	//HealthIcon=(Texture=Texture2D'UDNHUDContent.UDN_HUDGraphics',U=72,V=8,UL=48,VL=48)
		//Texture2D'UDKHUD.udk_inventory_I1'
		//Texture2D'UDKHUD.ut3_weapon5_color'
	//Texture2D'UDKHUD.ut3_weapon6_color'
	//Texture2D'UDKHUD.ut3_weapon7_color'
	//Texture2D'UDKHUD.ut3_weapon8_color'
	//Texture2D'UDKHUD.ut3_weapon9_color'
	//Texture2D'UDKHUD.ut3_weapon4_color'

}

DefaultProperties
{
	PlayerFont="UI_Fonts.MultiFonts.MF_HudLarge"
	PlayerNameScale=0.25
	ColorBlink = 0
	intColorBlink = 0
	ColorBlinkPositive = 1
}