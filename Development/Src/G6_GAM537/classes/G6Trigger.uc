class G6Trigger extends Trigger
	placeable
	ClassGroup(GROUP6);

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local G6PlayerController pc;
	local G6Pawn p;
	local G6Wall A;
	local G6Spawner S;

	p = G6Pawn (Other);

	if (p != None) {
		pc = G6PlayerController (p.Controller);
		if (pc.roomExplored[pc.curRoom] == 0) {
			foreach AllActors( class'G6Wall', A )
			{
				//`Log("Trying to trigger ... "$A);
				A.bBlockActors = True;
			}
			foreach AllActors( class'G6Spawner', S )
			{
				if(S.Location.X < pc.roomLoc[pc.curRoom].X && 
					S.Location.Y > pc.roomLoc[pc.curRoom].Y && 
					S.Location.X > pc.roomLoc2[pc.curRoom].X && 
					S.Location.Y < pc.roomLoc2[pc.curRoom].Y)
				{
				//`Log("Trying to trigger ... "$S);
				S.bSpawn = True;
				}
			}
			pc.bBattleMode = True;
			pc.roomExplored[pc.curRoom] = 1;
		}
	}
	//`Log("Trigger Sphere Touched... "$Other);
	super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

DefaultProperties
{
	begin Object NAME=Sprite
		Sprite=Texture2D'EditorResources.Ambientcreatures'
	End Object
}
