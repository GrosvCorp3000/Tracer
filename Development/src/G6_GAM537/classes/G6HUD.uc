class G6HUD extends HUD;

var float ColorBlink;
var int intColorBlink;
var int ColorBlinkPositive;
var Font PlayerFont;
var float PlayerNameScale;
var String MapLocationName;
var Vector PawnLocation;
var LinearColor LC_White;
var LinearColor LC_Yellow;
var LinearColor LC_Red;
var LinearColor LC_Blue;
var LinearColor LC_Green;
var intPoint mousePos;

/**
 * Draws a textured centered around the current position
 */
function DrawTileCentered(texture2D Tex, float xl, float yl, float u, float v, float ul, float vl, LinearColor C)
{
	local float x,y;

	x = Canvas.CurX - (xl * 0.5);
	y = Canvas.CurY - (yl * 0.5);

	Canvas.SetPos(x,y, Canvas.CurZ);
	Canvas.DrawTile(Tex, xl,yl,u,v,ul,vl,C);
}

/**
 * This is the main drawing pump.  It will determine which hud we need to draw (Game or PostGame).  Any drawing that should occur
 * regardless of the game state should go here.
 */
function DrawHUD()
{
	local vector playerProject;
	local vector BossProject;
	local vector aimLocation;
	local vector aimProject;
	local Vector2D TextSize;
	local G6PlayerController p;
	local G6PlayerInput p_input;
	local int playerHealth;
	local int playerHealthMax;
	local float HealthPercent;
	local float BossHealthPercent;
	local float EnergyPercent;
	local float SpecialPercent;
	local int mapRoom;
	local int drawSkillTree1;
	local int drawSkillTree2;
	local int drawSkillTree3;
	local bool insideSkillBox;
	local Texture2D weaponTex;
	local float weaponUIscale;
	local UTWeapon cur_weap;
	//Map Variables
	local bool inRoom;
	local Texture2D mapTexture;
	local intPoint mapDraw;
	local intPoint playerMapVisual;
	local int mapScreenSize;
	local intPoint mapScreenLoc;
	local intPoint mapFogLoc;
	local intPoint mapFogLoc2;
	local Trigger T;
	local G6BPawn_Boss Boss;

	local int specialRand;
	local int l_minute;
	local int l_second;

	mapTexture = Texture2D'G6.Textures.Map';

	p = G6PlayerController (PlayerOwner);
	p_input = G6PlayerInput (p.PlayerInput);
	playerHealth = p.Pawn.Health;
	playerHealthMax = p.Pawn.HealthMax;
	HealthPercent = playerHealth / float(playerHealthMax);
	EnergyPercent = p.cEnergy / float(p.cEnergyMax);

	//Update the Special Values and Bar
	if (p.bSpecial) {
		if (p.skills[12] == 1)
			specialRand = Rand(8);
		else
			specialRand = Rand(5);
		if (specialRand==1)
			p.cSpecial = (Clamp(p.cSpecial - 0.00001, 0, 100));
		if (p.cSpecial <= 1)
			p.toggleSpecial();
	}
	SpecialPercent = p.cSpecial / p.cSpecialMax;

	super.DrawHUD();

	//Draw aiming recticle on screen
	aimLocation = p.pawn.Location + vector(p.Pawn.Rotation) * 300;
	aimProject = Canvas.Project(aimLocation);
	Canvas.SetPos(aimProject.X, aimProject.Y, aimProject.Z);
	switch (p.currentWeapon)
	{
		case 1:
			DrawTileCentered(Texture2D'UI_HUD.HUD.UI_HUD_BaseA', 31, 22, 216, 102, 56, 40, LC_Green);
			break;
		case 2:
			DrawTileCentered(Texture2D'UI_HUD.HUD.UI_HUD_BaseA', 31, 22, 216, 102, 56, 40, LC_Yellow);
			break;
		case 3:
			DrawTileCentered(Texture2D'UI_HUD.HUD.UI_HUD_BaseA', 31, 22, 216, 102, 56, 40, LC_Blue);
			break;
		case 4:
			DrawTileCentered(Texture2D'UI_HUD.HUD.UI_HUD_BaseA', 31, 22, 216, 102, 56, 40, LC_Red);
			break;
		default:
			DrawTileCentered(Texture2D'UI_HUD.HUD.UI_HUD_BaseA', 31, 22, 216, 102, 56, 40, LC_White);
			break;
	}

	if (p.debug) {
		
		Canvas.SetPos(SizeX * 0.1, SizeY * 0.1);
		Canvas.SetDrawColor(0, 0, 255);
		Canvas.DrawBox(SizeX * 0.2, SizeY * 0.6);

		Canvas.SetDrawColor(255, 255, 0);
		Canvas.SetPos(SizeX * 0.12, SizeY * 0.20);

		Canvas.DrawText("RemainingTime: "$Self.WorldInfo.GRI.RemainingTime);
		Canvas.DrawText("Camera Offset X: "$p.camOffset.X);
		Canvas.DrawText("Camera Offset Y: "$p.camOffset.Y);
		Canvas.DrawText("Camera Offset Z: "$p.camOffset.Z);

		Canvas.DrawText("Aim Location X: "$AimLocation.X);
		Canvas.DrawText("Aim Location Y: "$AimLocation.Y);
		Canvas.DrawText("Aim Location Z: "$AimLocation.Z);

		Canvas.DrawText("Player Location X: "$p.Pawn.Location.X);
		Canvas.DrawText("Player Location Y: "$p.Pawn.Location.Y);
		Canvas.DrawText("Player Location Z: "$p.Pawn.Location.Z);

		Canvas.DrawText("Player Speed: "$p.Pawn.GroundSpeed);

		Canvas.DrawText("Battle Mode: "$p.bBattleMode);
		Canvas.DrawText("lastCheckPoint: "$p.lastCheckPoint);

		Canvas.DrawText("CurrentRoom: "$p.roomName[p.curRoom]);
		Canvas.DrawText("Room Trigger: "$p.roomExplored[p.curRoom]);
		Canvas.DrawText("Room Cleared: "$p.roomCleared[p.curRoom]);
		Canvas.DrawText("Max Bots to Kill: "$p.roomSpawns[p.curRoom]);
		Canvas.DrawText("Current Bots Killed: "$p.roomCurKill);
		Canvas.DrawText("Respawn Attempt: "$p.bRespawning);

		cur_weap = UTWeapon (p.pawn.Weapon);
		Canvas.DrawText("Weapon: "$cur_weap.Name);
		Canvas.DrawText("Weapon Ammo: "$cur_weap.GetAmmoCount());
		Canvas.DrawText("Weapon Max Ammo: "$cur_weap.MaxAmmoCount);
	}


	//Determine the location
	PawnLocation = p.Pawn.Location;
	inRoom = false;
	for(mapRoom = 0; mapRoom < 17; mapRoom++){
		if(PawnLocation.X < p.roomLoc[mapRoom].X && PawnLocation.Y > p.roomLoc[mapRoom].Y && PawnLocation.X > p.roomLoc2[mapRoom].X && PawnLocation.Y < p.roomLoc2[mapRoom].Y){
			MapLocationName = p.roomName[mapRoom];
			if(mapRoom != 8 || (mapRoom == 8 && PawnLocation.Z >= -337)){
				p.curRoom = mapRoom;
				if(mapRoom == 3){
					p.roomExplored[mapRoom] = 1;
				}
				inRoom = true;
			}
		}
	}
	if(!inRoom){
		MapLocationName = " ";
	}

	for(mapRoom = 0; mapRoom < 19; mapRoom++){
		if(PawnLocation.X < p.hallLoc[mapRoom].X && PawnLocation.Y > p.hallLoc[mapRoom].Y && PawnLocation.X > p.hallLoc2[mapRoom].X && PawnLocation.Y < p.hallLoc2[mapRoom].Y){
			if(!p.bBattleMode && p.Pawn.Health == p.Pawn.HealthMax){
				if(mapRoom != 5 && mapRoom != 6 && mapRoom != 8){
					p.lastCheckPoint = mapRoom;
					p.hallExplored[mapRoom] = 1;
				}else if(mapRoom == 5 && PawnLocation.Z < -337){
					p.lastCheckPoint = 5;
					p.hallExplored[mapRoom] = 1;
				}else if(mapRoom == 6 && PawnLocation.Z > -337){
					p.lastCheckPoint = 6;
					p.hallExplored[mapRoom] = 1;
				}else if(mapRoom == 8 && PawnLocation.Z < -337){
					p.lastCheckPoint = 8;
					p.hallExplored[mapRoom] = 1;
				}
				p.CheckPointSave();
			}
		}
	}

	//Display the location on HUD
	Canvas.Font = PlayerFont;
	Canvas.SetPos(SizeX*0.015, SizeY*0.015);
	if (p.roomCleared[p.curRoom] == 0 || MapLocationName == " " ) {
		if (p.roomCleared[p.curRoom] == 0 && p.roomExplored[p.curRoom] == 1 && p.curRoom != 3)
			Canvas.SetDrawColorStruct(RedColor);
		else
			Canvas.SetDrawColorStruct(WhiteColor);
		Canvas.DrawText(MapLocationName,,PlayerNameScale * 1.1 / RatioX,PlayerNameScale * 1.1 / RatioY);
	}else {
		Canvas.SetDrawColorStruct(GreenColor);
		Canvas.DrawText("Cleared: "$MapLocationName,,PlayerNameScale * 1.1 / RatioX,PlayerNameScale * 1.1 / RatioY);
		if(p.curRoom == 15){
			Canvas.Font = PlayerFont;
			Canvas.SetDrawColorStruct(WhiteColor);
			Canvas.SetPos(SizeX*0.45 - (TextSize.X * PlayerNameScale / RatioX), SizeY*0.4);
			Canvas.DrawText("YOU WIN!",,PlayerNameScale * 2 / RatioX,PlayerNameScale * 2 / RatioY);
		}
	}

	//Display Time
	Canvas.Font = PlayerFont;
	Canvas.SetPos(SizeX*0.9, SizeY*0.015);
	Canvas.SetDrawColorStruct(WhiteColor);

	l_minute = 0;
	l_second = 0;
	l_minute = Self.WorldInfo.GRI.ElapsedTime/60;
	l_second = Self.WorldInfo.GRI.ElapsedTime - l_minute * 60;
	Canvas.DrawText(l_minute$": "$l_second,,PlayerNameScale * 1.1 / RatioX,PlayerNameScale * 1.1 / RatioY);

	//Check if the Room is cleared
	if (p.roomCleared[p.curRoom] == 0 && p.roomExplored[p.curRoom] == 1 && p.roomSpawns[p.curRoom] == p.roomCurKill)
	{
		p.roomCleared[p.curRoom] = 1;
		p.bBattleMode = false;
		p.cSkPts += p.roomPoints[p.curRoom];
		if (p.bSpecial)
			p.toggleSpecial();
		p.cSpecial *= 0.8;
		foreach AllActors( class'Trigger', T )
		{
			T.SetCollision(True);
		}
		p.roomCurKill = 0;
	}

	if(playerHealth > 0){

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

			//Also draw the Boss's Health
			foreach AllActors( class'G6BPawn_Boss', Boss ) 
			{
				BossProject = Canvas.Project(Boss.Location);
				BossHealthPercent = Boss.Health / float(Boss.HealthMax);
				//Unit Health meter
				Canvas.SetDrawColor(255,0,0);
				Canvas.SetPos(BossProject.X-40, BossProject.Y+55);
				Canvas.DrawRect(BossHealthPercent*100,8);
				//Unit Health meter outline
				Canvas.SetDrawColor(128,0,0);
				Canvas.SetPos(BossProject.X-40, BossProject.Y+55);
				Canvas.DrawBox(100,10);
			}
		}

		if (p.unitHE == 0 || p.unitHE == 1) {
			//Health Bar Background
			if(HealthPercent > 0.65){
				Canvas.SetDrawColor(0,0,0);
				ColorBlink = 0;
			}else{
				ColorBlink = FClamp(ColorBlink, 0, 192);
				intColorBlink = Round(ColorBlink);
				if(intColorBlink <= 0){
					ColorBlinkPositive = 1;
				}else if(intColorBlink >= 192){
					ColorBlinkPositive = -1;
				}
				ColorBlink += ColorBlinkPositive * (2.1**((1-HealthPercent)*4)-1);
				Canvas.SetDrawColor(intColorBlink,intColorBlink,intColorBlink);
			}
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-100);
			Canvas.DrawRect(200,32);
			//Health Bar
			Canvas.SetDrawColor(255,0,0);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-100);
			Canvas.DrawRect(HealthPercent*200,32);
			//Health Bar Outline
			Canvas.SetDrawColor(128,0,0);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-100);
			Canvas.DrawBox(200,32);
	
			//Energy Bar Background
			Canvas.SetDrawColor(0,0,0);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-48);
			Canvas.DrawRect(200,32);
			//Energy Bar
			Canvas.SetDrawColor(128,128,0);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-48);
			Canvas.DrawRect(EnergyPercent*200,32);
			//Energy Bar Outline
			Canvas.SetDrawColor(192,192,0);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-48);
			Canvas.DrawBox(200,32);

			//Special Bar Background
			Canvas.SetDrawColor(0,0,0);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-152);
			Canvas.DrawRect(150,32);
			//Special Bar
			Canvas.SetDrawColor(0,0,170);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-152);
			Canvas.DrawRect(SpecialPercent*150,32);
			//Special Bar Outline
			Canvas.SetDrawColor(0,0,255);
			Canvas.SetPos(60 - (TextSize.X * PlayerNameScale / RatioX),SizeY-152);
			Canvas.DrawBox(150,32);
			//Special Usable
			Canvas.SetPos(60-(TextSize.X * PlayerNameScale / RatioX)+112,SizeY-152);
			Canvas.DrawBox(1,32);
			if(SpecialPercent < 0.75){
				Canvas.SetDrawColor(64,64,96);
			}else{
				Canvas.SetDrawColor(156,156,255);
			}
			Canvas.SetPos(60-(TextSize.X * PlayerNameScale / RatioX)+130,SizeY-146);
			Canvas.DrawText("F",,(PlayerNameScale/2) / RatioX,(PlayerNameScale/2) / RatioY);

			//Draw Numbers
			Canvas.Font = PlayerFont;
			Canvas.SetDrawColorStruct(WhiteColor);
			//Health Number
			Canvas.TextSize(playerHealth, TextSize.X, TextSize.Y);
			Canvas.SetPos(100 - (TextSize.X * PlayerNameScale / RatioX) + 100 - (Clamp(1-FCeil(playerHealth/100),0,1) * 10) - (Clamp(1-FCeil(playerHealth/10),0,1) * 10),SizeY-95);
			Canvas.DrawText(playerHealth,,(PlayerNameScale/2) / RatioX,(PlayerNameScale/2) / RatioY);
			//Energy Number
			Canvas.TextSize(p.cEnergy, TextSize.X, TextSize.Y);
			Canvas.SetPos(100 - (TextSize.X * PlayerNameScale / RatioX) + 100 - (Clamp(1-FCeil(p.cEnergy/100),0,1) * 10) - (Clamp(1-FCeil(p.cEnergy/10),0,1) * 10),SizeY-43);
			Canvas.DrawText(p.cEnergy,,(PlayerNameScale/2) / RatioX,(PlayerNameScale/2) / RatioY);

			//Health Icon
			Canvas.SetPos(SizeX * 0.025, SizeY-84);
			DrawTileCentered(Texture2D'UI_HUD.HUD.UI_HUD_BaseA', 42, 30, 216, 102, 56, 40, LC_White);
			//Energy Icon
			Canvas.SetPos(SizeX * 0.025, SizeY-32);
			DrawTileCentered(Texture2D'UI_HUD.HUD.UI_HUD_BaseB', 19, 30, 635, 267, 24, 38, LC_Yellow);
			//Special Icon
			Canvas.SetPos(SizeX * 0.025, SizeY-136);
			DrawTileCentered(Texture2D'UDKHUD.Time', 48, 48, 0, 0, 64, 64, LC_Blue);
		}
		
		
	}else{
		Canvas.Font = PlayerFont;
		Canvas.SetDrawColorStruct(WhiteColor);
		Canvas.SetPos(SizeX*0.355 - (TextSize.X * PlayerNameScale / RatioX), SizeY*0.4);
		Canvas.DrawText("YOU ARE DEAD",,PlayerNameScale * 2 / RatioX,PlayerNameScale * 2 / RatioY);
	}

	//Draw Weapon HUD
	weaponUIscale = 0.9;
	//First weapon
	weaponTex = Texture2D'UDKHUD.ut3_weapon6_color';
	Canvas.SetPos(SizeX * 0.3 + weaponTex.SizeX * weaponUIscale * 0.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
	if(p.Pawn.Weapon == p.Pawn.InvManager.FindInventoryType(class'G6Weap_Pistol')){
		Canvas.SetDrawColor(200, 200, 225);
	}else{
		Canvas.SetDrawColor(255,255,255);
	}
	if(p.skills[4] == 1 && p.skills[9] == 1 && p.skills[14] == 1){
		Canvas.SetDrawColor(255,215,0);
	}
	if(p.currentWeapon == 1){
		Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
	}
	Canvas.SetPos(SizeX * 0.3 + weaponTex.SizeX * weaponUIscale * 0.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
	Canvas.Font = PlayerFont;
	Canvas.DrawText("1",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
	Canvas.SetPos(SizeX * 0.3, SizeY * 0.85);
	Canvas.DrawTexture(weaponTex, weaponUIscale);
	//Second weapon
	if(p.skills[3] == 1){
		Canvas.SetPos(SizeX * 0.32 + weaponTex.SizeX * weaponUIscale * 1.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
		if(p.Pawn.Weapon == p.Pawn.InvManager.FindInventoryType(class'G6Weap_Laser')){
			Canvas.SetDrawColor(200, 200, 225);
		}else{
			Canvas.SetDrawColor(255,255,255);
		}
		if(p.skills[4] == 1){
			Canvas.SetDrawColor(255,215,0);
		}
		if(p.currentWeapon == 2){
			Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
		}
		Canvas.SetPos(SizeX * 0.32 + weaponTex.SizeX * weaponUIscale * 1.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
		Canvas.DrawText("2",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
		Canvas.SetPos(SizeX * 0.32 + weaponTex.SizeX * weaponUIscale, SizeY * 0.85);
		Canvas.DrawTexture(Texture2D'UDKHUD.ut3_weapon10_color', weaponUIscale);
	}
	//Third weapon
	if(p.skills[8] == 1){
		Canvas.SetPos(SizeX * 0.34 + weaponTex.SizeX * weaponUIscale * 2.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
		if(p.Pawn.Weapon == p.Pawn.InvManager.FindInventoryType(class'G6Weap_Shotgun')){
			Canvas.SetDrawColor(200, 200, 225);
		}else{
			Canvas.SetDrawColor(255,255,255);
		}
		if(p.skills[9] == 1){
			Canvas.SetDrawColor(255,215,0);
		}
		if(p.currentWeapon == 3){
			Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
		}
		Canvas.SetPos(SizeX * 0.34 + weaponTex.SizeX * weaponUIscale * 2.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
		Canvas.DrawText("3",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
		Canvas.SetPos(SizeX * 0.34 + weaponTex.SizeX * weaponUIscale * 2, SizeY * 0.85);
		Canvas.DrawTexture(Texture2D'UDKHUD.ut3_weapon4_color', weaponUIscale);
	}
	//Fourth weapon
	if(p.skills[13] == 1){
		Canvas.SetPos(SizeX * 0.36 + weaponTex.SizeX * weaponUIscale * 3.25, SizeY * 0.85 + weaponTex.SizeY * weaponUIscale);
		if(p.Pawn.Weapon == p.Pawn.InvManager.FindInventoryType(class'G6Weap_RocketLauncher_Content')){
			Canvas.SetDrawColor(200, 200, 225);
		}else{
			Canvas.SetDrawColor(255,255,255);
		}
		if(p.skills[14] == 1){
			Canvas.SetDrawColor(255,215,0);
		}
		if(p.currentWeapon == 4){
			Canvas.DrawBox(weaponTex.SizeX * weaponUIscale * 0.5, SizeY*0.05);
		}
		Canvas.SetPos(SizeX * 0.36 + weaponTex.SizeX * weaponUIscale * 3.42, SizeY * 0.855 + weaponTex.SizeY * weaponUIscale);
		Canvas.DrawText("4",,PlayerNameScale / RatioX,PlayerNameScale * 0.7 / RatioY);
		Canvas.SetPos(SizeX * 0.36 + weaponTex.SizeX * weaponUIscale * 3, SizeY * 0.85);
		Canvas.DrawTexture(Texture2D'UDKHUD.ut3_weapon8_color', weaponUIscale);
	}

	//Draw the skill points display
	Canvas.Font = PlayerFont;
	Canvas.SetDrawColorStruct(WhiteColor);
	Canvas.SetPos(SizeX*0.85, SizeY*0.9);
	Canvas.DrawText("Skill Pts: "$p.cSkPts,,PlayerNameScale / RatioX,PlayerNameScale * 1.1 / RatioY);
	
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
							p.currentWeapon = 2;
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
							p.currentWeapon = 3;
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
							p.currentWeapon = 4;
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
	}

	//Draw the Map
	if(p.bMap){
		if(p.mapZooming != p.mapZoom){
			p.mapZooming -= (p.mapZooming - p.mapZoom)/4;
			if((p.mapZooming - p.mapZoom < 0.005 && p.mapZooming > p.mapZoom) || (p.mapZoom - p.mapZooming < 0.005 && p.mapZooming < p.mapZoom)){
				p.mapZooming = p.mapZoom;
			}
		}
		p.playerMapLoc.Y = (8191-p.Pawn.Location.X) / 16;
		p.playerMapLoc.X = (p.Pawn.Location.Y + 4095) / 16;
		Clamp(p.playerMapLoc.X, 0, mapTexture.SizeX);
		Clamp(p.playerMapLoc.Y, 0, mapTexture.SizeY);

		mapDraw.X = p.mapFocus.X - (256 * p.mapZooming);
		mapDraw.Y = p.mapFocus.Y - (256 * p.mapZooming);

		if(mapDraw.X <= 0){
			mapDraw.X = 0;
			p.mapFocus.X = (256 * p.mapZooming);
		}else if(mapDraw.X + (512 * p.mapZooming) >= mapTexture.SizeX){
			mapDraw.X = mapTexture.SizeX - (512 * p.mapZooming);
			p.mapFocus.X = mapTexture.SizeX - (256 * p.mapZooming);
		}
		if(mapDraw.Y <= 0){
			mapDraw.Y = 0;
			p.mapFocus.Y = (256 * p.mapZooming);
		}else if(mapDraw.Y + (512 * p.mapZooming) >= mapTexture.SizeY){
			mapDraw.Y = mapTexture.SizeY - (512 * p.mapZooming);
			p.mapFocus.Y = mapTexture.SizeY - (256 * p.mapZooming);
		}

		mapScreenSize = SizeY * 0.8;
		mapScreenLoc.X = ((SizeX - mapScreenSize) / 2) + (SizeX * 0.1);
		mapScreenLoc.Y = SizeY * 0.1;
		if(p.bMapPan && p_input.MousePosition.X > mapScreenLoc.X && p_input.MousePosition.X < mapScreenLoc.X + mapScreenSize && p_input.MousePosition.Y > mapScreenLoc.Y && p_input.MousePosition.Y < mapScreenLoc.Y + mapScreenSize){
			p.mapFocus.X -= (p_input.MousePosition.X - mousePos.X) * p.mapZooming;
			p.mapFocus.Y -= (p_input.MousePosition.Y - mousePos.Y) * p.mapZooming;
		}
		mousePos.X = p_input.MousePosition.X;
		mousePos.Y = p_input.MousePosition.Y;

		//Map Texture
		Canvas.SetPos(mapScreenLoc.X + mapScreenSize/2, mapScreenLoc.Y + mapScreenSize/2);
		DrawTileCentered(mapTexture, mapScreenSize, mapScreenSize, mapDraw.X, mapDraw.Y, 512 * p.mapZooming, 512 * p.mapZooming, LC_White);

		Canvas.SetDrawColor(0,0,0,208);
		for(mapRoom = 1; mapRoom < 17; mapRoom++){
			if(p.roomExplored[mapRoom] == 0){
				mapFogLoc.Y = (8191-p.roomLoc[mapRoom].X) / 16;
				mapFogLoc.X = ((p.roomLoc[mapRoom].Y + 4095) / 16) - 1;
				mapFogLoc2.Y = ((8191-p.roomLoc2[mapRoom].X) / 16) + 2;
				mapFogLoc2.X = ((p.roomLoc2[mapRoom].Y + 4095) / 16) + 2;
				
				playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (mapFogLoc.X - mapDraw.X));
				playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (mapFogLoc.Y - mapDraw.Y));
				playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
				playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
				Canvas.SetPos(playerMapVisual.X - ((1-p.mapZooming)/2 + p.mapZooming), playerMapVisual.Y - ((1-p.mapZooming)/2 + p.mapZooming));

				playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (mapFogLoc2.X - mapDraw.X));
				playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (mapFogLoc2.Y - mapDraw.Y));
				playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
				playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
				Canvas.DrawRect(playerMapVisual.X - Canvas.CurX, playerMapVisual.Y - Canvas.CurY);
			}
		}

		for(mapRoom = 0; mapRoom < 19; mapRoom++){
			if(p.hallExplored[mapRoom] == 0){
				mapFogLoc.Y = (8191-p.hallLoc[mapRoom].X) / 16;
				mapFogLoc.X = (p.hallLoc[mapRoom].Y + 4095) / 16;
				mapFogLoc2.Y = ((8191-p.hallLoc2[mapRoom].X) / 16) + 2;
				mapFogLoc2.X = ((p.hallLoc2[mapRoom].Y + 4095) / 16) + 2;
				
				playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (mapFogLoc.X - mapDraw.X));
				playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (mapFogLoc.Y - mapDraw.Y));
				playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
				playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
				Canvas.SetPos(playerMapVisual.X - ((1-p.mapZooming)/2 + p.mapZooming), playerMapVisual.Y - ((1-p.mapZooming)/2 + p.mapZooming));

				if(mapRoom == 5){
					playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (263.9375 - mapDraw.X));
					playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (847.875 - mapDraw.Y));
					playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
					playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
					Canvas.DrawRect(playerMapVisual.X - Canvas.CurX, playerMapVisual.Y - Canvas.CurY);

					playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (279.9375 - mapDraw.X));
					playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (831.875 - mapDraw.Y));
					playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
					playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
					Canvas.SetPos(playerMapVisual.X - ((1-p.mapZooming)/2 + p.mapZooming), playerMapVisual.Y - ((1-p.mapZooming)/2 + p.mapZooming));
				}else if(mapRoom == 8){
					playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (256 - mapDraw.X));
					playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (649 - mapDraw.Y));
					playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
					playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
					Canvas.DrawRect(playerMapVisual.X - Canvas.CurX, playerMapVisual.Y - Canvas.CurY);

					playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (288 - mapDraw.X));
					playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (631 - mapDraw.Y));
					playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
					playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
					Canvas.SetPos(playerMapVisual.X - ((1-p.mapZooming)/2 + p.mapZooming), playerMapVisual.Y - ((1-p.mapZooming)/2 + p.mapZooming));
				}

				playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (mapFogLoc2.X - mapDraw.X));
				playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (mapFogLoc2.Y - mapDraw.Y));
				playerMapVisual.X = Clamp(playerMapVisual.X, mapScreenLoc.X, mapScreenLoc.X + mapScreenSize);
				playerMapVisual.Y = Clamp(playerMapVisual.Y, mapScreenLoc.Y, mapScreenLoc.Y + mapScreenSize);
				Canvas.DrawRect(playerMapVisual.X - Canvas.CurX, playerMapVisual.Y - Canvas.CurY);
			}
		}

		//Player On Map
		playerMapVisual.X = mapScreenLoc.X + ((mapScreenSize / (512 * p.mapZooming)) * (p.playerMapLoc.X - mapDraw.X));
		playerMapVisual.Y = mapScreenLoc.Y + (((mapScreenSize / (512 * p.mapZooming))) * (p.playerMapLoc.Y - mapDraw.Y));
		if(playerMapVisual.X > mapScreenLoc.X && playerMapVisual.X < mapScreenLoc.X + mapScreenSize){
			if(playerMapVisual.Y > mapScreenLoc.Y && playerMapVisual.Y < mapScreenLoc.Y + mapScreenSize){
				Canvas.SetDrawColor(255,0,0,196);
				Canvas.SetPos(playerMapVisual.X - (3.5 * ((1-p.mapZooming)/2 + p.mapZooming)), playerMapVisual.Y - (3.5 * ((1-p.mapZooming)/2 + p.mapZooming)));
				Canvas.DrawRect(7 * ((1-p.mapZooming)/1.5 + p.mapZooming), 7 * ((1-p.mapZooming)/1.5 + p.mapZooming));
			}
		}
		
		//Border
		Canvas.SetDrawColor(255,255,255);
		Canvas.SetPos(mapScreenLoc.X, mapScreenLoc.Y);
		Canvas.DrawBox(mapScreenSize, mapScreenSize);
	}

	if(p_input.bControllingCursor){
		//Now draw the cursor on screen
		Canvas.SetDrawColor(0,0,230);
		Canvas.SetPos(p_input.MousePosition.X, p_input.MousePosition.Y);
		Canvas.DrawTexture(Texture2D'UDKHUD.cursor_png', 1);
	}
}

DefaultProperties
{
	PlayerFont="UI_Fonts.MultiFonts.MF_HudLarge"
	PlayerNameScale=0.25
	ColorBlink = 0
	intColorBlink = 0
	ColorBlinkPositive = 1
	LC_White=(R=1.0,G=1.0,B=1.0,A=1.0)
	LC_Yellow=(R=0.8,G=0.8,B=0.0,A=1.0)
	LC_Red=(R=1.0,G=0,B=0,A=1.0)
	LC_Blue=(R=0,G=0,B=1.0,A=1.0)
	LC_Green=(R=0.2,G=0.6,B=0.7,A=1.0)
}