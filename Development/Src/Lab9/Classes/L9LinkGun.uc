class L9LinkGun extends UTWeap_LinkGun;


function bool CanAttack(Actor Other)
{
	return super.CanAttack(other) && vsize(other.Location - instigator.Location) <= WeaponRange;
}

function byte BestMode()
{
	return 0;
}

DefaultProperties
{
	WeaponRange=500
}
