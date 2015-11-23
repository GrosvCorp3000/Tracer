class L8CounterItem extends Inventory;

var int counter;

exec function increment() 
{
	counter++;
}

exec function announce() 
{
	`Log("The current counter is: "$counter);
}

DefaultProperties
{
	counter = 0
}
