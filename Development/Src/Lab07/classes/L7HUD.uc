class L7HUD extends HUD;

var Pawn Selected;

function Vector2D DrawCenteredTextureOnCanvas(Texture2D tex, float screenScale)
{
	local Vector2D temp, return_2d, setClamp;
	temp.X = Canvas.CurX;
	temp.Y = Canvas.CurY;

	return_2d.X = tex.SizeX * screenScale;
	return_2d.Y = tex.SizeY * screenScale;

	setClamp.X = Clamp(Canvas.CurX - (return_2d.X/2), 0, SizeX);
	setClamp.Y = Clamp(Canvas.CurY - (return_2d.Y/2), 0, SizeY);

	//Canvas.SetPos(Clamp(Canvas.CurX - (tex.SizeX/2), 0, SizeX),  Clamp(Canvas.CurY - (tex.SizeY/2), 0, SizeY));
	Canvas.SetPos(setClamp.X, setClamp.Y);

	//Canvas.DrawTexture(tex, screenScale * tex.SizeX / SizeX);
	Canvas.DrawTexture(tex, screenScale);

	Canvas.SetPos(temp.X, temp.Y);

	return return_2d;
}

function DrawHUD()
{
	local L7Player p;
	local L7PlayerInput pInput;
	local Pawn pw;
	local L7Selectable selectable;
	local vector canvasProject;
	local Vector2D textSize;
	local bool checkX, checkY;

	p = L7Player (PlayerOwner);
	pInput = L7PlayerInput (p.PlayerInput);

	foreach AllActors(class'Pawn', pw, class'L7Selectable')
	{

		if (pw != p.Pawn) {
			selectable = L7Selectable(pw);
			canvasProject = Canvas.Project(selectable.GetLocation3D());
			
			pInput.bControllingCursor ? Canvas.SetDrawColor(255, 0, 0) : Canvas.SetDrawColor(255, 255, 255);

			if (canvasProject.Z > 0 && canvasProject.X > 0 && canvasProject.Y > 0 && canvasProject.X < SizeX && canvasProject.Y < SizeY)
			{
				Canvas.SetPos(canvasProject.X, canvasProject.Y);
				if (selectable == L7Selectable(Selected)) {
					textSize = DrawCenteredTextureOnCanvas(Texture2D'L7Content.Selected', 0.1);
				} else {
					textSize = DrawCenteredTextureOnCanvas(Texture2D'L7Content.Selectable', 0.1);
				}

				//draw the reticle, only when there is something on screen
				pInput.bControllingCursor ? Canvas.SetDrawColor(0, 255, 0) : Canvas.SetDrawColor(255, 255, 255);
				
				if (pInput.bControllingCursor)
				{
					checkX = Canvas.CurX - textSize.X <= pInput.MousePosition.X && pInput.MousePosition.X <= Canvas.CurX + textSize.X;
					checkY = Canvas.CurY - textSize.X <= pInput.MousePosition.Y && pInput.MousePosition.Y <= Canvas.CurY + textSize.Y;

					Canvas.SetPos(pInput.MousePosition.X, pInput.MousePosition.Y);

					if (checkX && checkY) {
						DrawCenteredTextureOnCanvas(Texture2D'L7Content.ReticlePicking', 0.1);
						if (pInput.bAttemptSelect) {
							Selected = pw;
							pInput.bAttemptSelect = false;
						}
					} else {
						DrawCenteredTextureOnCanvas(Texture2D'L7Content.Reticle', 0.1);
					}
				} else {
					Canvas.SetPos(pInput.MousePosition.X, pInput.MousePosition.Y);
					DrawCenteredTextureOnCanvas(Texture2D'L7Content.Reticle', 0.1);
				}
			}
		}
	}


}

DefaultProperties
{
}
