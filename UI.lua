local UI = Zee.Worgenstein.UI;
local Win = Zee.WindowAPI;

UI.config = {};
UI.config.scale = 1.3;
UI.config.hudHeight = 100;

function UI.Initialize(width, height)
    UI.config.width = width;
    UI.config.height = height;
    Zee.Worgenstein.MapEditor.CreateWindow();
    UI.GameWindow = Win.CreateWindow(0, 0, UI.config.width, UI.config.height + UI.config.hudHeight, UIParent, "CENTER", "CENTER", false, "Zee.Worgenstein.UI.GameWindow");
    UI.GameWindow:SetScale(UI.config.scale);

	-- create HUD frame
    UI.HUDFrame = Win.CreateRectangle(0, 0, UI.config.width, UI.config.hudHeight, Zee.Worgenstein.UI.GameWindow, "BOTTOMLEFT", "BOTTOMLEFT", 0, 0, 0, 1);
	UI.HUDFrame:SetFrameStrata("MEDIUM");
	UI.HUDFrame:SetFrameLevel(100);
	--Canvas.HUDFrame:SetClipsChildren(true);
end