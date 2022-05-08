local Ground = Zee.Worgenstein.Ground;
local Canvas = Zee.Worgenstein.Canvas;
local Textures = Zee.Worgenstein.Textures;
local Player = Zee.Worgenstein.Player;

Ground.groundVisLines = 50;
Ground.renderDensityGround = 8;
Ground.currentFloor = nil;

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
end

local halfFoV, dirPlusFoV, dirMinusFoV, verticalFoV, halfVerticalFoV, verticalAngleIncrement, oppositeAngle, newOppositeAngle, distanceFromOrigin;
local groundPosition = 0.6;
local distanceToProjectionPlane = 0.2;
local distModifier = distanceToProjectionPlane;
local x1, y1, x2, y2, x3, y3, x4, y4;
function Ground.UpdateFloor()
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
	end
end