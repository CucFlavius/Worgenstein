--------------------------------------------------
-- Worgenstein Debugger							--
--------------------------------------------------
local Debugger = Zee.Worgenstein.Debugger;
local Win = Zee.WindowAPI;


Debugger.Window = Win.CreateWindow(400, 400, 800, 50, UIParent, "CENTER", "CENTER", false, "Zee.Worgenstein.Debugger.Window");
Debugger.Log = Win.CreateTextBox(5, -5, 800, 20, Debugger.Window , "TOPLEFT", "TOPLEFT", "Debugger", nil, nil);

-- Hide unnecesary game UI for debugging --

-- Chat Frame
local z_wgs_debug_chat = DEFAULT_CHAT_FRAME
z_wgs_debug_chat:SetScript("OnShow", z_wgs_debug_chat.Hide)
z_wgs_debug_chat:Hide()
local z_wgs_debug_dock = GeneralDockManager
z_wgs_debug_dock:SetScript("OnShow", z_wgs_debug_dock.Hide)
z_wgs_debug_dock:Hide()
local z_wgs_debug_cfmb = ChatFrameMenuButton
z_wgs_debug_cfmb:SetScript("OnShow", z_wgs_debug_cfmb.Hide)
z_wgs_debug_cfmb:Hide()
local z_wgs_debug_cfcb = ChatFrameChannelButton
z_wgs_debug_cfcb:SetScript("OnShow", z_wgs_debug_cfcb.Hide)
z_wgs_debug_cfcb:Hide()
local z_wgs_debug_qjtb = QuickJoinToastButton
z_wgs_debug_qjtb:SetScript("OnShow", z_wgs_debug_qjtb.Hide)
z_wgs_debug_qjtb:Hide()

-- Spell Bar
local z_wgs_debug_mmb = MainMenuBar
z_wgs_debug_mmb:SetScript("OnShow", z_wgs_debug_mmb.Hide)
z_wgs_debug_mmb:Hide()

-- Player Frame
local z_wgs_debug_pf = PlayerFrame
z_wgs_debug_pf:SetScript("OnShow", z_wgs_debug_pf.Hide)
z_wgs_debug_pf:Hide()

-- Quests Tracker
local z_wgs_debug_otf = ObjectiveTrackerFrame
z_wgs_debug_otf:SetScript("OnShow", z_wgs_debug_otf.Hide)
z_wgs_debug_otf:Hide()