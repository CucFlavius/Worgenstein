local Canvas = Zee.Worgenstein.Canvas;
local Map = Zee.Worgenstein.Map;
local Player = Zee.Worgenstein.Player;
local Ray = Zee.Worgenstein.Raycasting;
local Settings = Zee.Worgenstein.Settings;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local SecondLayerType = Zee.Worgenstein.Map.DataTypeProperties.SecondLayerType;
local Ground = Zee.Worgenstein.Ground;
local Door = Zee.Worgenstein.Door;

-- Properties --
Canvas.resolution = {};
Canvas.resolution.x = 640;
Canvas.resolution.y = 480;
Canvas.scale = 1.6;
Canvas.renderDensity = 4;
Canvas.renderDensityGround = 8;
Canvas.renderLines = Canvas.resolution.x / Canvas.renderDensity;
--Canvas.renderLinesVertical = Canvas.resolution.y / Canvas.renderDensityGround;
Canvas.HUDBarHeight = 100;
Canvas.renderLinesList = {};
--Canvas.renderLinesGroundList = {};
Canvas.rayAngle = nil;
Canvas.WallHeight = Canvas.resolution.y *1;
Canvas.walkOffset = 0;
Canvas.ambientLight = { 1, 1, 1 };
Canvas.fogColor = { 1, 1, 1 }; -- reverse rgb values (1,1,1) = black
Canvas.fogDistance = 15;

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
	Canvas.mainFrame:SetPoint("LEFT",100,0);
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
	Canvas.skyBox:SetModel(130623);
	--Zee.Worgenstein.Canvas.skyBox:SetPosition(50,160,140);
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

    Zee.Worgenstein.Ground.CreateFloor();
end

-- Update the Canvas elements in real time --
function Canvas.Render()
	if Canvas.skyBox ~= nil then
		Canvas.skyBox:SetRotation(math.rad(-Player.Direction));
	end

	local previousHeight = 0;
	for k = 1, Canvas.renderLines, 1 do
		local direction = (Player.Direction + (Player.FoV/2)) - (k * Canvas.rayAngle);
		local ray = Ray.Cast(k, Player.Position.x, Player.Position.y, direction, 1000);
		if Canvas.WallHeight / ray.distanceCorrected > 1 then
			Canvas.renderLinesList[k]:SetHeight( Canvas.WallHeight / ray.distanceCorrected); 
			previousHeight = ray.distanceCorrected;
		else
			Canvas.renderLinesList[k]:SetHeight( Canvas.WallHeight / previousHeight); 
		end

		-- Z Depth --
		Canvas.renderLinesList[k]:SetFrameLevel(Canvas.GetZDepth(ray.distance));

		-- UV Map --
		if Properties[ray.blockType].wall == true then
			Canvas.renderLinesList[k].texture:SetTexCoord(ray.uvDistance, ray.uvDistance + (ray.uvDirection * ray.distanceCorrected/100), 1, 0)
		end
		if Properties[ray.blockType].door == true then
			Canvas.renderLinesList[k].texture:SetTexCoord(ray.uvDistance, ray.uvDistance + (ray.uvDirection * ray.distanceCorrected/100), 1, 0)
		end

		-- Shading --
		local distanceFogValue = 1 - (ray.distance/Canvas.fogDistance);
		if ray.edgeHit <= 2 then	-- hit side edge
			local darken = 0.7;
			distanceFogValue = distanceFogValue*darken;
		end
		local shading = { max(distanceFogValue, 1-Canvas.fogColor[1]), max(distanceFogValue, 1-Canvas.fogColor[2]), max(distanceFogValue, 1-Canvas.fogColor[3]) };


        -- ambient light --
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
	end

	-- floor
	Ground.UpdateFloor();

	-- door
	Door.DoorAnimation();
end


function Canvas.GetZDepth(distance)
	local level = 500-(distance*5);
	if level < 20 then level = 20; end
	return floor(level);
end

function Canvas.DistanceCulling()

	for s = 1, Canvas.totalSprites, 1 do
		--local distance = Ray.DistanceBetweenTwoPoints(Player.Position.x, Player.Position.y, Sprites.spriteList[s].x, Sprites.spriteList[s].y);
		local distance = distance(Player.Position.x, Player.Position.y, Sprites.spriteList[s].x, Sprites.spriteList[s].y);
		if distance < Settings.SpriteDrawDistance then
			Sprites.spriteList[s]:Show();
		else
			Sprites.spriteList[s]:Hide();
		end

		if Sprites.spriteList[s].property.modelPath == 642794 and Sprites.spriteList[s].y == 38 then
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