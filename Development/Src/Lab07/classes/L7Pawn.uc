class L7Pawn extends UTPawn  implements (L7Selectable);

vector function GetLocation3D() {
	return Controller.Pawn.Location;
}

DefaultProperties
{
}
