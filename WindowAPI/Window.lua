-------------------------- Zee's Window API ---------------------------
-- Developed it for use in my addons, but feel free to use in yours ---
-----------------------------------------------------------------------

--Window--
Zee = Zee or {};
Zee.WindowAPI = Zee.WindowAPI or {};
local Win = Zee.WindowAPI;
Win.RESIZABLE_X = "RESIZABLE_X";
Win.RESIZABLE_Y = "RESIZABLE_Y";
Win.RESIZABLE_XY = "RESIZABLE_XY";
Win.RESIZABLE_NONE = "RESIZABLE_NONE";

function Win.CreateWindow(posX, posY, sizeX, sizeY, parent, windowPoint, parentPoint, resizable, title)

	-- properties --
	local TitleBarHeight = 20;
	local TitleBarFont = "Fonts\\FRIZQT__.TTF";
	local TitleBarFontSize = 12;

	-- defaults --
	if posX == nil then posX = 0; end
	if posY == nil then posY = 0; end
	if sizeX == nil or sizeX == 0 then sizeX = 50; end
	if sizeY == nil or sizeY == 0 then sizeY = 50; end	
	if parent == nil then parent = UIParent; end
	if windowPoint == nil then windowPoint = "CENTER"; end
	if parentPoint == nil then parentPoint = "CENTER"; end
	if resizable == nil then resizable = Win.RESIZABLE_NONE; end
	if title == nil then title = ""; end

	-- main window frame --
	local WindowFrame = CreateFrame("Frame", "Zee.WindowAPI.Window "..title, parent);
	WindowFrame:SetPoint(windowPoint, parent, parentPoint, posX, posY);
	WindowFrame:SetSize(sizeX, sizeY);
	WindowFrame.texture = WindowFrame:CreateTexture("Zee.WindowAPI.Window "..title.. " texture", "BACKGROUND");
	WindowFrame.texture:SetColorTexture(0.2,0.2,0.2,1);
	WindowFrame.texture:SetAllPoints(WindowFrame);
	WindowFrame:SetMovable(true);
	WindowFrame:EnableMouse(true);
    WindowFrame:SetFrameLevel(0);
    WindowFrame:SetFrameStrata("BACKGROUND");
	WindowFrame:SetUserPlaced(true);

	-- title bar frame --
	WindowFrame.TitleBar = CreateFrame("Frame", "Zee.WindowAPI.Window "..title.. " TitleBar", WindowFrame);
	WindowFrame.TitleBar:SetPoint("BOTTOM", WindowFrame, "TOP", 0, 0);
	WindowFrame.TitleBar:SetSize(sizeX, TitleBarHeight);
	WindowFrame.TitleBar.texture = WindowFrame.TitleBar:CreateTexture("Zee.WindowAPI.Window "..title.. " TitleBar texture", "BACKGROUND");
	WindowFrame.TitleBar.texture:SetColorTexture(0.5,0.5,0.5,1);
	WindowFrame.TitleBar.texture:SetAllPoints(WindowFrame.TitleBar);
	WindowFrame.TitleBar.text = WindowFrame.TitleBar:CreateFontString("Zee.WindowAPI.Window "..title.. " TitleBar text");
	WindowFrame.TitleBar.text:SetFont(TitleBarFont, TitleBarFontSize, "OUTLINE");
	WindowFrame.TitleBar.text:SetAllPoints(WindowFrame.TitleBar);
	WindowFrame.TitleBar.text:SetText(title);
	WindowFrame.TitleBar:EnableMouse(true);
	WindowFrame.TitleBar:RegisterForDrag("LeftButton");
	WindowFrame.TitleBar:SetScript("OnDragStart", function()  WindowFrame:StartMoving(); end);
	WindowFrame.TitleBar:SetScript("OnDragStop", function() WindowFrame:StopMovingOrSizing(); end);
    WindowFrame:SetFrameStrata("BACKGROUND");
    WindowFrame.TitleBar:SetFrameLevel(1);

	-- Close Button --
	WindowFrame.CloseButton = Win.CreateButton(-1, 0, TitleBarHeight - 1, TitleBarHeight - 1, WindowFrame.TitleBar, "TOPRIGHT", "TOPRIGHT", "X", nil, Win.BUTTON_DEFAULT)
	WindowFrame.CloseButton:SetScript("OnClick", function (self, button, down) WindowFrame:Hide(); end)
	return WindowFrame;

end