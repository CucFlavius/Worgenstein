Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
Zee.Worgenstein.Canvas = Zee.Worgenstein.Canvas or {};
Zee.Worgenstein.Settings = Zee.Worgenstein.Settings or {};
local Canvas = Zee.Worgenstein.Canvas;
local WG = Zee.Worgenstein;
local Map = Zee.Worgenstein.Map;
local Player = WG.Player;
local Ray = Zee.Worgenstein.Raycasting;
local DataType = Map.DataType;
local Settings = Zee.Worgenstein.Settings;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local BlockName = Zee.Worgenstein.Map.DataTypeNames;
local SecondLayerType = Zee.Worgenstein.Map.DataTypeProperties.SecondLayerType;
local Textures = Zee.Worgenstein.Textures;

-- Properties --
Canvas.resolution = {};
Canvas.resolution.x = 640;
Canvas.resolution.y = 480;
Canvas.scale = 1.6;
Canvas.renderDensity = 4;
Canvas.groundVisLines = 50;
Canvas.renderDensityGround = 8;
Canvas.renderLines = Canvas.resolution.x / Canvas.renderDensity;
--Canvas.renderLinesVertical = Canvas.resolution.y / Canvas.renderDensityGround;
Canvas.HUDBarHeight = 100;
Canvas.renderLinesList = {};		-- first layer wall render lines
Canvas.renderLinesList2 = {};		-- second layer wall render lines
Canvas.renderLinesList3 = {};		-- third layer wall render lines
--Canvas.renderLinesGroundList = {};
Canvas.spriteList = {};
Canvas.spriteFrameList = {};
Canvas.rayAngle = nil;
Canvas.WallHeight = Canvas.resolution.y *1;
Canvas.totalSprites = 0;
Canvas.walkOffset = 0;
Canvas.currentFloor = nil;
Canvas.currentDoorAnimation = nil;
Canvas.animatingDoor = false;
Canvas.openDoor = nil;
Canvas.doorCoords = {};
Canvas.ambientLight = { 1, 1, 1 };
Canvas.fogColor = { 1, 1, 1 }; -- reverse rgb values (1,1,1) = black
Canvas.fogDistance = 15;

function Canvas.DoorAnimation()
	if Canvas.animatingDoor == true then
		if Canvas.openDoor == true then
			if Canvas.currentDoorAnimation > 0 then
				Canvas.currentDoorAnimation = Canvas.currentDoorAnimation - Settings.DoorOpenSpeed;
			else
				Canvas.animatingDoor = false;
			end
		elseif Canvas.openDoor == false then
			if Canvas.currentDoorAnimation < 1 then
				Canvas.currentDoorAnimation = Canvas.currentDoorAnimation + Settings.DoorOpenSpeed;
			else
				Canvas.animatingDoor = false;
			end
		end
		Map.Doors[Canvas.doorCoords.x][Canvas.doorCoords.y] = Canvas.currentDoorAnimation;
		--Map.Data[Canvas.doorCoords.x][Canvas.doorCoords.y].property = Canvas.currentDoorAnimation;
	end
end

function Canvas.OpenDoor(x,y)
	Canvas.doorCoords.x = x;
	Canvas.doorCoords.y = y;
	Canvas.animatingDoor = true;
	Canvas.openDoor = true;
	Canvas.currentDoorAnimation = 1;
end

function Canvas.CloseDoor(x,y)
	Canvas.doorCoords.x = x;
	Canvas.doorCoords.y = y;
	Canvas.animatingDoor = true;
	Canvas.openDoor = false;
	Canvas.currentDoorAnimation = 0;
end

function Canvas.FloorCheck()
	local properties = Properties[Map.Data[math.floor(Player.Position.x)][math.floor(Player.Position.y)]];
	if properties.floor == true then
		if properties ~= Canvas.currentFloor then
			Canvas.currentFloor = properties;
			Canvas.renderFrame.texture:SetVertexColor(properties.color[1],properties.color[2],properties.color[3],properties.color[4]);
		end
	else
		-- check forward based on player orientation
		--properties = Properties[Map.Data[math.floor(Player.Position.x)][math.floor(Player.Position.y)].blockType];
	end
	--Properties[DataType.Floor6D]
end

-- Create the canvas elements --
function Canvas.Create()
	-- calculate the distance in degrees between each ray
	Canvas.rayAngle = Player.FoV/Canvas.renderLines;

	-- create the main frame that will hold the canvas
	Canvas.mainFrame = CreateFrame("ScrollFrame",nil,UIParent);
	Canvas.mainFrame:SetFrameStrata("BACKGROUND");
	Canvas.mainFrame:SetWidth(Canvas.resolution.x) -- Set these to whatever height/width is needed 
	Canvas.mainFrame:SetHeight(Canvas.resolution.y + Canvas.HUDBarHeight) -- for your Texture
	Canvas.mainFrame.texture = Canvas.mainFrame:CreateTexture(nil,"BACKGROUND")
	Canvas.mainFrame.texture:SetColorTexture(0,0,0,1);
	Canvas.mainFrame.texture:SetAllPoints(Canvas.mainFrame)
	Canvas.mainFrame:SetPoint("LEFT",0,0);
	Canvas.mainFrame:Show();
	Canvas.mainFrame:SetFrameLevel(8);
	Canvas.mainFrame:SetClipsChildren(true);
	Canvas.mainFrame:SetScale(Canvas.scale);

	-- skybox
	Canvas.skyBox = CreateFrame("PlayerModel",nil,Canvas.mainFrame);
	Canvas.skyBox:SetFrameStrata("BACKGROUND");
	Canvas.skyBox:SetWidth(Canvas.resolution.x) -- Set these to whatever height/width is needed 
	Canvas.skyBox:SetHeight(Canvas.resolution.y + 20) -- for your Texture	
	Canvas.skyBox:SetPoint("CENTER",0, Canvas.HUDBarHeight /2);
	Canvas.skyBox:Show();
	Canvas.skyBox:SetFrameLevel(9);
	--Canvas.skyBox:SetModel(130623); -- legion green skybox
	Canvas.skyBox:SetModel(130623);
	--Canvas.skyBox:SetRotation(0);

	-- create the screen frame where everything is rendered
	Canvas.renderFrame = CreateFrame("Frame",nil,Canvas.mainFrame);
	Canvas.renderFrame:SetFrameStrata("BACKGROUND");
	Canvas.renderFrame:SetWidth(Canvas.resolution.x) -- Set these to whatever height/width is needed 
	Canvas.renderFrame:SetHeight(Canvas.resolution.y + 20) -- for your Texture
	Canvas.renderFrame:SetPoint("CENTER",0, Canvas.HUDBarHeight /2);
	Canvas.renderFrame:Show();
	Canvas.renderFrame:SetFrameLevel(10);
	Canvas.renderFrame:SetClipsChildren(true);	
	Canvas.mainFrame:SetScrollChild(Canvas.renderFrame);

	Canvas.groundFrame = CreateFrame("Frame",nil,Canvas.renderFrame);
	Canvas.groundFrame:SetFrameStrata("BACKGROUND");
	Canvas.groundFrame:SetWidth(Canvas.resolution.x) -- Set these to whatever height/width is needed 
	Canvas.groundFrame:SetHeight(Canvas.resolution.y/2 + 20) -- for your Texture
	Canvas.groundFrame.texture = Canvas.groundFrame:CreateTexture(nil,"BACKGROUND")
	Canvas.groundFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\Background.blp", false);
	Canvas.groundFrame.texture:SetTexCoord(0, 1, 0.5, 1)
	Canvas.groundFrame.texture:SetVertexColor(.3,.3,.3,1);
	Canvas.groundFrame.texture:SetAllPoints(Canvas.groundFrame)
	Canvas.groundFrame:SetPoint("BOTTOM",0, 0);
	Canvas.groundFrame:Show();
	Canvas.groundFrame:SetFrameLevel(10);

	-- create the wall frames
	for k = 1, Canvas.renderLines, 1 do
		Canvas.renderLine = CreateFrame("Frame",nil,Canvas.renderFrame);
		Canvas.renderLine:SetFrameStrata("BACKGROUND");
		Canvas.renderLine:SetWidth(Canvas.renderDensity) -- Set these to whatever height/width is needed 
		Canvas.renderLine:SetHeight(10) -- for your Texture
		Canvas.renderLine.texture = Canvas.renderLine:CreateTexture(nil,"BACKGROUND")
		Canvas.renderLine.texture:SetTexture("tileset/expansion05/spiresofarrak/6sa_rock01_1024.blp",false);
		Canvas.renderLine.texture:SetAllPoints(Canvas.renderLine);
		Canvas.renderLine:SetPoint("LEFT",(k * Canvas.renderDensity) - (Canvas.renderDensity/2) - 0.01, 0);
		Canvas.renderLine:Show();
		Canvas.renderLine:SetFrameLevel(16);	
		Canvas.renderLinesList[k] = Canvas.renderLine;
	end

	-- create the wall frames layer 2
	for k = 1, Canvas.renderLines, 1 do
		Canvas.renderLine2 = CreateFrame("Frame",nil,Canvas.renderFrame);
		Canvas.renderLine2:SetFrameStrata("BACKGROUND");
		Canvas.renderLine2:SetWidth(Canvas.renderDensity) -- Set these to whatever height/width is needed 
		Canvas.renderLine2:SetHeight(10) -- for your Texture
		Canvas.renderLine2.texture = Canvas.renderLine2:CreateTexture(nil,"BACKGROUND")
		Canvas.renderLine2.texture:SetTexture("tileset/expansion05/spiresofarrak/6sa_rock01_1024.blp",false);
		Canvas.renderLine2.texture:SetAllPoints(Canvas.renderLine2);
		Canvas.renderLine2:SetPoint("LEFT",(k * Canvas.renderDensity) - (Canvas.renderDensity/2) - 0.01, 100);
		Canvas.renderLine2:Show();
		Canvas.renderLine2:SetFrameLevel(16);	
		Canvas.renderLinesList2[k] = Canvas.renderLine2;
	end	

	-- create the wall frames layer 3
	for k = 1, Canvas.renderLines, 1 do
		Canvas.renderLine3 = CreateFrame("Frame",nil,Canvas.renderFrame);
		Canvas.renderLine3:SetFrameStrata("BACKGROUND");
		Canvas.renderLine3:SetWidth(Canvas.renderDensity) -- Set these to whatever height/width is needed 
		Canvas.renderLine3:SetHeight(10) -- for your Texture
		Canvas.renderLine3.texture = Canvas.renderLine3:CreateTexture(nil,"BACKGROUND")
		Canvas.renderLine3.texture:SetTexture("tileset/expansion05/spiresofarrak/6sa_rock01_1024.blp",false);
		Canvas.renderLine3.texture:SetAllPoints(Canvas.renderLine3);
		Canvas.renderLine3:SetPoint("LEFT",(k * Canvas.renderDensity) - (Canvas.renderDensity/2) - 0.01, 0);
		Canvas.renderLine3:Show();
		Canvas.renderLine3:SetFrameLevel(16);	
		Canvas.renderLinesList3[k] = Canvas.renderLine3;
	end	

	-- create HUD frame
	Canvas.HUDFrame = CreateFrame("Frame",nil,Canvas.mainFrame);
	Canvas.HUDFrame:SetFrameStrata("MEDIUM");
	Canvas.HUDFrame:SetWidth(Canvas.resolution.x) -- Set these to whatever height/width is needed 
	Canvas.HUDFrame:SetHeight(Canvas.HUDBarHeight) -- for your Texture
	Canvas.HUDFrame:SetPoint("BOTTOM",0,0);
	Canvas.HUDFrame:Show();
	Canvas.HUDFrame:SetFrameLevel(100);
	Canvas.HUDFrame.texture = Canvas.HUDFrame:CreateTexture(nil,"BACKGROUND")
	Canvas.HUDFrame.texture:SetColorTexture(0.5,0.5,0.5,1);
	Canvas.HUDFrame.texture:SetAllPoints(Canvas.HUDFrame)
	--Canvas.HUDFrame:SetClipsChildren(true);

	Canvas.CreateFloor();
end

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

function Canvas.CreateFloor()
	Canvas.Floor = {}
	-- create the floor frames
	for k = 1, Canvas.groundVisLines, 1 do
		Canvas.Floor[k] = CreateFrame("Frame",nil,Canvas.renderFrame);
		Canvas.Floor[k]:SetFrameStrata("BACKGROUND");
		Canvas.Floor[k]:SetWidth(Canvas.resolution.x) -- Set these to whatever height/width is needed 
		Canvas.Floor[k]:SetHeight(5) -- for your Texture
		Canvas.Floor[k].texture = Canvas.Floor[k]:CreateTexture(nil,"BACKGROUND")
		Canvas.Floor[k].texture:SetTexture(Textures.Ground1,"REPEAT", "REPEAT");
		Canvas.Floor[k].texture:SetTexCoord(0, 1, k * 0.02, k * 0.02 - 0.02)
		Canvas.Floor[k].texture:SetAllPoints(Canvas.Floor[k]);
		Canvas.Floor[k]:SetPoint("BOTTOM", 0, (k * 5) - 5);
		local vertexColor = 1 - (k/Canvas.groundVisLines - 0.1);
		Canvas.Floor[k].texture:SetVertexColor(vertexColor * Canvas.ambientLight[1], vertexColor* Canvas.ambientLight[2], vertexColor* Canvas.ambientLight[3]);
		Canvas.Floor[k]:Show();
		Canvas.Floor[k]:SetFrameLevel(16);	
	end	
end


function Canvas.CreateGunFrame()
	-- create GunFrame
	Canvas.gunFrame = CreateFrame("DressUpModel",nil,Canvas.renderFrame);
	Canvas.gunFrame:SetFrameStrata("MEDIUM");
	Canvas.gunFrame:SetWidth(300) -- Set these to whatever height/width is needed 
	Canvas.gunFrame:SetHeight(300) -- for your Texture
	Canvas.gunFrame:SetItem(159657)
    Canvas.gunFrame:SetAnimation(0);
    Canvas.gunFrame:SetRotation(math.rad(200))
    Canvas.gunFrame:SetAlpha(1)
    --Canvas.gunFrame:SetCustomCamera(1)
    local cx, cy, cz = Canvas.gunFrame:GetCameraPosition()
    --Zee.Worgenstein.Canvas.gunFrame:SetPosition(1, 0.3, 0.5)
	Canvas.gunFrame:SetPoint("BOTTOMRIGHT",0, 0);
	Canvas.gunFrame:Show();
	Canvas.gunFrame:SetFrameLevel(90);

    Canvas.gunFrame:SetUnit('player');
	Canvas.gunFrame:SetCustomRace(1);
	Canvas.gunFrame:Undress()
	--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(159657);
    Canvas.gunFrame:TryOn(95444);
    Canvas.gunFrame:SetCustomCamera(1);
	Canvas.gunFrame:SetAnimation(49);	

	-- left handed
	--Canvas.gunFrame:SetCameraPosition(0, 0.1, 1);
	--Canvas.gunFrame:SetPosition(1,1,0);1269534
	--Canvas.gunFrame:SetRotation(0);

	-- right handed
	--Canvas.gunFrame:SetCameraPosition(0, 0, 0.51);
	Canvas.gunFrame:SetCameraPosition(-0.7, -0.4, 1);
	
	--Canvas.gunFrame:SetPosition(0.5,-0.4,-1);
	Canvas.gunFrame:SetPosition(-0.4,-0.8,-0.8);
	--Canvas.gunFrame:SetRotation(0.9);
	Canvas.gunFrame:SetRotation(1);


	Canvas.gunParticleFrame = CreateFrame("PlayerModel",nil,Canvas.renderFrame);
	Canvas.gunParticleFrame:SetFrameStrata("MEDIUM");
	Canvas.gunParticleFrame:SetWidth(500) -- Set these to whatever height/width is needed 
	Canvas.gunParticleFrame:SetHeight(500) -- for your Texture
	Canvas.gunParticleFrame:SetPoint("BOTTOMRIGHT",0, 0);
	Canvas.gunParticleFrame:Hide();
	Canvas.gunParticleFrame:SetFrameLevel(80);
	Canvas.gunParticleFrame:SetModel(1269534);
	Canvas.gunParticleFrame:SetPosition(-50, 5, -28);
	Canvas.gunParticleFrame:SetAlpha(0.2);
	Canvas.gunParticleFrame.timer = 1;
	--Canvas.gunParticleFrame:SetAnimation(0);
	--/run Zee.Worgenstein.Canvas.gunParticleFrame:SetPosition(0, 0, 1);
end

function Canvas.CalculateAngle(cx, cy, ex, ey)
	  local dy = ey - cy;
	  local dx = ex - cx;
	  local theta = math.atan2(dy, dx); -- range (-PI, PI]
	  theta = theta * 180 / math.pi; -- rads to degs, range (-180, 180]
	  --while theta < 0 do theta = 360 + theta; end -- range [0, 360)
	  --while theta > 360 do theta = theta - 360; end
	  return theta;
end
--[=[
function Canvas.CreateSpriteFrames()
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
		Canvas.spriteFrameList[s] = sprite;
	end
	Canvas.LoadSpriteData();
end

function Canvas.LoadSpriteData()
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
					Canvas.spriteList[spriteIndex] = sprite;
				end
			end
		end
	end
	Canvas.totalSprites = spriteIndex;
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

function Canvas.CreateSpriteFrames()
	local spriteIndex = 0;
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			local property = Properties[Map.Data[x][y]];
			if property ~= nil then
				if property.sprite == true then
					spriteIndex = spriteIndex + 1;
					Canvas.sprite = CreateFrame("DressUpModel",BlockName[Map.Data[x][y] + 1] .. "["..spriteIndex.."]",Canvas.renderFrame);
					Canvas.sprite:SetFrameStrata("BACKGROUND");
					Canvas.sprite:SetWidth(30) -- Set these to whatever height/width is needed 
					Canvas.sprite:SetHeight(80) -- for your Texture
				    if property.displayID ~= nil then
				    	Canvas.sprite:SetDisplayInfo(property.displayID)
				    end
				    if property.modelPath ~= nil then
				    	Canvas.sprite:SetModel(property.modelPath)
				    end

				    -- debug
				    if Settings.DEBUG_Sprites == true then
						Canvas.sprite.texture = Canvas.sprite:CreateTexture(nil,"BACKGROUND")
						Canvas.sprite.texture:SetColorTexture(1,0,0,0.1);
						Canvas.sprite.texture:SetAllPoints(Canvas.sprite)
					end

					-- shadow
					--[[
					Canvas.sprite.bg = CreateFrame("Frame", Canvas.sprite);
					Canvas.sprite.bg:SetFrameStrata("BACKGROUND");
					Canvas.sprite.bg:SetWidth(300) -- Set these to whatever height/width is needed 
					Canvas.sprite.bg:SetHeight(800) -- for your Texture
					Canvas.sprite.bg:SetPoint("CENTER", Canvas.sprite, "CENTER", 0, 0)
					Canvas.sprite.bg.texture = Canvas.sprite.bg:CreateTexture(nil,"BACKGROUND")
					Canvas.sprite.bg.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\Shadow.blp", false);
					Canvas.sprite.bg.texture:SetAllPoints(Canvas.sprite.bg)
					--]]

				    if property.enemy == true then
					    if property.alive == false then
					    	Canvas.sprite:SetAnimation(property.Ani_Dead);
					    elseif property.alive == true then
					    	--Canvas.sprite:ClearModel()
					    	Canvas.sprite:SetUnit('player');
					    	Canvas.sprite:SetCustomRace(1);
					    	Canvas.sprite:Undress()
					    	--local appearanceID, sourceID = C_TransmogCollection.GetItemInfo(159657);
						    Canvas.sprite:TryOn(95444);
						    Canvas.sprite:TryOn(1687);
						    Canvas.sprite:TryOn(9391);
						    Canvas.sprite:TryOn(1655);
						    Canvas.sprite:TryOn(4230);
					    	Canvas.sprite:SetAnimation(property.Ani_IdleGun);
					    end
					end

					local startRotation = 0;
					local currentRotation = 0;
					if property.startRotation ~= nil then
						startRotation = property.startRotation;
					end
					currentRotation = startRotation;
					Canvas.sprite.currentRotation = currentRotation;
					Canvas.sprite.rotateTo = currentRotation;
					Canvas.sprite.moveToX = x;
					Canvas.sprite.moveToY = y;
					Canvas.sprite.offsetX = 0.5;
					Canvas.sprite.offsetY = 0.5;
					Canvas.sprite:SetRotation(math.rad(startRotation))

				    Canvas.sprite:SetAlpha(1);

				    if property.hasCamera == true then
						Canvas.sprite:SetCustomCamera(1);
						Canvas.sprite:SetCameraDistance(3);
						Canvas.sprite:SetCameraPosition(2.827, 0.017, 0.435);
					end

				    local pos = property.positionOffset;
				    Canvas.sprite:SetPosition(pos[1], pos[2], pos[3]);
					Canvas.sprite:SetPoint("LEFT",0, 0);
					--Canvas.sprite:Hide();
					Canvas.sprite:SetFrameLevel(17);	
					Canvas.spriteList[spriteIndex] = Canvas.sprite;
					Canvas.spriteList[spriteIndex].x = x;
					Canvas.spriteList[spriteIndex].y = y;
					Canvas.sprite.property = property;
				end
			end
		end
	end
	Canvas.totalSprites = spriteIndex;
end

--[=[
local width = 5;
local height = 10;
function Canvas.UpdateSprites()
	for s = 1, Canvas.totalSprites, 1 do
		-- calculate distance from player to sprite
		local distance = Ray.DistanceBetweenTwoPoints (Canvas.spriteList[s].x + Canvas.spriteList[s].offsetX, Canvas.spriteList[s].y + Canvas.spriteList[s].offsetY, Player.Position.x, Player.Position.y);
		local screenY;
		local visible = false;
		--	show/hide sprite based on distance
		if distance <= Settings.SpriteDrawDistance then
			-- calculate angle between player and sprite
			local angle = Canvas.CalculateAngle(Canvas.spriteList[s].x + Canvas.spriteList[s].offsetX, Canvas.spriteList[s].y + Canvas.spriteList[s].offsetY, Player.Position.x, Player.Position.y) - Player.Direction;
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
				if Canvas.spriteFrameList[a].available == false and Canvas.spriteFrameList[a].id == a then
					alreadyVisible = true;
					spriteFrameIndex = a;
				end
			end
			-- if it's not on screen, request new sprite
			if alreadyVisible == false then
				for a = 1, Settings.MaxSprites, 1 do
					if Canvas.spriteFrameList[a].available == true then
						spriteFrameIndex = a;
					end
				end
			end
			-- if we found a usable sprite - update it
			if spriteFrameIndex ~= nil then
				Canvas.spriteFrameList[spriteFrameIndex].available = false;
				local sprite = Canvas.spriteFrameList[spriteFrameIndex];
				-- set model
				if alreadyVisible == false then
					if Canvas.spriteList[s].property.displayID ~= nil then
				    	sprite:SetDisplayInfo(Canvas.spriteList[s].property.displayID)
				    end
				    if Canvas.spriteList[s].property.modelPath ~= nil then
				    	sprite:SetModel(Canvas.spriteList[s].property.modelPath)
				    end
				end
				-- set dimensions
				sprite:SetWidth(width / distance * 100);
				sprite:SetHeight(height / distance * 100);
				-- get 2D vertical offset
				local spriteYOff = 0;
				if Canvas.spriteList[s].property.spriteYOffset ~= nil then
					spriteYOff = Canvas.spriteList[s].property.spriteYOffset;
				end
				-- set 2D position
				sprite:SetPoint("LEFT",(screenY * Canvas.renderDensity) - sprite:GetWidth()/2, spriteYOff / distance);
				-- set 3D rotation --
				local rotation;
				if Canvas.spriteList[s].property.enemy == true then
					rotation = Canvas.spriteList[s].currentRotation;
					-- limit rotation betwttn 0 and 360 degrees
					if rotation > 360 then rotation = 360 - rotation; end
					if rotation < 0 then rotation = 360 + rotation; end
					sprite:SetRotation(math.rad(rotation));
				else
					rotation = -Player.Direction + Canvas.spriteList[s].currentRotation - (distance*2);
					-- limit rotation betwttn 0 and 360 degrees
					if rotation > 360 then rotation = 360 - rotation; end
					if rotation < 0 then rotation = 360 + rotation; end
					sprite:SetRotation(math.rad(rotation));
				end
				-- set camera
			    if Canvas.spriteList[s].property.hasCamera == true then
				    sprite:SetCustomCamera(1)
				    sprite:SetCameraDistance(3)
				    sprite:SetCameraPosition(2.827, 0.017, 0.435);
				end
				-- set Z depth --
				local zDepth = Canvas.GetZDepth(distance)
				sprite:SetFrameLevel(zDepth);
				-- set shading --
				if Canvas.spriteList[s].property.unshaded ~= true then
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
				if Canvas.spriteFrameList[a].available == false then--and Canvas.spriteFrameList[a].id == a then
					Canvas.spriteFrameList[a].available = true;
				end
			end
		end
	end
end
]=]

local width = 5;
local height = 10;
function Canvas.UpdateSprites()
	for s = 1, Canvas.totalSprites, 1 do
		local distance = Ray.DistanceBetweenTwoPoints (Canvas.spriteList[s].x + Canvas.spriteList[s].offsetX, Canvas.spriteList[s].y + Canvas.spriteList[s].offsetY, Player.Position.x, Player.Position.y);
		if (distance < Settings.SpriteDrawDistance) then 
			if Canvas.spriteList[s]:IsVisible() == false then
				Canvas.spriteList[s]:Show(); 
			    if Canvas.spriteList[s].property.displayID ~= nil then
			    	Canvas.spriteList[s]:SetDisplayInfo(Canvas.spriteList[s].property.displayID)
			    end
			    if Canvas.spriteList[s].property.modelPath ~= nil then
			    	Canvas.spriteList[s]:SetModel(Canvas.spriteList[s].property.modelPath)
			    end
			end		
		else 
			Canvas.spriteList[s]:Hide(); 
		end

		if Canvas.spriteList[s]:IsVisible() == true then

			-- ScreenPosition and Size --
			local screenY = Canvas.CalculateAngle(Canvas.spriteList[s].x + Canvas.spriteList[s].offsetX, Canvas.spriteList[s].y + Canvas.spriteList[s].offsetY, Player.Position.x, Player.Position.y) - Player.Direction;
			while screenY < 0 do screenY = 360 + screenY; end -- range [0, 360)
			while screenY > 360 do screenY = screenY - 360; end
			screenY = 180 - screenY;
			screenY = ((screenY / Player.FoV) * Canvas.renderLines) + Canvas.renderLines/2;
			Canvas.spriteList[s]:SetWidth(width / distance * 100);
			Canvas.spriteList[s]:SetHeight(height / distance * 100);
			local spriteYOff = 0;
			if Canvas.spriteList[s].property.spriteYOffset ~= nil then
				spriteYOff = Canvas.spriteList[s].property.spriteYOffset;
			end
			Canvas.spriteList[s]:SetPoint("LEFT",(screenY * Canvas.renderDensity) - Canvas.spriteList[s]:GetWidth()/2, spriteYOff / distance);

			-- Rotation --
			if Canvas.spriteList[s].property.enemy == true then
				local rotation = Canvas.spriteList[s].currentRotation;
				if rotation > 360 then rotation = 360 - rotation; end
				if rotation < 0 then rotation = 360 + rotation; end
				Canvas.spriteList[s]:SetRotation(math.rad(rotation));
			else
				local rotation = -Player.Direction  + Canvas.spriteList[s].currentRotation - (distance*2);
				if rotation > 360 then rotation = 360 - rotation; end
				if rotation < 0 then rotation = 360 + rotation; end
				Canvas.spriteList[s]:SetRotation(math.rad(rotation));
			end

			-- Camera fix

		    if Canvas.spriteList[s].property.hasCamera == true then
			    Canvas.spriteList[s]:SetCustomCamera(1)
			    Canvas.spriteList[s]:SetCameraDistance(3)
			    Canvas.spriteList[s]:SetCameraPosition(2.827, 0.017, 0.435);
			end			

			-- Z Depth --
			local zDepth = Canvas.GetZDepth(distance)
			Canvas.spriteList[s]:SetFrameLevel(zDepth);


			-- Fix for sprites exiting screen space --
			if distance < 0.5 or screenY < -20 or screenY > Canvas.renderLines + 20 then
				Canvas.spriteList[s]:SetAlpha(0);
			else
				Canvas.spriteList[s]:SetAlpha(1);
			end

			-- Shading --
			if Canvas.spriteList[s].property.unshaded ~= true then
				local shading = 1 - (distance/7);
				if shading < 0 then shading = 0; end
				Canvas.spriteList[s]:SetFogColor(0, 0, 0);
				Canvas.spriteList[s]:SetFogFar(shading * 15);
			end
		end
	end
end


-- Update the Canvas elements in real time --
function Canvas.Render()
	if Canvas.skyBox ~= nil then
		Canvas.skyBox:SetRotation(math.rad(-Player.Direction));
	end
	--Canvas.skyBox:SetPitch(math.rad(90));
	local previousHeight = 0;
	for k = 1, Canvas.renderLines, 1 do
		local direction = (Player.Direction + (Player.FoV/2)) - (k * Canvas.rayAngle);
		local ray = Ray.Cast(k, Player.Position.x, Player.Position.y, direction, 1000);
		local uv_direction = Properties[ray.blockType].uv_direction;
		local uv2_direction = Properties[ray.blockType].uv2_direction;
		if Canvas.WallHeight / ray.distanceCorrected > 1 then
			Canvas.renderLinesList[k]:SetHeight( Canvas.WallHeight / ray.distanceCorrected); 
			previousHeight = ray.distanceCorrected;
		else
			Canvas.renderLinesList[k]:SetHeight( Canvas.WallHeight / previousHeight); 
		end

		-- Z Depth --
		Canvas.renderLinesList[k]:SetFrameLevel(Canvas.GetZDepth(ray.distance));

		-- UV Map --
		if Properties[ray.blockType].coords ~= nil then
				if ray.edgeHit > 2 then	-- front edge
					Canvas.renderLinesList[k].texture:SetTexCoord(
						Properties[ray.blockType].coords[1] + ray.uvDistance * 0.125 * uv_direction,
						Properties[ray.blockType].coords[1] + ray.uvDistance * 0.125 * uv_direction + (ray.uvDirection * ray.distanceCorrected / 100 * 0.125 * uv_direction),
						Properties[ray.blockType].coords[3],
						Properties[ray.blockType].coords[4]
						);
				else -- side edge
					Canvas.renderLinesList[k].texture:SetTexCoord(
						Properties[ray.blockType].coords_side[1] + ray.uvDistance * 0.125 * uv_direction,
						Properties[ray.blockType].coords_side[1] + ray.uvDistance * 0.125 * uv_direction + (ray.uvDirection * ray.distanceCorrected / 100 * 0.125 * uv_direction),
						Properties[ray.blockType].coords_side[3],
						Properties[ray.blockType].coords_side[4]
						);
				end
		else
			Canvas.renderLinesList[k].texture:SetTexCoord(ray.uvDistance, ray.uvDistance + (ray.uvDirection * ray.distanceCorrected/100), 0, 1);
		end

		-- Shading --
		local distanceFogValue = 1 - (ray.distance/Canvas.fogDistance);
		if ray.edgeHit <= 2 then	-- hit side edge
			local darken = 0.7;
			distanceFogValue = distanceFogValue*darken;
		end
		local shading = { max(distanceFogValue, 1-Canvas.fogColor[1]), max(distanceFogValue, 1-Canvas.fogColor[2]), max(distanceFogValue, 1-Canvas.fogColor[3]) };



		if Properties[ray.blockType].color ~= nil then
			local color = Properties[ray.blockType].color;
			Canvas.renderLinesList[k].texture:SetVertexColor(
				color[1] * shading[1] * Canvas.ambientLight[1],
				color[2] * shading[2] * Canvas.ambientLight[2],
				color[3] * shading[3] * Canvas.ambientLight[3],
				color[4]);
		else
			Canvas.renderLinesList[k].texture:SetVertexColor(
				shading[1] * Canvas.ambientLight[1],
				shading[2] * Canvas.ambientLight[2],
				shading[3] * Canvas.ambientLight[3],
				1);
		end

		-- Texture --
		if Properties[ray.blockType].texture ~= nil then
			Canvas.renderLinesList[k].texture:SetTexture(Properties[ray.blockType].texture);
		else
			Canvas.renderLinesList[k].texture:SetColorTexture(0,1,0);
		end

		-- Second Layer - tall buildings --
		if Properties[ray.blockType].layer2 ~= SecondLayerType.Off then
			if Properties[ray.blockType].layer2_height == nil then Properties[ray.blockType].layer2_height = 1; end
			Canvas.renderLinesList2[k]:Show();
			local distance = ray.distanceCorrected;

			local h = 1;
			if Properties[ray.blockType].layer2_height ~= nil and Properties[ray.blockType].layer2_height_side ~= nil then
				if ray.edgeHit > 2 then	-- front edge
					h = Properties[ray.blockType].layer2_height;
				else
					h = Properties[ray.blockType].layer2_height_side;
				end
			end
			Canvas.renderLinesList2[k]:SetPoint(
				"LEFT",
				(k * Canvas.renderDensity) - (Canvas.renderDensity/2) - 0.01,
				(Canvas.WallHeight * (h / 2) + (Canvas.WallHeight / 2)) / distance
			);
			Canvas.renderLinesList2[k]:SetHeight( (Canvas.WallHeight * h) / distance ); 
			
			-- Z Depth --
			Canvas.renderLinesList2[k]:SetFrameLevel(Canvas.GetZDepth(ray.distance) - 1);

			-- UV Map --
			if Properties[ray.blockType].coords2 ~= nil then
				if ray.edgeHit > 2 then	-- front edge
					Canvas.renderLinesList2[k].texture:SetTexCoord(
						Properties[ray.blockType].coords2[1] + ray.uvDistance * 0.125* uv2_direction,
						Properties[ray.blockType].coords2[1] + ray.uvDistance * 0.125* uv2_direction + (ray.uvDirection * ray.distanceCorrected / 100 * 0.125* uv2_direction),
						Properties[ray.blockType].coords2[3],
						Properties[ray.blockType].coords2[4]
						);
				else -- side edge
					Canvas.renderLinesList2[k].texture:SetTexCoord(
						Properties[ray.blockType].coords2_side[1] + ray.uvDistance * 0.125 * uv2_direction,
						Properties[ray.blockType].coords2_side[1] + ray.uvDistance * 0.125 * uv2_direction + (ray.uvDirection * ray.distanceCorrected / 100 * 0.125 * uv2_direction),
						Properties[ray.blockType].coords2_side[3],
						Properties[ray.blockType].coords2_side[4]
						);
				end
			else
				Canvas.renderLinesList2[k].texture:SetTexCoord(ray.uvDistance, ray.uvDistance + (ray.uvDirection * ray.distanceCorrected/100), 0, 1);
			end
			
			-- Shading --
			if Properties[ray.blockType].color ~= nil then
				local color = Properties[ray.blockType].color;
				Canvas.renderLinesList2[k].texture:SetVertexColor(
					color[1] * shading[1] * Canvas.ambientLight[1],
					color[2] * shading[2] * Canvas.ambientLight[2],
					color[3] * shading[3] * Canvas.ambientLight[3],
					color[4]);
			else
				Canvas.renderLinesList2[k].texture:SetVertexColor(
					shading[1] * Canvas.ambientLight[1],
					shading[2] * Canvas.ambientLight[2],
					shading[3] * Canvas.ambientLight[3],
					1);
			end

			-- Texture --
			Canvas.renderLinesList2[k].texture:SetTexture(Properties[ray.blockType].layer2_texture);
		else
			Canvas.renderLinesList2[k]:Hide();
		end

		-- Third Layer - passthrough walls --
		if ray.passthrough == true then
			local uv3_direction = Properties[ray.blockType2].uv_direction;
			Canvas.renderLinesList3[k]:Show();
			if Canvas.WallHeight / ray.distanceCorrected2 > 1 then
				Canvas.renderLinesList3[k]:SetHeight( Canvas.WallHeight / ray.distanceCorrected2); 
				previousHeight = ray.distanceCorrected2;
			else
				Canvas.renderLinesList3[k]:SetHeight( Canvas.WallHeight / previousHeight); 
			end

			-- Z Depth --
			Canvas.renderLinesList3[k]:SetFrameLevel(Canvas.GetZDepth(ray.distance2));

			-- UV Map --
			if Properties[ray.blockType2].coords ~= nil then
					if ray.edgeHit2 > 2 then	-- front edge
						Canvas.renderLinesList3[k].texture:SetTexCoord(
							Properties[ray.blockType2].coords[1] + ray.uvDistance2 * 0.125 * uv3_direction,
							Properties[ray.blockType2].coords[1] + ray.uvDistance2 * 0.125 * uv3_direction + (ray.uvDirection2 * ray.distanceCorrected2 / 100 * 0.125 * uv3_direction),
							Properties[ray.blockType2].coords[3],
							Properties[ray.blockType2].coords[4]
							);
					else -- side edge
						Canvas.renderLinesList3[k].texture:SetTexCoord(
							Properties[ray.blockType2].coords_side[1] + ray.uvDistance2 * 0.125 * uv3_direction,
							Properties[ray.blockType2].coords_side[1] + ray.uvDistance2 * 0.125 * uv3_direction + (ray.uvDirection2 * ray.distanceCorrected2 / 100 * 0.125 * uv3_direction),
							Properties[ray.blockType2].coords_side[3],
							Properties[ray.blockType2].coords_side[4]
							);
					end
			else
				Canvas.renderLinesList3[k].texture:SetTexCoord(ray.uvDistance2, ray.uvDistance2 + (ray.uvDirection2 * ray.distanceCorrected2/100), 0, 1);
			end

			-- Shading --
			local distanceFogValue = 1 - (ray.distance2/Canvas.fogDistance);
			if ray.edgeHit2 <= 2 then	-- hit side edge
				local darken = 0.7;
				distanceFogValue = distanceFogValue*darken;
			end
			local shading = { max(distanceFogValue, 1-Canvas.fogColor[1]), max(distanceFogValue, 1-Canvas.fogColor[2]), max(distanceFogValue, 1-Canvas.fogColor[3]) };

			if Properties[ray.blockType2].color ~= nil then
				local color = Properties[ray.blockType2].color;
				Canvas.renderLinesList3[k].texture:SetVertexColor(
					color[1] * shading[1] * Canvas.ambientLight[1],
					color[2] * shading[2] * Canvas.ambientLight[2],
					color[3] * shading[3] * Canvas.ambientLight[3],
					color[4]);
			else
				Canvas.renderLinesList3[k].texture:SetVertexColor(
					shading[1] * Canvas.ambientLight[1],
					shading[2] * Canvas.ambientLight[2],
					shading[3] * Canvas.ambientLight[3],
					1);
			end

			-- Texture --
			if Properties[ray.blockType2].texture ~= nil then
				Canvas.renderLinesList3[k].texture:SetTexture(Properties[ray.blockType2].texture);
			else
				Canvas.renderLinesList3[k].texture:SetColorTexture(0,1,0);
			end			

		else
			Canvas.renderLinesList3[k]:Hide()
		end
	end

	-- floor
	--Canvas.FloorCheck(); -- skipping, real game doesn't seem to switch the floor color either
	Canvas.UpdateFloor();

	-- door
	Canvas.DoorAnimation();
end

function Canvas.GetZDepth(distance)
	local level = 500-(distance*5);
	if level < 20 then level = 20; end
	return floor(level);
end

function Canvas.DistanceCulling()

	for s = 1, Canvas.totalSprites, 1 do
		--local distance = Ray.DistanceBetweenTwoPoints(Player.Position.x, Player.Position.y, Canvas.spriteList[s].x, Canvas.spriteList[s].y);
		local distance = distance(Player.Position.x, Player.Position.y, Canvas.spriteList[s].x, Canvas.spriteList[s].y);
		if distance < Settings.SpriteDrawDistance then
			Canvas.spriteList[s]:Show();
		else
			Canvas.spriteList[s]:Hide();
		end

		if Canvas.spriteList[s].property.modelPath == 642794 and Canvas.spriteList[s].y == 38 then
			--print (distance);
		end
	end
end

function Canvas.Walk()
	if Canvas.walkOffset > 2 * math.pi then
		Canvas.walkOffset = 0;
	end
	Canvas.walkOffset = Canvas.walkOffset + 0.1;
	Canvas.renderFrame:ClearAllPoints();
	Canvas.renderFrame:SetPoint("CENTER",0, Canvas.HUDBarHeight /2 + (math.sin(Canvas.walkOffset) * Settings.canvasWalkStrength));
end

function Canvas.ResetWalk()
	--[[
	if Canvas.walkOffset > math.pi then
		Canvas.walkOffset = Canvas.walkOffset - 0.1;
		Canvas.renderFrame:ClearAllPoints();
		Canvas.renderFrame:SetPoint("CENTER",0, Canvas.HUDBarHeight /2 + (math.sin(Canvas.walkOffset) * Settings.canvasWalkStrength));
	end
	if Canvas.walkOffset > 0 then
		Canvas.walkOffset = Canvas.walkOffset - 0.1;
		Canvas.renderFrame:ClearAllPoints();
		Canvas.renderFrame:SetPoint("CENTER",0, Canvas.HUDBarHeight /2 + (math.sin(Canvas.walkOffset) * Settings.canvasWalkStrength));
	end	
	--]]	
end

-- "tileset/expansion05/spiresofarrak/6sa_rock01_1024.blp"


local halfFoV, dirPlusFoV, dirMinusFoV, verticalFoV, halfVerticalFoV, verticalAngleIncrement, oppositeAngle, newOppositeAngle, distanceFromOrigin;
local groundPosition = 0.6;
local distanceToProjectionPlane = 0.2;
local distModifier = distanceToProjectionPlane;
local x1, y1, x2, y2, x3, y3, x4, y4;
function Canvas.UpdateFloor()
	halfFoV = Player.FoV/2;
	dirPlusFoV = Player.Direction + halfFoV;
	dirMinusFoV = Player.Direction - halfFoV;
	verticalFoV = (Canvas.resolution.y / Canvas.resolution.x) * Player.FoV;
	halfVerticalFoV = verticalFoV / 2;
	verticalAngleIncrement = halfVerticalFoV / Canvas.groundVisLines;
	oppositeAngle = 90 - halfVerticalFoV;

	for k = 1, 50, 1 do	
		x1 = cos(dirPlusFoV) * distModifier + Player.Position.xCell;
		y1 = sin(dirPlusFoV) * distModifier + Player.Position.yCell;
		x3 = cos(dirMinusFoV) * distModifier + Player.Position.xCell;
		y3 = sin(dirMinusFoV) * distModifier + Player.Position.yCell;

		newOppositeAngle = oppositeAngle + (k * verticalAngleIncrement);
		distanceFromOrigin = tan(newOppositeAngle) * groundPosition;
		distModifier = min((distanceFromOrigin - distanceToProjectionPlane),100);

		x2 = cos(dirPlusFoV) * distModifier + Player.Position.xCell;
		y2 = sin(dirPlusFoV) * distModifier + Player.Position.yCell;
		x4 = cos(dirMinusFoV) * distModifier + Player.Position.xCell;
		y4 = sin(dirMinusFoV) * distModifier + Player.Position.yCell;
		Canvas.Floor[k].texture:SetTexCoord(x2,y2,x1,y1,x4,y4,x3,y3);
	end
end