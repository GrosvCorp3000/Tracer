class G6Pawn extends UTPawn;

/**
 *	Calculate camera view point, when viewing this pawn.
 *
 * @param	fDeltaTime	delta time seconds since last update
 * @param	out_CamLoc	Camera Location
 * @param	out_CamRot	Camera Rotation
 * @param	out_FOV		Field of View
 *
 * @return	true if Pawn should provide the camera point of view.
 */
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
	local G6PlayerController p;
	local UTWeapon curHeld;
	p = G6PlayerController (Controller);

	if (p != None && p.Pawn != None) {
		out_CamLoc = p.Pawn.Location + p.camOffset;
		out_CamRot = rotator(normal(p.Pawn.Location - out_CamLoc));

		if(p.skills[11] == 1){
			GroundSpeed = 1200;
		}else if(p.skills[10] == 1){
			GroundSpeed = 1000;
		}

		if(p.skills[1] == 1){
			HealthMax = 200;
		}else if(p.skills[0] == 1){
			HealthMax = 150;
		}
	
		if(p.skills[6] == 1){
			p.cEnergyMax = 300;
		}else if(p.skills[5] == 1){
			p.cEnergyMax = 200;
		}

		curHeld = UTWeapon (Weapon);
		curHeld.MaxAmmoCount = p.cEnergyMax;

		if (!p.bBattleMode) {
			if(Health < HealthMax){
				Health++;
			}
			if(p.cEnergy < p.cEnergyMax){
				p.cEnergy++;
			}
		}
	}
	return true;
}

function PossessedBy(Controller C, bool bVehicleTransition) {
	local G6PlayerController PC;

	super.PossessedBy(C, bVehicleTransition);

	PC = G6PlayerController(C);
	if (PC != None)
	{
		InvManager.CreateInventory(class'G6Weap_Pistol');
		InvManager.CreateInventory(class'G6Weap_Laser');
		InvManager.CreateInventory(class'G6Weap_Shotgun');
		InvManager.CreateInventory(class'G6Weap_RocketLauncher_Content');

		//Why doesn't this work?
		PC.SwitchWeapon(1);
		//InvManager.CreateInventory(class'UTWeap_ShockRifle');
	}
}

DefaultProperties
{
	GroundSpeed = 800
	
}
