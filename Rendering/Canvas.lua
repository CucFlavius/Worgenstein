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
Canvas.renderLines = Canvas.resolution.x / Canvas.renderDensity;
--Canvas.renderLinesVertical = Canvas.resolution.y / Canvas.renderDensityGround;
Canvas.HUDBarHeight = 100;
Canvas.renderLinesList = {};		-- first layer wall render lines
Canvas.renderLinesList2 = {};		-- second layer wall render lines
Canvas.renderLinesList3 = {};		-- third layer wall render lines
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

	Zee.Worgenstein.Ground.CreateFloor();
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