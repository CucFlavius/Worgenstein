local Ground = Zee.Worgenstein.Ground;
local Canvas = Zee.Worgenstein.Canvas;
local Textures = Zee.Worgenstein.Textures;
local Player = Zee.Worgenstein.Player;
local Debugger = Zee.Worgenstein.Debugger;
local Ray = Zee.Worgenstein.Raycasting;
local Map = Zee.Worgenstein.Map;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;

Ground.groundVisLines = 50;
Ground.renderDensityGround = 8;
Ground.currentFloor = nil;

function Ground.FloorCheck()
	local properties = Properties[Map.Data[math.floor(Player.Position.x)][math.floor(Player.Position.y)]];
	if properties.floor == true then
		if properties ~= Ground.currentFloor then
			Ground.currentFloor = properties;
			Ground.renderFrame.texture:SetVertexColor(properties.color[1],properties.color[2],properties.color[3],properties.color[4]);
		end
	else
		-- check forward based on player orientation
		--properties = Properties[Map.Data[math.floor(Player.Position.x)][math.floor(Player.Position.y)].blockType];
	end
	--Properties[DataType.Floor6D]
end


function Ground.CreateFloor()
	Ground.Floor = {}
	-- create the floor frames
	for k = 1, Ground.groundVisLines, 1 do
		Ground.Floor[k] = CreateFrame("Frame",nil,Canvas.renderFrame);
		Ground.Floor[k]:SetFrameStrata("BACKGROUND");
		Ground.Floor[k]:SetWidth(Canvas.resolution.x) -- Set these to whatever height/width is needed 
		Ground.Floor[k]:SetHeight(5) -- for your Texture
		Ground.Floor[k].texture = Ground.Floor[k]:CreateTexture(nil,"BACKGROUND")
		Ground.Floor[k].texture:SetTexture(Textures.Ground0,"REPEAT", "REPEAT");
		Ground.Floor[k].texture:SetTexCoord(0, 1, k * 0.02, k * 0.02 - 0.02)
		Ground.Floor[k].texture:SetAllPoints(Ground.Floor[k]);
		Ground.Floor[k]:SetPoint("BOTTOM", 0, (k * 5) - 5);
		local vertexColor = 1 - (k/Ground.groundVisLines - 0.1);
		Ground.Floor[k].texture:SetVertexColor(vertexColor * Canvas.ambientLight[1], vertexColor* Canvas.ambientLight[2], vertexColor* Canvas.ambientLight[3]);
		Ground.Floor[k]:Show();
		Ground.Floor[k]:SetFrameLevel(16);	
	end	

	Debugger.CreateGroundDebugger();
end

function round2(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-- "tileset/expansion05/spiresofarrak/6sa_rock01_1024.blp"
local halfFoV, dirPlusFoV, dirMinusFoV, verticalFoV, halfVerticalFoV, verticalAngleIncrement, oppositeAngle, newOppositeAngle, distanceFromOrigin;
local groundPosition = 0.6;
local distanceToProjectionPlane = 0.2;
local distModifier = distanceToProjectionPlane;
local x1, y1, x2, y2, x3, y3, x4, y4;

function Ground.UpdateFloor()
	--Ground.UpdateFloorSimple();
	Ground.UpdateFloorComplex();
end

function Ground.UpdateFloorSimple()
	halfFoV = Player.FoV/2;
	dirPlusFoV = Player.Direction + halfFoV;
	dirMinusFoV = Player.Direction - halfFoV;
	verticalFoV = (Canvas.resolution.y / Canvas.resolution.x) * Player.FoV;
	halfVerticalFoV = verticalFoV / 2;
	verticalAngleIncrement = halfVerticalFoV / Ground.groundVisLines;
	oppositeAngle = 90 - halfVerticalFoV;

	for k = 1, Ground.groundVisLines, 1 do	
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
		Ground.Floor[k].texture:SetTexCoord(x2,y2,x1,y1,x4,y4,x3,y3);

		--Debugger.GroundLog[Ground.groundVisLines - k + 1].text:SetText(round2(x2, 2).. " ".. round2(y2, 2));
	end
end

function Ground.UpdateFloorComplex()
	halfFoV = Player.FoV/2;
	dirPlusFoV = Player.Direction + halfFoV;
	dirMinusFoV = Player.Direction - halfFoV;
	verticalFoV = (Canvas.resolution.y / Canvas.resolution.x) * Player.FoV;
	halfVerticalFoV = verticalFoV / 2;
	verticalAngleIncrement = halfVerticalFoV / Ground.groundVisLines;
	oppositeAngle = 90 - halfVerticalFoV;

	for k = 1, Ground.groundVisLines, 1 do	
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
		Ground.Floor[k].texture:SetTexCoord(x2,y2,x1,y1,x4,y4,x3,y3);


		-- todo : add player position to all x and y so we calculate positive values in world space not relative to player
		local ray = Ray.CastGround(x2, y2, x4, y4);

		Debugger.GroundLog[Ground.groundVisLines - k + 1].text:SetText(ray.hitCount);
	end
end