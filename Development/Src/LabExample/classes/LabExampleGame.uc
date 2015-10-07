class LabExampleGame extends Object;

var int myVar;

function PostBeginPlay()
{
	local String myString;

	`Log("I am " @self);
	scriptTrace();
	`Log("Trace complete");
	myString = GetScriptTrace();
	`Log("Trace complete. Trace again: "$myString);
	super.PostBeginPlay();

}
/*
 actors		events			func

constructed
initialized	postBeginPlay		spawn
destroyed	Destroyed		destory

UTGame myGame = spawn
 */
DefaultProperties
{
}
