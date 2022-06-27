local Sprites = Zee.Worgenstein.Sprites;
local Map = Zee.Worgenstein.Map;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local BlockNames = Zee.Worgenstein.Map.DataTypeNames;
local Canvas = Zee.Worgenstein.Canvas;
local Settings = Zee.Worgenstein.Settings;
local Ray = Zee.Worgenstein.Raycasting;
local Player = Zee.Worgenstein.Player;

Sprites.spriteList = {};
Sprites.spriteFrameList = {};
Sprites.totalSprites = 0;

function Sprites.CalculateAngle(cx, cy, ex, ey)
    local dy = ey - cy;
    local dx = ex - cx;
    local theta = math.atan2(dy, dx); -- range (-PI, PI]
    theta = theta * 180 / math.pi; -- rads to degs, range (-180, 180]
    --while theta < 0 do theta = 360 + theta; end -- range [0, 360)
    --while theta > 360 do theta = theta - 360; end
    return theta;
end

--[=[
function Sprites.CreateSpriteFrames()
	for s = 1, Settings.MaxSprites, 1 do
		local sprite = CreateFrame("PlayerModel", "Zee.Wolfenstein.Sprite_" .. s, Canvas.renderFrame);
		sprite:SetFrameStrata("BACKGROUND");
		sprite:SetWidth(30) -- Set these to whatever height/width is needed 
		sprite:SetHeight(80) -- for your Texture
		if Settings.DEBUG_Sprites == true then
			sprite.texture = sprite:CreateTexture(nil,"BACKGROUND")
			sprite.texture:SetColorTexture(1,0,0,0.1);
			sprite.texture:SetAllPoints(sprite)
		end
		sprite.available = true;
		sprite.id = nil;
		sprite.model = nil;
		Sprites.spriteFrameList[s] = sprite;
	end
	Sprites.LoadSpriteData();
end

function Sprites.LoadSpriteData()
	local spriteIndex = 0;
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			local property = Properties[Map.Data[x][y]];
			if property ~= nil then
				if property.sprite == true then
					spriteIndex = spriteIndex + 1;
					local sprite = {};
					local startRotation = 0;
					local currentRotation = 0;
					if property.startRotation ~= nil then
						startRotation = property.startRotation;
					end
					currentRotation = startRotation;
					sprite.currentRotation = currentRotation;
					sprite.rotateTo = currentRotation;
					sprite.moveToX = x;
					sprite.moveToY = y;
					sprite.offsetX = 0.5;
					sprite.offsetY = 0.5;
					sprite.x = x;
					sprite.y = y;
					sprite.property = property;
					sprite.data = Map.Data[x][y];				
					Sprites.spriteList[spriteIndex] = sprite;
				end
			end
		end
	end
	Sprites.totalSprites = spriteIndex;
end
]=]

local RaceIDs = {
    Human = 1,
    Orc = 2,
    Dwarf = 3,
    NightElf = 4,
    Scourge = 5,
    Tauren = 6,
    Gnome = 7,
    Troll = 8,
    Goblin = 9,
    BloodElf = 10,
    Draenei = 11,
    Worgen = 22,
    Pandaren = 24,
}

function Sprites.CreateSpriteFrames()
	local spriteIndex = 0;
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			local property = Properties[Map.Data[x][y]];
			if property ~= nil then
				if property.sprite == true then
					spriteIndex = spriteIndex + 1;
					Sprites.sprite = CreateFrame("DressUpModel",BlockNames[Map.Data[x][y] + 1] .. "["..spriteIndex.."]",Canvas.renderFrame);
					Sprites.sprite:SetFrameStrata("BACKGROUND");
					Sprites.sprite:SetWidth(30) -- Set these to whatever height/width is needed 
					Sprites.sprite:SetHeight(80) -- for your Texture
				    if property.displayID ~= nil then
				    	Sprites.sprite:SetDisplayInfo(property.displayID)
				    end
				    if property.modelPath ~= nil then
				    	Sprites.sprite:SetModel(property.modelPath)
				    end

				    -- debug
				    if Settings.DEBUG_Sprites == true then
						Sprites.sprite.texture = Sprites.sprite:CreateTexture(nil,"BACKGROUND")
						Sprites.sprite.texture:SetColorTexture(1,0,0,0.1);
						Sprites.sprite.texture:SetAllPoints(Sprites.sprite)
					end

					-- shadow
					--[[
					Sprites.sprite.bg = CreateFrame("Frame", Sprites.sprite);
					Sprites.sprite.bg:SetFrameStrata("BACKGROUND");
					Sprites.sprite.bg:SetWidth(300) -- Set these to whatever height/width is needed 
					Sprites.sprite.bg:SetHeight(800) -- for your Texture
					Sprites.sprite.bg:SetPoint("CENTER", Sprites.sprite, "CENTER", 0, 0)
					Sprites.sprite.bg.texture = Sprites.sprite.bg:CreateTexture(nil,"BACKGROUND")
					Sprites.sprite.bg.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\Shadow.blp", false);
					Sprites.sprite.bg.texture:SetAllPoints(Sprites.sprite.bg)
					--]]

				    if property.enemy == true then
					    if property.alive == false then
					    	Sprites.sprite:SetAnimation(property.Ani_Dead);
					    elseif property.alive == true then
					    	--Sprites.sprite:ClearModel()
					    	Sprites.sprite:SetUnit('player');
					    	Sprites.sprite:SetCustomRace(1);
					    	Sprites.sprite:Undress()
					    	--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(159657);
						    Sprites.sprite:TryOn(95444);
						    Sprites.sprite:TryOn(1687);
						    Sprites.sprite:TryOn(9391);
						    Sprites.sprite:TryOn(1655);
						    Sprites.sprite:TryOn(4230);
					    	Sprites.sprite:SetAnimation(property.Ani_IdleGun);
					    end
					end

					local startRotation = 0;
					local currentRotation = 0;
					if property.startRotation ~= nil then
						startRotation = property.startRotation;
					end
					currentRotation = startRotation;
					Sprites.sprite.currentRotation = currentRotation;
					Sprites.sprite.rotateTo = currentRotation;
					Sprites.sprite.moveToX = x;
					Sprites.sprite.moveToY = y;
					Sprites.sprite.offsetX = 0.5;
					Sprites.sprite.offsetY = 0.5;
					Sprites.sprite:SetRotation(math.rad(startRotation))

				    Sprites.sprite:SetAlpha(1);

				    if property.hasCamera == true then
						Sprites.sprite:SetCustomCamera(1);
						Sprites.sprite:SetCameraDistance(3);
						Sprites.sprite:SetCameraPosition(2.827, 0.017, 0.435);
					end

				    local pos = property.positionOffset;
				    Sprites.sprite:SetPosition(pos[1], pos[2], pos[3]);
					Sprites.sprite:SetPoint("LEFT",0, 0);
					--Sprites.sprite:Hide();
					Sprites.sprite:SetFrameLevel(17);	
					Sprites.spriteList[spriteIndex] = Sprites.sprite;
					Sprites.spriteList[spriteIndex].x = x;
					Sprites.spriteList[spriteIndex].y = y;
					Sprites.sprite.property = property;
				end
			end
		end
	end
	Sprites.totalSprites = spriteIndex;
end

--[=[
local width = 5;
local height = 10;
function Sprites.UpdateSprites()
	for s = 1, Sprites.totalSprites, 1 do
		-- calculate distance from player to sprite
		local distance = Ray.DistanceBetweenTwoPoints (Sprites.spriteList[s].x + Sprites.spriteList[s].offsetX, Sprites.spriteList[s].y + Sprites.spriteList[s].offsetY, Player.Position.x, Player.Position.y);
		local screenY;
		local visible = false;
		--	show/hide sprite based on distance
		if distance <= Settings.SpriteDrawDistance then
			-- calculate angle between player and sprite
			local angle = Sprites.CalculateAngle(Sprites.spriteList[s].x + Sprites.spriteList[s].offsetX, Sprites.spriteList[s].y + Sprites.spriteList[s].offsetY, Player.Position.x, Player.Position.y) - Player.Direction;
			-- limit angle between 0 and 360
			while angle < 0 do angle = 360 + angle; end
			while angle > 360 do angle = angle - 360; end
			-- move angle between -180 and 180
			angle = 180 - angle;
			-- calculate sprite position on horizontal axis
			screenY = ((angle / Player.FoV) * Canvas.renderLines) + Canvas.renderLines/2;
			--	show/hide sprite based on horizontal position
			if screenY > -20 or screenY < Canvas.renderLines + 20 then
				visible = true;
			end
		end
		if visible == true then
			local spriteFrameIndex = nil;
			-- find if sprite is already on screen
			local alreadyVisible = false;
			for a = 1, Settings.MaxSprites, 1 do
				if Sprites.spriteFrameList[a].available == false and Sprites.spriteFrameList[a].id == a then
					alreadyVisible = true;
					spriteFrameIndex = a;
				end
			end
			-- if it's not on screen, request new sprite
			if alreadyVisible == false then
				for a = 1, Settings.MaxSprites, 1 do
					if Sprites.spriteFrameList[a].available == true then
						spriteFrameIndex = a;
					end
				end
			end
			-- if we found a usable sprite - update it
			if spriteFrameIndex ~= nil then
				Sprites.spriteFrameList[spriteFrameIndex].available = false;
				local sprite = Sprites.spriteFrameList[spriteFrameIndex];
				-- set model
				if alreadyVisible == false then
					if Sprites.spriteList[s].property.displayID ~= nil then
				    	sprite:SetDisplayInfo(Sprites.spriteList[s].property.displayID)
				    end
				    if Sprites.spriteList[s].property.modelPath ~= nil then
				    	sprite:SetModel(Sprites.spriteList[s].property.modelPath)
				    end
				end
				-- set dimensions
				sprite:SetWidth(width / distance * 100);
				sprite:SetHeight(height / distance * 100);
				-- get 2D vertical offset
				local spriteYOff = 0;
				if Sprites.spriteList[s].property.spriteYOffset ~= nil then
					spriteYOff = Sprites.spriteList[s].property.spriteYOffset;
				end
				-- set 2D position
				sprite:SetPoint("LEFT",(screenY * Canvas.renderDensity) - sprite:GetWidth()/2, spriteYOff / distance);
				-- set 3D rotation --
				local rotation;
				if Sprites.spriteList[s].property.enemy == true then
					rotation = Sprites.spriteList[s].currentRotation;
					-- limit rotation betwttn 0 and 360 degrees
					if rotation > 360 then rotation = 360 - rotation; end
					if rotation < 0 then rotation = 360 + rotation; end
					sprite:SetRotation(math.rad(rotation));
				else
					rotation = -Player.Direction + Sprites.spriteList[s].currentRotation - (distance*2);
					-- limit rotation betwttn 0 and 360 degrees
					if rotation > 360 then rotation = 360 - rotation; end
					if rotation < 0 then rotation = 360 + rotation; end
					sprite:SetRotation(math.rad(rotation));
				end
				-- set camera
			    if Sprites.spriteList[s].property.hasCamera == true then
				    sprite:SetCustomCamera(1)
				    sprite:SetCameraDistance(3)
				    sprite:SetCameraPosition(2.827, 0.017, 0.435);
				end
				-- set Z depth --
				local zDepth = Canvas.GetZDepth(distance)
				sprite:SetFrameLevel(zDepth);
				-- set shading --
				if Sprites.spriteList[s].property.unshaded ~= true then
					local shading = 1 - (distance/7);
					if shading < 0 then shading = 0; end
					sprite:SetFogColor(0, 0, 0);
					sprite:SetFogFar(shading * 15);
				end
			else
				print ("Worgenstein: Error: Ran out of sprite frames.");
			end
		else
			for a = 1, Settings.MaxSprites, 1 do
				-- if a sprite is no longer visible make it available for use
				if Sprites.spriteFrameList[a].available == false then--and Sprites.spriteFrameList[a].id == a then
					Sprites.spriteFrameList[a].available = true;
				end
			end
		end
	end
end
]=]

local width = 5;
local height = 10;
function Sprites.Update()
	for s = 1, Sprites.totalSprites, 1 do
		local distance = Ray.DistanceBetweenTwoPoints (Sprites.spriteList[s].x + Sprites.spriteList[s].offsetX, Sprites.spriteList[s].y + Sprites.spriteList[s].offsetY, Player.Position.x, Player.Position.y);
		if (distance < Settings.SpriteDrawDistance) then 
			if Sprites.spriteList[s]:IsVisible() == false then
				Sprites.spriteList[s]:Show(); 
			    if Sprites.spriteList[s].property.displayID ~= nil then
			    	Sprites.spriteList[s]:SetDisplayInfo(Sprites.spriteList[s].property.displayID)
			    end
			    if Sprites.spriteList[s].property.modelPath ~= nil then
			    	Sprites.spriteList[s]:SetModel(Sprites.spriteList[s].property.modelPath)
			    end
			end		
		else 
			Sprites.spriteList[s]:Hide(); 
		end

		if Sprites.spriteList[s]:IsVisible() == true then

			-- ScreenPosition and Size --
			local screenY = Sprites.CalculateAngle(Sprites.spriteList[s].x + Sprites.spriteList[s].offsetX, Sprites.spriteList[s].y + Sprites.spriteList[s].offsetY, Player.Position.x, Player.Position.y) - Player.Direction;
			while screenY < 0 do screenY = 360 + screenY; end -- range [0, 360)
			while screenY > 360 do screenY = screenY - 360; end
			screenY = 180 - screenY;
			screenY = ((screenY / Player.FoV) * Canvas.renderLines) + Canvas.renderLines/2;
			Sprites.spriteList[s]:SetWidth(width / distance * 100);
			Sprites.spriteList[s]:SetHeight(height / distance * 100);
			local spriteYOff = 0;
			if Sprites.spriteList[s].property.spriteYOffset ~= nil then
				spriteYOff = Sprites.spriteList[s].property.spriteYOffset;
			end
			Sprites.spriteList[s]:SetPoint("LEFT",(screenY * Canvas.renderDensity) - Sprites.spriteList[s]:GetWidth()/2, spriteYOff / distance);

			-- Rotation --
			if Sprites.spriteList[s].property.enemy == true then
				local rotation = Sprites.spriteList[s].currentRotation;
				if rotation > 360 then rotation = 360 - rotation; end
				if rotation < 0 then rotation = 360 + rotation; end
				Sprites.spriteList[s]:SetRotation(math.rad(rotation));
			else
				local rotation = -Player.Direction  + Sprites.spriteList[s].currentRotation - (distance*2);
				if rotation > 360 then rotation = 360 - rotation; end
				if rotation < 0 then rotation = 360 + rotation; end
				Sprites.spriteList[s]:SetRotation(math.rad(rotation));
			end

			-- Camera fix

		    if Sprites.spriteList[s].property.hasCamera == true then
			    Sprites.spriteList[s]:SetCustomCamera(1)
			    Sprites.spriteList[s]:SetCameraDistance(3)
			    Sprites.spriteList[s]:SetCameraPosition(2.827, 0.017, 0.435);
			end			

			-- Z Depth --
			local zDepth = Canvas.GetZDepth(distance)
			Sprites.spriteList[s]:SetFrameLevel(zDepth);


			-- Fix for sprites exiting screen space --
			if distance < 0.5 or screenY < -20 or screenY > Canvas.renderLines + 20 then
				Sprites.spriteList[s]:SetAlpha(0);
			else
				Sprites.spriteList[s]:SetAlpha(1);
			end

			-- Shading --
			if Sprites.spriteList[s].property.unshaded ~= true then
				local shading = 1 - (distance/7);
				if shading < 0 then shading = 0; end
				Sprites.spriteList[s]:SetFogColor(0, 0, 0);
				Sprites.spriteList[s]:SetFogFar(shading * 15);
			end
		end
	end
end