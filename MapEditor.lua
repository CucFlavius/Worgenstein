Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
local WG = Zee.Worgenstein;
Zee.Worgenstein.Data = Zee.Worgenstein.Data or {};
local Data = Zee.Worgenstein.Data;
Zee.Worgenstein.Map = Zee.Worgenstein.Map or {};
local Map = Zee.Worgenstein.Map;
Zee.Worgenstein.MapEditor = Zee.Worgenstein.MapEditor or {}
local MapEditor = Zee.Worgenstein.MapEditor;
local Ray = Zee.Worgenstein.Raytracing;
Map.DataType = Map.DataType or {};
Map.Orientation = Map.Orientation or {};
local DataType = Map.DataType;
local Orientation = Map.Orientation;
local Player = WG.Player;
local DataTypeNames = Zee.Worgenstein.Map.DataTypeNames;
local Win = Zee.WindowAPI;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;

MapEditor.minimapCellSize = 10;
MapEditor.minimapBlocks = {};
MapEditor.selectedTab = nil;

function MapEditor.Initialize()
	MapEditor.CreateMinimap();
	MapEditor.CreateToolbox();
	MapEditor.DrawPlayer();
	MapEditor.UpdateMinimap();
end

local function ClickBlock(x,y)
	if MapEditor.selectedTab ~= nil then
		if Map.Data[x][y] == MapEditor.selectedTab - 1 then
			Map.Data[x][y] = 0;
		else
			Map.Data[x][y] = MapEditor.selectedTab - 1;
			--if Properties[Map.Data[x][y].blockType] ~= nil then
				--if Properties[Map.Data[x][y].blockType].door == true then
					--Map.Data[x][y].property = 1;
				--end
			--end
		end
		MapEditor.UpdateMinimap();
		WorgensteinMapData = Map.Data;
	end
end

function MapEditor.CreateMapBlock (blockX, blockY, blockType, parent)
	local f = CreateFrame("Button",nil,parent)
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(MapEditor.minimapCellSize) -- Set these to whatever height/width is needed 
	f:SetHeight(MapEditor.minimapCellSize) -- for your Texture
	local t = f:CreateTexture(nil,"BACKGROUND")
	t:SetAllPoints(f)
	f.texture = t
	f.x = blockX
	f.y = blockY;
	f.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\mapIcons.blp");
	f:SetFrameLevel(14);
	f:SetScript("OnClick", function (self, button, down) ClickBlock(f.x,f.y) end);
	f:SetPoint("BOTTOMLEFT",blockX*(MapEditor.minimapCellSize+1) + 5.01,blockY*(MapEditor.minimapCellSize+1) + 5.01)
	MapEditor.minimapBlocks[blockX.."-"..blockY] = f;
	f:Show();
end

function MapEditor.CreateMinimap ()
	MapEditor.minimapBlocks = {};
	-- create BACKGROUND
	local f = CreateFrame("Frame",nil,UIParent)
	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(Map.size * (MapEditor.minimapCellSize+1) + MapEditor.minimapCellSize +10) -- Set these to whatever height/width is needed 
	f:SetHeight(Map.size * (MapEditor.minimapCellSize+1) + MapEditor.minimapCellSize +10)-- for your Texture
	local t = f:CreateTexture(nil,"BACKGROUND")
	t:SetColorTexture(0,0,0,1);
	t:SetAllPoints(f)
	f.texture = t
	f:SetPoint("CENTER",250,0);
	f:Show();
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetUserPlaced(true);
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:SetFrameLevel(13);
	MapEditor.MinimapFrame = f;
	-- create blocks
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			MapEditor.CreateMapBlock (x, y, Map.Data[x][y], f);
		end
	end
end

local function SelectTab(tab)
	if MapEditor.selectedTab ~= nil then
		MapEditor.BlockListScrollFrame.pointTabs[MapEditor.selectedTab].texture:SetColorTexture(.2,.2,.2,1)
	end
	MapEditor.selectedTab = tab;
	MapEditor.BlockListScrollFrame.pointTabs[tab].texture:SetColorTexture(1,1,.4,1)
end

function MapEditor.CreateToolbox ()
	MapEditor.ToolboxFrame = CreateFrame("Frame",nil,MapEditor.MinimapFrame)
	MapEditor.ToolboxFrame:SetFrameStrata("BACKGROUND")
	MapEditor.ToolboxFrame:SetWidth(250); -- Set these to whatever height/width is needed 
	MapEditor.ToolboxFrame:SetHeight(720);-- for your Texture
	MapEditor.ToolboxFrame.texture = MapEditor.ToolboxFrame:CreateTexture(nil,"BACKGROUND")
	MapEditor.ToolboxFrame.texture:SetColorTexture(0.1,0.1,0.1,1);
	MapEditor.ToolboxFrame.texture:SetAllPoints(MapEditor.ToolboxFrame)
	MapEditor.ToolboxFrame:Show();
	MapEditor.ToolboxFrame:SetFrameLevel(10);
	MapEditor.ToolboxFrame:SetPoint("TOPLEFT", MapEditor.MinimapFrame,"TOPRIGHT", 0, 0);

	-- create toolbox block List
	local numberOfItems = table.getn(DataTypeNames);
	MapEditor.BlockListScrollFrame = Win.CreateScrollList(5, -5, 240, 480, MapEditor.ToolboxFrame, "TOPLEFT", "TOPLEFT");
	MapEditor.BlockListScrollFrame.pointTabs = {}
	Win.AdjustScrollList(MapEditor.BlockListScrollFrame, 22*numberOfItems - 470);
	for s = 1, numberOfItems, 1 do
		
		MapEditor.BlockListScrollFrame.pointTabs[s] = Win.CreateRectangle(0, -20*(s-1) - (2*s), 215, 20, MapEditor.BlockListScrollFrame.ContentFrame, "TOPLEFT", "TOPLEFT", .2, .2, .2, 1);
		
		local button = Win.CreateButton(0, 0, 180, 20, MapEditor.BlockListScrollFrame.pointTabs[s], "RIGHT", "RIGHT", DataTypeNames[s], nil, nil);
		button:SetScript("OnClick", function (self, button, down) SelectTab(s) end);
		button.text:SetJustifyH("LEFT");
		--button.texture:SetColorTexture(.2,.2,.2,0);

		local icon = Win.CreateImageBox(0, 0, 20, 20, MapEditor.BlockListScrollFrame.pointTabs[s], "LEFT", "LEFT", "Interface\\AddOns\\Worgenstein\\GFX\\mapIcons.blp");
		local coords = MapEditor.GetIconCoords(s-1);
		local p = 1/17;
		icon.texture:SetTexCoord(p * (coords.x), p * (coords.x+1), p * (coords.y), p * (coords.y+1));

	end

	-- create tools
	MapEditor.Tool_Fill = Win.CreateButton(5, 5, 100, 40, MapEditor.ToolboxFrame, "BOTTOMLEFT", "BOTTOMLEFT", "Fill", nil, nil);
	MapEditor.Tool_Fill:SetScript("OnClick", function (self, button, down) Map.Fill() end);
	
end

function MapEditor.GetIconCoords(i)
	if i ~= nil then
		local yCoord = math.floor(i/17);
		local xCoord = i - (yCoord * 17);
		local coords = {x = xCoord, y = yCoord};
		return coords;
	else
		return {0,0};
	end
end

function MapEditor.UpdateMinimap()
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			local coords = MapEditor.GetIconCoords(Map.Data[x][y]);
			local p = 1/17;
			MapEditor.minimapBlocks[x.."-"..y].texture:SetTexCoord(p * (coords.x), p * (coords.x+1), p * (coords.y), p * (coords.y+1));
		end
	end
end

	local iconSizeX = 7;
	local iconSizeY = 7;

function MapEditor.DrawPlayer()


	-- Player Icon
	Player.IconFrame = CreateFrame("Frame",nil,WG.MapEditor.MinimapFrame)
	Player.IconFrame:SetFrameStrata("BACKGROUND")
	Player.IconFrame:SetWidth(iconSizeX) -- Set these to whatever height/width is needed 
	Player.IconFrame:SetHeight(iconSizeY) -- for your Texture
	local t = Player.IconFrame:CreateTexture(nil,"BACKGROUND")
	t:SetColorTexture(1,1,1,1);
	Player.IconFrame.texture = t
	Player.IconFrame:SetPoint("BOTTOMLEFT",Player.Position.x * (WG.MapEditor.minimapCellSize+1)+ (WG.MapEditor.minimapCellSize/2) + 5.01, Player.Position.y * (WG.MapEditor.minimapCellSize+1) + (WG.MapEditor.minimapCellSize/2)+ 5.01);
	Player.IconFrame:SetFrameLevel(15);
	t:SetAllPoints(Player.IconFrame);
	Player.IconFrame:Show();

	-- Player HitPoint
	Player.HitPoint = CreateFrame("Frame",nil,WG.MapEditor.MinimapFrame)
	Player.HitPoint:SetFrameStrata("BACKGROUND")
	Player.HitPoint:SetWidth(iconSizeX) -- Set these to whatever height/width is needed 
	Player.HitPoint:SetHeight(iconSizeY) -- for your Texture
	local tHitPoint = Player.HitPoint:CreateTexture(nil,"BACKGROUND")
	tHitPoint:SetColorTexture(1,1,1,1);
	Player.HitPoint.texture = tHitPoint
	Player.HitPoint:SetPoint("BOTTOMLEFT",0, 0);
	Player.HitPoint:SetFrameLevel(15);
	tHitPoint:SetAllPoints(Player.HitPoint);
	--Player.HitPoint:Hide();

	-- Player Direction
	Player.lineFrame = CreateFrame("Frame",nil,Player.IconFrame)
	Player.lineFrame:SetFrameStrata("BACKGROUND")
	Player.lineFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Player.lineFrame:SetHeight(100) -- for your Texture
	Player.lineFrame:SetFrameLevel(15);
	Player.lineFrame:SetPoint("BOTTOMLEFT", Player.IconFrame, "CENTER",0, 0);
	Player.lineFrame.texture = Player.lineFrame:CreateTexture(nil, "BACKGROUND")
	Player.lineFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	--Player.lineFrame.texture:SetColorTexture(1,1,1,1);
	Player.lineFrame.texture:SetVertexColor(1,1,1,0.5);
	--Player.lineFrame.texture:SetAllPoints(Player.lineFrame);
	local mapDiagonal = (Map.size * MapEditor.minimapCellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction) *100; --* mapDiagonal/4);
	local y2 = sin(Player.Direction) *100; --* (mapDiagonal/4);
	Zee.DrawLine(Player.lineFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	-- Player FoV Left
	Player.FoVLeftFrame = CreateFrame("Frame",nil,Player.IconFrame)
	Player.FoVLeftFrame:SetFrameStrata("BACKGROUND")
	Player.FoVLeftFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Player.FoVLeftFrame:SetHeight(100) -- for your Texture
	Player.FoVLeftFrame:SetFrameLevel(15);
	Player.FoVLeftFrame:SetPoint("BOTTOMLEFT", Player.IconFrame, "CENTER",0, 0);
	Player.FoVLeftFrame.texture = Player.FoVLeftFrame:CreateTexture(nil, "BACKGROUND")
	Player.FoVLeftFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	Player.FoVLeftFrame.texture:SetVertexColor(1,1,1,0.3);
	local mapDiagonal = (Map.size * MapEditor.minimapCellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction + Player.FoV/2) *100;
	local y2 = sin(Player.Direction + Player.FoV/2) *100;
	Zee.DrawLine(Player.FoVLeftFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	-- Player FoV Right
	Player.FoVRightFrame = CreateFrame("Frame",nil,Player.IconFrame)
	Player.FoVRightFrame:SetFrameStrata("BACKGROUND")
	Player.FoVRightFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Player.FoVRightFrame:SetHeight(100) -- for your Texture
	Player.FoVRightFrame:SetFrameLevel(15);
	Player.FoVRightFrame:SetPoint("BOTTOMLEFT", Player.IconFrame, "CENTER",0, 0);
	Player.FoVRightFrame.texture = Player.FoVRightFrame:CreateTexture(nil, "BACKGROUND")
	Player.FoVRightFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	Player.FoVRightFrame.texture:SetVertexColor(1,1,1,0.3);
	local mapDiagonal = (Map.size * MapEditor.minimapCellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction - Player.FoV/2) *100;
	local y2 = sin(Player.Direction - Player.FoV/2) *100;
	Zee.DrawLine(Player.FoVLeftFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	-- Enemy Line of Sight
	Player.EnemyLoSFrame = CreateFrame("Frame",nil,WG.MapEditor.MinimapFrame)
	Player.EnemyLoSFrame:SetFrameStrata("BACKGROUND")
	Player.EnemyLoSFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Player.EnemyLoSFrame:SetHeight(100) -- for your Texture
	Player.EnemyLoSFrame:SetFrameLevel(15);
	Player.EnemyLoSFrame:SetPoint("BOTTOMLEFT", WG.MapEditor.MinimapFrame, "CENTER",0, 0);
	Player.EnemyLoSFrame.texture = Player.EnemyLoSFrame:CreateTexture(nil, "BACKGROUND")
	Player.EnemyLoSFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	Player.EnemyLoSFrame.texture:SetVertexColor(1,1,1,1);
	Zee.DrawLine(Player.EnemyLoSFrame, 0, 0, 1, 0, 20, {1,1,1,1}, "OVERLAY");
end

function MapEditor.UpdatePlayer()
	local mapDiagonal = (Map.size * MapEditor.minimapCellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction) * 100;
	local y2 = sin(Player.Direction) * 100;
	Zee.DrawLine(Player.lineFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	local x2FoVL = cos(Player.Direction + Player.FoV/2) * 100;
	local y2FoVL = sin(Player.Direction + Player.FoV/2) * 100;
	Zee.DrawLine(Player.FoVLeftFrame, 0, 0, x2FoVL, y2FoVL, 20, {1,1,1,1}, "OVERLAY");

	local x2FoVR = cos(Player.Direction- Player.FoV/2) * 100;
	local y2FoVR = sin(Player.Direction- Player.FoV/2) * 100;
	Zee.DrawLine(Player.FoVRightFrame, 0, 0, x2FoVR, y2FoVR, 20, {1,1,1,1}, "OVERLAY");

	--Player.IconFrame:SetPoint("BOTTOMLEFT",Player.Position.x * WG.MapEditor.minimapCellSize+ (WG.MapEditor.minimapCellSize/2), Player.Position.y * WG.MapEditor.minimapCellSize + (WG.MapEditor.minimapCellSize/2));
	Player.IconFrame:SetPoint("BOTTOMLEFT",Player.Position.x * (WG.MapEditor.minimapCellSize+1)+ (WG.MapEditor.minimapCellSize/2) - iconSizeX/2, Player.Position.y * (WG.MapEditor.minimapCellSize+1) + (WG.MapEditor.minimapCellSize/2) - iconSizeY/2);
end

function Zee.DrawLine(C, sx, sy, ex, ey, w, color, layer)
	
	local TAXIROUTE_LINEFACTOR = 128/126; -- Multiplying factor for texture coordinates
	local TAXIROUTE_LINEFACTOR_2 = TAXIROUTE_LINEFACTOR / 2; -- Half of that
	local relPoint = "BOTTOMLEFT"

	-- Determine dimensions and center point of line
	local dx,dy = ex - sx, ey - sy;
	local cx,cy = (sx + ex) / 2, (sy + ey) / 2;

	-- Normalize direction if necessary
	if (dx < 0) then
		dx,dy = -dx,-dy;
	end

	-- Calculate actual length of line
	local l = sqrt((dx * dx) + (dy * dy));

	-- Sin and Cosine of rotation, and combination (for later)
	local s,c = -dy / l, dx / l;
	local sc = s * c;

	-- Calculate bounding box size and texture coordinates
	local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy;
	if (dy >= 0) then
		Bwid = ((l * c) - (w * s)) * TAXIROUTE_LINEFACTOR_2;
		Bhgt = ((w * c) - (l * s)) * TAXIROUTE_LINEFACTOR_2;
		BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc;
		BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx; 
		TRy = BRx;
	else
		Bwid = ((l * c) + (w * s)) * TAXIROUTE_LINEFACTOR_2;
		Bhgt = ((w * c) + (l * s)) * TAXIROUTE_LINEFACTOR_2;
		BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc;
		BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy;
		TRx = TLy;
	end

	-- Thanks Blizzard for adding (-)10000 as a hard-cap and throwing errors!
	-- The cap was added in 3.1.0 and I think it was upped in 3.1.1
	--  (way less chance to get the error)
	if TLx > 10000 then TLx = 10000 elseif TLx < -10000 then TLx = -10000 end
	if TLy > 10000 then TLy = 10000 elseif TLy < -10000 then TLy = -10000 end
	if BLx > 10000 then BLx = 10000 elseif BLx < -10000 then BLx = -10000 end
	if BLy > 10000 then BLy = 10000 elseif BLy < -10000 then BLy = -10000 end
	if TRx > 10000 then TRx = 10000 elseif TRx < -10000 then TRx = -10000 end
	if TRy > 10000 then TRy = 10000 elseif TRy < -10000 then TRy = -10000 end
	if BRx > 10000 then BRx = 10000 elseif BRx < -10000 then BRx = -10000 end
	if BRy > 10000 then BRy = 10000 elseif BRy < -10000 then BRy = -10000 end

	-- Set texture coordinates and anchors
	C.texture:ClearAllPoints();
	C.texture:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy);
	C.texture:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt);
	C.texture:SetPoint("TOPRIGHT",   C, relPoint, cx + Bwid, cy + Bhgt);

	C:Show()
	--return T
end