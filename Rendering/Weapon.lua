local Weapon = Zee.Worgenstein.Weapon;
local Player = Zee.Worgenstein.Player;
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


	-- weapons that work
	-- 167996
	-- 168644
	-- 112806
	-- 159130 -- sniper
	-- 66439
	-- 42486 -- machine gun
	-- 159657

	-- explosion
	-- spells/cfx_rogue_pistolshot_casthandr.m2


	function Weapon.CreateGunFrame()
		-- create GunFrame
		Weapon.gunFrame = CreateFrame("DressUpModel",nil,Canvas.renderFrame);
		Weapon.gunFrame:SetFrameStrata("MEDIUM");
		Weapon.gunFrame:SetWidth(300) -- Set these to whatever height/width is needed 
		Weapon.gunFrame:SetHeight(300) -- for your Texture
		Weapon.gunFrame:SetItem(159657)
		Weapon.gunFrame:SetAnimation(0);
		Weapon.gunFrame:SetRotation(math.rad(200))
		Weapon.gunFrame:SetAlpha(1)
		--Weapon.gunFrame:SetCustomCamera(1)
		local cx, cy, cz = Weapon.gunFrame:GetCameraPosition()
		--Zee.Worgenstein.Weapon.gunFrame:SetPosition(1, 0.3, 0.5)
		Weapon.gunFrame:SetPoint("BOTTOMRIGHT",0, 0);
		Weapon.gunFrame:Show();
		Weapon.gunFrame:SetFrameLevel(90);
	
		Weapon.gunFrame:SetUnit('player');
		Weapon.gunFrame:SetCustomRace(1);
		Weapon.gunFrame:Undress()
		--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(159657);
		Weapon.gunFrame:TryOn(95444);
		Weapon.gunFrame:SetCustomCamera(1);
		Weapon.gunFrame:SetAnimation(49);	
	
		-- left handed
		--Weapon.gunFrame:SetCameraPosition(0, 0.1, 1);
		--Weapon.gunFrame:SetPosition(1,1,0);1269534
		--Weapon.gunFrame:SetRotation(0);
	
		-- right handed
		--Weapon.gunFrame:SetCameraPosition(0, 0, 0.51);
		Weapon.gunFrame:SetCameraPosition(-0.7, -0.4, 1);
		
		--Weapon.gunFrame:SetPosition(0.5,-0.4,-1);
		Weapon.gunFrame:SetPosition(-0.4,-0.8,-0.8);
		--Weapon.gunFrame:SetRotation(0.9);
		Weapon.gunFrame:SetRotation(1);
	
	
		Weapon.gunParticleFrame = CreateFrame("PlayerModel",nil,Canvas.renderFrame);
		Weapon.gunParticleFrame:SetFrameStrata("MEDIUM");
		Weapon.gunParticleFrame:SetWidth(500) -- Set these to whatever height/width is needed 
		Weapon.gunParticleFrame:SetHeight(500) -- for your Texture
		Weapon.gunParticleFrame:SetPoint("BOTTOMRIGHT",0, 0);
		Weapon.gunParticleFrame:Hide();
		Weapon.gunParticleFrame:SetFrameLevel(80);
		Weapon.gunParticleFrame:SetModel(1269534);
		Weapon.gunParticleFrame:SetPosition(-50, 5, -28);
		Weapon.gunParticleFrame:SetAlpha(0.2);
		Weapon.gunParticleFrame.timer = 1;
		--Weapon.gunParticleFrame:SetAnimation(0);
		--/run Zee.Worgenstein.Weapon.gunParticleFrame:SetPosition(0, 0, 1);
	end


function Weapon.TurnLeft()
	if Weapon.TurnPercentageLeft < Weapon.TurnMaxAngle then
		Weapon.TurnPercentageLeft = Weapon.TurnPercentageLeft + Weapon.TurnIncrement;
	else
		Weapon.NeedsTurnReset = true;
	end
	
	--Weapon.gunFrame:SetRotation(math.rad(Weapon.InitialRotation + Weapon.TurnPercentageLeft))
	Weapon.gunFrame:SetRoll(math.rad(Weapon.TurnPercentageLeft*2))
	Weapon.gunFrame:SetPosition(Weapon.InitialPosition[1],Weapon.InitialPosition[2] + (Weapon.TurnPercentageLeft/50), Weapon.InitialPosition[3]);
end

function Weapon.TurnRight()	
	if Weapon.TurnPercentageRight < Weapon.TurnMaxAngle then
		Weapon.TurnPercentageRight = Weapon.TurnPercentageRight + Weapon.TurnIncrement;
	else
		Weapon.NeedsTurnReset = true;
	end

	--Weapon.gunFrame:SetRotation(math.rad(Weapon.InitialRotation - Weapon.TurnPercentageRight))
	Weapon.gunFrame:SetRoll(math.rad(-Weapon.TurnPercentageRight*2))
	Weapon.gunFrame:SetPosition(Weapon.InitialPosition[1], Weapon.InitialPosition[2] - (Weapon.TurnPercentageRight/50), Weapon.InitialPosition[3]);
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
		--Weapon.gunFrame:SetRotation(math.rad(Weapon.InitialRotation + Weapon.TurnPercentageLeft));
		Weapon.gunFrame:SetRoll(math.rad(Weapon.TurnPercentageLeft*2))
		Weapon.gunFrame:SetPosition(Weapon.InitialPosition[1], Weapon.InitialPosition[2] + (Weapon.TurnPercentageLeft/50), Weapon.InitialPosition[3]);
	end

	if Weapon.TurnPercentageRight > 0 then
		Weapon.TurnPercentageRight = Weapon.TurnPercentageRight - Weapon.TurnIncrement;
		--Weapon.gunFrame:SetRotation(math.rad(Weapon.InitialRotation - Weapon.TurnPercentageRight));
		Weapon.gunFrame:SetRoll(math.rad(-Weapon.TurnPercentageRight*2))
		Weapon.gunFrame:SetPosition(Weapon.InitialPosition[1], Weapon.InitialPosition[2] - (Weapon.TurnPercentageRight/50), Weapon.InitialPosition[3]);
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

	if Weapon.gunParticleFrame ~= nil and Weapon.gunParticleFrame.timer ~= nil then
		if Weapon.gunParticleFrame.timer <= 0 then
			Weapon.gunParticleFrame:Hide();
		else
			Weapon.gunParticleFrame.timer = Weapon.gunParticleFrame.timer - 0.01;
		end
	end
end