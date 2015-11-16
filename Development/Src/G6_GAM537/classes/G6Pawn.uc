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
	p = G6PlayerController (Controller);

	if (p.Pawn != None) {
		
		/*
		if (p.Pawn.GroundSpeed < 2500) {
			p.Pawn.GroundSpeed += 300; //make the player's pawn faster
		}
		*/

		out_CamLoc = p.Pawn.Location + p.camOffset;
		out_CamRot = rotator(normal(p.Pawn.Location - out_CamLoc));
	}
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

	if (!p.bBattleMode) {
			Health = HealthMax;
	}
	return true;
}

function PossessedBy(Controller C, bool bVehicleTransition) {
	local PlayerController PC;

	super.PossessedBy(C, bVehicleTransition);

	PC = PlayerController(C);
	if (PC != None)
	{
		`log("Possessed called, inventory manager is "$InvManager);
		//InvManager.CreateInventory(class'UTWeap_ShockRifle');
		//InvManager.CreateInventory(class'UTWeap_RocketLauncher_Content');
		`log("Created: "$InvManager.CreateInventory(class'W9Weapon'));
		InvManager.SwitchToBestWeapon();
	}
}

exec function GiveW9Weapon()
{
	InvManager.CreateInventory(class'W9Weapon');
}

DefaultProperties
{
	GroundSpeed = 800
	
}
