Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
local WG = Zee.Worgenstein;
WG.Player = WG.Player or {};
local Player = WG.Player;
local Graph = Zee.Graph;
Zee.Worgenstein.Map = Zee.Worgenstein.Map or {};
local Map = Zee.Worgenstein.Map;
Zee.Worgenstein.MapEditor = Zee.Worgenstein.MapEditor or {}
local MapEditor = Zee.Worgenstein.MapEditor;
local Ray = Zee.Worgenstein.Raytracing;
local DataType = Zee.Worgenstein.Map.DataType;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local Settings = Zee.Worgenstein.Settings;
local Canvas = Zee.Worgenstein.Canvas;

Player.FoV = 70;		-- Field of View in degrees
Player.Direction = 30;	-- The start angle at which the player is looking in degrees
Player.Position = {};	-- the player position table
Player.Position.x = 0; -- player x start position on map
Player.Position.y = 0; -- player y start position on map
Player.turnSpeed = 1;
Player.moveSpeed = 0.02;

Player.Action = {};
Player.Action.TurnLeft = false;
Player.Action.TurnRight = false;
Player.Action.MoveForward = false;
Player.Action.MoveBackward = false;
Player.Action.StrafeLeft = false;
Player.Action.StrafeRight = false;

Player.InputFrame = Player.InputFrame or CreateFrame("Frame","KeyboardListener",UIParent);
Player.InputFrame:EnableKeyboard(true);
Player.InputFrame:SetPropagateKeyboardInput(true);
Player.InputFrame:SetScript("OnKeyDown", function(self, key)
		if key == "A" or key == "D" or key == "W" or key == "S" or key == "Q" or key == "E" or key == "Z" or key == "F" then
			Player.Input(key, true);
			self:SetPropagateKeyboardInput(false);
		end
	end);
Player.InputFrame:SetScript("OnKeyUp", function(self, key)
		if key == "A" or key == "D" or key == "W" or key == "S" or key == "Q" or key == "E" or key == "Z" or key == "F" then
			Player.Input(key, false);
			self:SetPropagateKeyboardInput(true);
		end
	end);

function Player.Input(key, pressed)
	if key == "A" then
		Player.Action.TurnLeft = pressed;
	end
	if key == "D" then
		Player.Action.TurnRight = pressed;
	end
	if key == "W" then
		Player.Action.MoveForward = pressed;
	end
	if key == "S" then
		Player.Action.MoveBackward = pressed;
	end
	if key == "Q" then
		Player.Action.StrafeLeft = pressed;
	end
	if key == "E" then
		Player.Action.StrafeRight = pressed;
	end	
	if key == "Z" then
		if pressed == true then -- ignore on key released
			Player.Interact();
		end
	end
	if key == "F" then
		Player.Shoot(pressed);
	end	
 end

function Player.Shoot(pressed)
	Canvas.gunFrame:SetAnimation(49);
	if pressed == true then
		Canvas.gunParticleFrame:SetAnimation(0);
		Canvas.gunParticleFrame:Show();
		Canvas.gunParticleFrame:SetModel(1269534);
		Canvas.gunParticleFrame.timer = 1;
	end
end

function Player.Interact()
	-- check if there's a door in front
	local hit = Ray.Cast(1, Player.Position.x, Player.Position.y, Player.Direction, 10);
	if Properties[hit.blockType] ~= nil then
		if Properties[hit.blockType].door == true then
			if hit.distance < Settings.DoorOpenDistance then
				--if Map.Data[hit.hitBoxX][hit.hitBoxY].property >= 1 then
				if Map.Doors[hit.hitBoxX][hit.hitBoxY] >= 1 then
					Canvas.OpenDoor(hit.hitBoxX,hit.hitBoxY);
				end
				--if Map.Data[hit.hitBoxX][hit.hitBoxY].property <= 0 then
				if Map.Doors[hit.hitBoxX][hit.hitBoxY] <= 0.1 then
				Canvas.CloseDoor(hit.hitBoxX,hit.hitBoxY);
				end
			end
		end
	end

end

function Player.Spawn()
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			if Map.Data[x][y] == DataType.StartPositionU then
				Player.Position.x = x + 0.5;
				Player.Position.y = y+ 0.5;
				Player.Direction = 90;	
				--print(x .. " " ..y);			
			end
			if Map.Data[x][y] == DataType.StartPositionR then
				Player.Position.x = x+ 0.5;
				Player.Position.y = y+ 0.5;
				Player.Direction = 0;	
				--print(x .. " " ..y);	
			end
			if Map.Data[x][y] == DataType.StartPositionD then
				Player.Position.x = x+ 0.5;
				Player.Position.y = y+ 0.5;	
				Player.Direction = 90*3;
				--print(x .. " " ..y);	
			end
			if Map.Data[x][y] == DataType.StartPositionL then
				Player.Position.x = x+ 0.5;
				Player.Position.y = y+ 0.5;
				Player.Direction = 180;	
				--print(x .. " " ..y);	
			end
		end
	end
	Zee.Worgenstein.MapEditor.UpdatePlayer();
end

function Player.Movement()
	if Player.Action.TurnLeft then
		Player.Direction = Player.Direction + Player.turnSpeed;
		if Player.Direction > 360 then Player.Direction = Player.Direction - 360; end
		if Player.Direction < 0 then Player.Direction = Player.Direction + 360; end
	end

	if Player.Action.TurnRight then
		Player.Direction = Player.Direction - Player.turnSpeed;
		if Player.Direction > 360 then Player.Direction = Player.Direction - 360; end
		if Player.Direction < 0 then Player.Direction = Player.Direction + 360; end	
	end

	if Player.Action.MoveForward then
		local xDestination = Player.Position.x + (Player.moveSpeed * math.cos(DegreeToRadian(Player.Direction)));
		local yDestination = Player.Position.y + (Player.moveSpeed * math.sin(DegreeToRadian(Player.Direction)));
		local xDestinationPerpendicular = 0;
		local yDestinationPerpendicular = 0;

		if WG.CheckCollision(xDestination, yDestination) == false then
			Player.Position.x = xDestination;
			Player.Position.y = yDestination;
		else	
			WG.Slide(xDestination, yDestination);
		end
	end

	if Player.Action.MoveBackward then
		local xDestination = Player.Position.x - (Player.moveSpeed * math.cos(DegreeToRadian(Player.Direction)));
		local yDestination = Player.Position.y - (Player.moveSpeed * math.sin(DegreeToRadian(Player.Direction)));
		if WG.CheckCollision(xDestination, yDestination) == false then
			Player.Position.x = xDestination;
			Player.Position.y = yDestination;
		else	
			WG.Slide(xDestination, yDestination);
		end
	end
	if Player.Action.StrafeLeft then
		local xDestination = Player.Position.x + (Player.moveSpeed * math.cos(DegreeToRadian(Player.Direction + 90)));
		local yDestination = Player.Position.y + (Player.moveSpeed * math.sin(DegreeToRadian(Player.Direction + 90)));
		if WG.CheckCollision(xDestination, yDestination) == false then
			Player.Position.x = xDestination;
			Player.Position.y = yDestination;
		end
	end
	if Player.Action.StrafeRight then
		local xDestination = Player.Position.x + (Player.moveSpeed * math.cos(DegreeToRadian(Player.Direction - 90)));
		local yDestination = Player.Position.y + (Player.moveSpeed * math.sin(DegreeToRadian(Player.Direction - 90)));
		if WG.CheckCollision(xDestination, yDestination) == false then
			Player.Position.x = xDestination;
			Player.Position.y = yDestination;
		end
	end

end