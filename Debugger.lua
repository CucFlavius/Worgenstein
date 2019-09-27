--------------------------------------------------
-- Worgenstein Debugger							--
--------------------------------------------------


Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
Zee.Worgenstein.Debugger = Zee.Worgenstein.Debugger or {}
local Debugger = Zee.Worgenstein.Debugger;
local Win = Zee.WindowAPI;


Debugger.Window = Win.CreateWindow(0, 400, 900, 50, UIParent, "CENTER", "CENTER", false, "Zee.Worgenstein.Debugger.Window");
Debugger.Log = Win.CreateTextBox(5, -5, 800, 20, Debugger.Window , "TOPLEFT", "TOPLEFT", "Debugger", nil, nil);