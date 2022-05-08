--------------------------------------------------------------------------------------
--	Settings Lua																		--
--------------------------------------------------------------------------------------

Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
Zee.Worgenstein.Settings = Zee.Worgenstein.Settings or {};
local WG = Zee.Worgenstein;
local Settings = Zee.Worgenstein.Settings;
Settings = Settings or {}

Settings.UPDATE_INTERVAL = 0.02; -- never set below 0.02
Zee.Worgenstein.Settings.RunUpdateLoop = true;
Settings.canvasWalkStrength = 10;
Settings.DoorOpenDistance = 2;
Settings.DoorOpenSpeed = 0.05;
Settings.SpriteDrawDistance = 20;
Settings.EnemyTurnSpeed = 2;
Settings.MaxSprites = 20;
Settings.DEBUG_Sprites = false;