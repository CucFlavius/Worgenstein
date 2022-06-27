local Editor = Zee.Worgenstein.MapEditor;
local Map = Zee.Worgenstein.Map;
local Win = Zee.WindowAPI;
local Player = Zee.Worgenstein.Player;

Editor.config = {}
Editor.config.renderWidth = 500;
Editor.config.renderHeight = 500;
Editor.config.toolboxWidth = 200;
Editor.config.cellSize = 20;
Editor.config.playerIconSize = 7;

Editor.mapIconsTexturePath = "Interface\\AddOns\\Worgenstein\\GFX\\mapIcons.blp";

Editor.cells = {}

function Editor.Initialize()
    Editor.CreateMinimap();
    Editor.CreatePlayer();
    Editor.CreateToolbox();
end

function Editor.Update()
    Editor.UpdatePlayer();
    Editor.UpdateMinimap();
end

function Editor.CreateMinimap()
    Editor.cellCountX = floor(Editor.config.renderWidth / Editor.config.cellSize);
    Editor.cellCountY = floor(Editor.config.renderHeight / Editor.config.cellSize);
    Editor.Window = Win.CreateWindow(Editor.config.renderWidth / 2, 0, Editor.config.renderWidth + Editor.config.toolboxWidth, Editor.config.renderHeight, UIParent, "CENTER", "CENTER", false, "Zee.Worgenstein.MapEditor.Window");
    Editor.RenderBG = Win.CreateRectangle(0, 0, Editor.config.renderWidth, Editor.config.renderHeight, Editor.Window, "BOTTOMLEFT", "BOTTOMLEFT", 0, 0, 0, 1)
	Editor.RenderBG:SetClipsChildren(true);

    -- Create Cells
    local p = 1/17;
	for x = 0, Editor.cellCountX, 1 do
        Editor.cells[x] = {}
		for y = 0, Editor.cellCountY, 1 do
			Editor.cells[x][y] = Editor.CreateCell(x, y, Map.Data[x][y], Editor.RenderBG);
		end
	end
end

function Editor.GetIconUV(i)
	if i ~= nil then
		local yCoord = math.floor(i/17);
		local xCoord = i - (yCoord * 17);
		local coords = {x = xCoord, y = yCoord};
		return coords;
	else
		return {0,0};
	end
end

function Editor.CreateCell(X, Y, blockType, parent)
    local name = "MapEditor.Cell_" .. X .. "_" .. Y;
	local f = CreateFrame("Button", name, parent);
	f:SetPoint("BOTTOMLEFT", X * (Editor.config.cellSize + 1.01), Y * (Editor.config.cellSize + 1.01));
    f:SetSize(Editor.config.cellSize, Editor.config.cellSize);
	f:SetScript("OnClick", function (self, button, down) Editor.ClickCell(X, Y) end);
	f.texture = f:CreateTexture(name .. "_texture");
	f.texture:SetTexture(Editor.mapIconsTexturePath);
	f.texture:SetAllPoints(f);

    return f;
end

function Editor.ClickCell(x, y)
    local xCoord = ceil(Player.Position.x);
    local yCoord = ceil(Player.Position.y);
    local X = x + xCoord - ceil(Editor.cellCountX / 2);
    local Y = y + yCoord - ceil(Editor.cellCountX / 2);

	if Editor.selectedTab ~= nil then
		if Map.Data[X][Y] == Editor.selectedTab - 1 then
			Map.Data[X][Y] = 0;
		else
			Map.Data[X][Y] = Editor.selectedTab - 1;
		end

		WorgensteinMapData = Map.Data;
	end
end

function Editor.CreatePlayer()
    Editor.Player = {}

	-- Player Icon
	Editor.Player.IconFrame = CreateFrame("Frame",nil, Editor.RenderBG)
	Editor.Player.IconFrame:SetFrameStrata("MEDIUM")
	Editor.Player.IconFrame:SetSize(Editor.config.playerIconSize, Editor.config.playerIconSize)
	local t = Editor.Player.IconFrame:CreateTexture(nil,"BACKGROUND")
	t:SetColorTexture(1,1,1,1);
	Editor.Player.IconFrame.texture = t
	Editor.Player.IconFrame:SetPoint("BOTTOMLEFT", Editor.config.renderWidth / 2, Editor.config.renderHeight / 2);
	Editor.Player.IconFrame:SetFrameLevel(15);
	t:SetAllPoints(Editor.Player.IconFrame);
	Editor.Player.IconFrame:Show();

	-- Player HitPoint
	Editor.Player.HitPoint = CreateFrame("Frame", nil, Editor.RenderBG)
	Editor.Player.HitPoint:SetFrameStrata("MEDIUM")
	Editor.Player.HitPoint:SetSize(Editor.config.playerIconSize, Editor.config.playerIconSize)
	local tHitPoint = Editor.Player.HitPoint:CreateTexture(nil,"BACKGROUND")
	tHitPoint:SetColorTexture(1,1,1,1);
	Editor.Player.HitPoint.texture = tHitPoint
	Editor.Player.HitPoint:SetPoint("BOTTOMLEFT",0, 0);
	Editor.Player.HitPoint:SetFrameLevel(15);
	tHitPoint:SetAllPoints(Editor.Player.HitPoint);
	--Editor.Player.HitPoint:Hide();

	-- Player Direction
	Editor.Player.lineFrame = CreateFrame("Frame",nil,Editor.Player.IconFrame)
	Editor.Player.lineFrame:SetFrameStrata("MEDIUM")
	Editor.Player.lineFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Editor.Player.lineFrame:SetHeight(100) -- for your Texture
	Editor.Player.lineFrame:SetFrameLevel(15);
	Editor.Player.lineFrame:SetPoint("BOTTOMLEFT", Editor.Player.IconFrame, "CENTER",0, 0);
	Editor.Player.lineFrame.texture = Editor.Player.lineFrame:CreateTexture(nil, "BACKGROUND")
	Editor.Player.lineFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	--Editor.Player.lineFrame.texture:SetColorTexture(1,1,1,1);
	Editor.Player.lineFrame.texture:SetVertexColor(1,1,1,0.5);
	--Editor.Player.lineFrame.texture:SetAllPoints(Editor.Player.lineFrame);
	local mapDiagonal = (Map.size * Editor.config.cellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction) *100; --* mapDiagonal/4);
	local y2 = sin(Player.Direction) *100; --* (mapDiagonal/4);
	Editor.DrawLine(Editor.Player.lineFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	-- Player FoV Left
	Editor.Player.FoVLeftFrame = CreateFrame("Frame", nil, Editor.Player.IconFrame)
	Editor.Player.FoVLeftFrame:SetFrameStrata("MEDIUM")
	Editor.Player.FoVLeftFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Editor.Player.FoVLeftFrame:SetHeight(100) -- for your Texture
	Editor.Player.FoVLeftFrame:SetFrameLevel(15);
	Editor.Player.FoVLeftFrame:SetPoint("BOTTOMLEFT", Editor.Player.IconFrame, "CENTER",0, 0);
	Editor.Player.FoVLeftFrame.texture = Editor.Player.FoVLeftFrame:CreateTexture(nil, "BACKGROUND")
	Editor.Player.FoVLeftFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	Editor.Player.FoVLeftFrame.texture:SetVertexColor(1,1,1,0.3);
	local mapDiagonal = (Map.size * Editor.config.cellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction + Player.FoV / 2) * 100;
	local y2 = sin(Player.Direction + Player.FoV / 2) * 100;
	Editor.DrawLine(Editor.Player.FoVLeftFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	-- Player FoV Right
	Editor.Player.FoVRightFrame = CreateFrame("Frame", nil, Editor.Player.IconFrame)
	Editor.Player.FoVRightFrame:SetFrameStrata("MEDIUM")
	Editor.Player.FoVRightFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Editor.Player.FoVRightFrame:SetHeight(100) -- for your Texture
	Editor.Player.FoVRightFrame:SetFrameLevel(15);
	Editor.Player.FoVRightFrame:SetPoint("BOTTOMLEFT", Editor.Player.IconFrame, "CENTER",0, 0);
	Editor.Player.FoVRightFrame.texture = Editor.Player.FoVRightFrame:CreateTexture(nil, "BACKGROUND")
	Editor.Player.FoVRightFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	Editor.Player.FoVRightFrame.texture:SetVertexColor(1,1,1,0.3);
	local mapDiagonal = (Map.size * Editor.config.cellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction - Player.FoV / 2) * 100;
	local y2 = sin(Player.Direction - Player.FoV / 2) * 100;
	Editor.DrawLine(Editor.Player.FoVLeftFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	-- Enemy Line of Sight
	Editor.Player.EnemyLoSFrame = CreateFrame("Frame", nil, Editor.RenderBG)
	Editor.Player.EnemyLoSFrame:SetFrameStrata("MEDIUM")
	Editor.Player.EnemyLoSFrame:SetWidth(100) -- Set these to whatever height/width is needed 
	Editor.Player.EnemyLoSFrame:SetHeight(100) -- for your Texture
	Editor.Player.EnemyLoSFrame:SetFrameLevel(15);
	Editor.Player.EnemyLoSFrame:SetPoint("BOTTOMLEFT", Editor.RenderBG, "CENTER",0, 0);
	Editor.Player.EnemyLoSFrame.texture = Editor.Player.EnemyLoSFrame:CreateTexture(nil, "BACKGROUND")
	Editor.Player.EnemyLoSFrame.texture:SetTexture("Interface\\AddOns\\Worgenstein\\GFX\\line")
	Editor.Player.EnemyLoSFrame.texture:SetVertexColor(1,1,1,1);
	Editor.DrawLine(Editor.Player.EnemyLoSFrame, 0, 0, 1, 0, 20, {1,1,1,1}, "OVERLAY");

    Editor.playerFrameCreated = true;
end

function Editor.UpdatePlayer()
    if Editor.playerFrameCreated == false then return end;

	local mapDiagonal = (Map.size * Editor.config.cellSize) * math.sqrt(2);
	local x2 = cos(Player.Direction) * 100;
	local y2 = sin(Player.Direction) * 100;
	Editor.DrawLine(Editor.Player.lineFrame, 0, 0, x2, y2, 20, {1,1,1,1}, "OVERLAY");

	local x2FoVL = cos(Player.Direction + Player.FoV / 2) * 100;
	local y2FoVL = sin(Player.Direction + Player.FoV / 2) * 100;
	Editor.DrawLine(Editor.Player.FoVLeftFrame, 0, 0, x2FoVL, y2FoVL, 20, {1,1,1,1}, "OVERLAY");

	local x2FoVR = cos(Player.Direction - Player.FoV / 2) * 100;
	local y2FoVR = sin(Player.Direction - Player.FoV / 2) * 100;
	Editor.DrawLine(Editor.Player.FoVRightFrame, 0, 0, x2FoVR, y2FoVR, 20, {1,1,1,1}, "OVERLAY");

	--Editor.Player.IconFrame:SetPoint("BOTTOMLEFT",Editor.Player.Position.x * WG.MapEditor.minimapCellSize+ (WG.MapEditor.minimapCellSize/2), Editor.Player.Position.y * WG.MapEditor.minimapCellSize + (WG.MapEditor.minimapCellSize/2));
	--Editor.Player.IconFrame:SetPoint("BOTTOMLEFT", Player.Position.x * (WG.MapEditor.minimapCellSize+1)+ (WG.MapEditor.minimapCellSize/2) - iconSizeX/2, Editor.Player.Position.y * (WG.MapEditor.minimapCellSize+1) + (WG.MapEditor.minimapCellSize/2) - iconSizeY/2);
end

function Editor.UpdateMinimap()
    local xCoord = ceil(Player.Position.x);
    local yCoord = ceil(Player.Position.y);
    local xOffs = Player.Position.x - xCoord;
    local yOffs = Player.Position.y - yCoord;

    local X = 0;
    local Y = 0;
    local p = 1/17;
    for x = 0, Editor.cellCountX, 1 do
        X = (xCoord + x) - ceil(Editor.cellCountX / 2);
		for y = 0, Editor.cellCountY, 1 do
            Y = (yCoord + y) - ceil(Editor.cellCountY / 2);
			
            local coords = Editor.GetIconUV(Map.Data[X][Y]);
            if coords ~= nil and X >= 0 and Y >= 0 and X < Map.size and Y < Map.size then
			    Editor.cells[x][y].texture:SetTexCoord(p * (coords.x), p * (coords.x + 1), p * (coords.y), p * (coords.y + 1));
                Editor.cells[x][y]:SetPoint("BOTTOMLEFT",
                    Round((x - xOffs - 1) * (Editor.config.cellSize + 1.0)) + 0.01,
                    Round((y - yOffs - 1) * (Editor.config.cellSize + 1.0)) + 0.01
                );
                Editor.cells[x][y]:Show();
            else
                Editor.cells[x][y]:Hide();
            end
		end
	end
end

function Editor.DrawLine(C, sx, sy, ex, ey, w, color, layer)
	if C == nil then return end

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

function Editor.CreateToolbox()
    Editor.ToolboxFrame = Win.CreateRectangle(0, 0, Editor.config.toolboxWidth, Editor.config.renderHeight, Editor.Window, "TOPRIGHT", "TOPRIGHT", 0, 0, 0, 1)

	-- create toolbox block List
	local numberOfItems = table.getn(Map.DataTypeNames);
	Editor.BlockListScrollFrame = Win.CreateScrollList(0, 0, Editor.config.toolboxWidth, Editor.config.renderHeight - 40, Editor.ToolboxFrame, "TOPLEFT", "TOPLEFT");
	Editor.BlockListScrollFrame.pointTabs = {}
	Win.AdjustScrollList(Editor.BlockListScrollFrame, 22 * numberOfItems - 470);
	for s = 1, numberOfItems, 1 do
		Editor.BlockListScrollFrame.pointTabs[s] = Win.CreateRectangle(0, -20 * (s - 1) - (2 * s), Editor.config.toolboxWidth - 25, 20, Editor.BlockListScrollFrame.ContentFrame, "TOPLEFT", "TOPLEFT", .2, .2, .2, 1);

		local button = Win.CreateButton(0, 0, Editor.config.toolboxWidth - 50, 20, Editor.BlockListScrollFrame.pointTabs[s], "RIGHT", "RIGHT", Map.DataTypeNames[s], nil, nil);
		button:SetScript("OnClick", function (self, button, down) Editor.SelectTab(s) end);
		button.text:SetJustifyH("LEFT");
		--button.texture:SetColorTexture(.2,.2,.2,0);

		local icon = Win.CreateImageBox(0, 0, 20, 20, Editor.BlockListScrollFrame.pointTabs[s], "LEFT", "LEFT", "Interface\\AddOns\\Worgenstein\\GFX\\mapIcons.blp");
		local coords = Editor.GetIconUV(s - 1);
		local p = 1/17;
		icon.texture:SetTexCoord(p * (coords.x), p * (coords.x+1), p * (coords.y), p * (coords.y+1));

	end

	-- create tools
	Editor.Tool_Fill = Win.CreateButton(5, 5, 100, 40, Editor.ToolboxFrame, "BOTTOMLEFT", "BOTTOMLEFT", "Fill", nil, nil);
	Editor.Tool_Fill:SetScript("OnClick", function (self, button, down) Map.Fill() end);
	
end

function Editor.SelectTab(tab)
	if Editor.selectedTab ~= nil then
		Editor.BlockListScrollFrame.pointTabs[Editor.selectedTab].texture:SetColorTexture(.2,.2,.2,1)
	end
	Editor.selectedTab = tab;
	Editor.BlockListScrollFrame.pointTabs[tab].texture:SetColorTexture(1,1,.4,1)
end