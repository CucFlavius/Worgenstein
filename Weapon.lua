
Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
Zee.Worgenstein.Weapon = Zee.Worgenstein.Weapon or {}
local Player = Zee.Worgenstein.Player;
local Weapon = Zee.Worgenstein.Weapon;
local Canvas = Zee.Worgenstein.Canvas;

Weapon.NeedsTurnReset = false;
Weapon.TurnPercentageLeft = 0;
Weapon.TurnPercentageRight = 0;
Weapon.TurnMaxAngle = 10;
Weapon.TurnIncrement = 0.5;

--Weapon.InitialRotation = 200;
Weapon.InitialRotation = 1;
--Weapon.InitialPosition = { 1, 0.3, 0.5 };
Weapon.InitialPosition = { -0.4,-0.8,-0.8 };


function Weapon.TurnLeft()
	if Weapon.TurnPercentageLeft < Weapon.TurnMaxAngle then
		Weapon.TurnPercentageLeft = Weapon.TurnPercentageLeft + Weapon.TurnIncrement;
	else
		Weapon.NeedsTurnReset = true;
	end
	
	--Canvas.gunFrame:SetRotation(math.rad(Weapon.InitialRotation + Weapon.TurnPercentageLeft))
	Canvas.gunFrame:SetRoll(math.rad(Weapon.TurnPercentageLeft*2))
	Canvas.gunFrame:SetPosition(Weapon.InitialPosition[1],Weapon.InitialPosition[2] + (Weapon.TurnPercentageLeft/50), Weapon.InitialPosition[3]);
end

function Weapon.TurnRight()	
	if Weapon.TurnPercentageRight < Weapon.TurnMaxAngle then
		Weapon.TurnPercentageRight = Weapon.TurnPercentageRight + Weapon.TurnIncrement;
	else
		Weapon.NeedsTurnReset = true;
	end

	--Canvas.gunFrame:SetRotation(math.rad(Weapon.InitialRotation - Weapon.TurnPercentageRight))
	Canvas.gunFrame:SetRoll(math.rad(-Weapon.TurnPercentageRight*2))
	Canvas.gunFrame:SetPosition(Weapon.InitialPosition[1], Weapon.InitialPosition[2] - (Weapon.TurnPercentageRight/50), Weapon.InitialPosition[3]);
end

function Weapon.Walk()
	Canvas.Walk();
end

function Weapon.ResetWalk()
	Canvas.ResetWalk();
end

function Weapon.ResetTurn()
	if Weapon.TurnPercentageLeft > 0 then
		Weapon.TurnPercentageLeft = Weapon.TurnPercentageLeft - Weapon.TurnIncrement;
		--Canvas.gunFrame:SetRotation(math.rad(Weapon.InitialRotation + Weapon.TurnPercentageLeft));
		Canvas.gunFrame:SetRoll(math.rad(Weapon.TurnPercentageLeft*2))
		Canvas.gunFrame:SetPosition(Weapon.InitialPosition[1], Weapon.InitialPosition[2] + (Weapon.TurnPercentageLeft/50), Weapon.InitialPosition[3]);
	end

	if Weapon.TurnPercentageRight > 0 then
		Weapon.TurnPercentageRight = Weapon.TurnPercentageRight - Weapon.TurnIncrement;
		--Canvas.gunFrame:SetRotation(math.rad(Weapon.InitialRotation - Weapon.TurnPercentageRight));
		Canvas.gunFrame:SetRoll(math.rad(-Weapon.TurnPercentageRight*2))
		Canvas.gunFrame:SetPosition(Weapon.InitialPosition[1], Weapon.InitialPosition[2] - (Weapon.TurnPercentageRight/50), Weapon.InitialPosition[3]);
	end

	if Weapon.TurnPercentageRight <= 0 and Weapon.TurnPercentageLeft <= 0 then
		--Weapon.NeedsTurnReset = false;
	end
end

function Weapon.Update()

	if Player.Action.TurnLeft then
		Weapon.TurnLeft();
	end

	if Player.Action.TurnRight then
		Weapon.TurnRight();
	end

	if Player.Action.TurnLeft == false and Player.Action.TurnRight == false and Weapon.NeedsTurnReset then
		Weapon.ResetTurn();
	end

	if Player.Action.MoveForward or Player.Action.MoveBackward or Player.Action.StrafeLeft or Player.Action.StrafeRight then
		Weapon.Walk();
	end

	if Player.Action.MoveForward == false and Player.Action.MoveBackward  == false and Player.Action.StrafeLeft == false and Player.Action.StrafeRight == false then
		Weapon.ResetWalk();
	end

	if Canvas.gunParticleFrame.timer <= 0 then
		Canvas.gunParticleFrame:Hide();
	else
		Canvas.gunParticleFrame.timer = Canvas.gunParticleFrame.timer - 0.01;
	end
end