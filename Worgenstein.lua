--------------------------------------------------------------------------------------
--	Main Lua																		--
--------------------------------------------------------------------------------------
local WG = Zee.Worgenstein;
local Map = Zee.Worgenstein.Map;
local Player = Zee.Worgenstein.Player;
local Ray = Zee.Worgenstein.Raycasting;
local Canvas = Zee.Worgenstein.Canvas;
local Weapon = Zee.Worgenstein.Weapon;
local DataType = Map.DataType;
local Settings = Zee.Worgenstein.Settings;
local MapEditor = Zee.Worgenstein.MapEditor;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local Sprites = Zee.Worgenstein.Sprites;
local Weapon = Zee.Worgenstein.Weapon;
local AI = Zee.Worgenstein.AI;
local UI = Zee.Worgenstein.UI;
Zee.Worgenstein.Loaded = false;
Zee.Worgenstein.timeSinceLastUpdate = 0;
------------------------------
--	Start					--
------------------------------
function WG.PlayerLogin()
	
end

UI.Initialize(640, 480);    -- creating UI at the start (before PlayerLogin) so that the window:SetUserPlaced() works as intended

function WG.VariablesLoaded()
    WorgensteinMapData = WorgensteinMapData or {};
	Map.GenerateEmpty();
	Map.LoadData();
	Map.FillMissingData();
	Map.LoadDoors();
    
	Canvas.Initialize(640, 480);
	Sprites.CreateSpriteFrames();
	Ray.Cast(0, Player.Position.x, Player.Position.y, Player.Direction, Map.size * math.sqrt(2));
	Ray.MinimapHighlightBoxesHit();
    MapEditor.Initialize();
	Player.Spawn();
	Canvas.Render();
	Weapon.CreateGunFrame();
	AI.Initialize();
	Zee.Worgenstein.Loaded = true;
end

function WG.AddonLoaded()
    
end

function DegreeToRadian(angle)
   return (math.pi * angle / 180.0);
end

------------------------------
--	Events					--
------------------------------

local f = CreateFrame("Frame");
local function onevent(self, event,... )
    if(event == "PLAYER_LOGIN") then
		WG.PlayerLogin();
        f:UnregisterEvent("PLAYER_LOGIN");
    end
    if(event == "VARIABLES_LOADED") then
		WG.VariablesLoaded();
        f:UnregisterEvent("VARIABLES_LOADED");
    end
    if event == "ADDON_LOADED" and ... == "Worgenstein" then
		WG.AddonLoaded();
        f:UnregisterEvent("ADDON_LOADED");
	end   	
end
f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("VARIABLES_LOADED");
f:SetScript("OnEvent", onevent);


------------------------
-------- UPDATE --------
------------------------


function WG.UpdateLoop ()
	Player.Movement();
	Weapon.Update();
	MapEditor.Update();
	Canvas.Render();
	Sprites.Update();
	--Canvas.DistanceCulling();
	AI.Update();
end

function WG.Slide(xDestination, yDestination)
	local previousX = Player.Position.x;
	local previousY = Player.Position.y;

	local right = WG.CheckCollision(Player.Position.x + 1, Player.Position.y);
	local left = WG.CheckCollision(Player.Position.x - 1, Player.Position.y);
	local up = WG.CheckCollision(Player.Position.x, Player.Position.y + 1);
	local down = WG.CheckCollision(Player.Position.x, Player.Position.y - 1)

	if right == true or left == true then
		if up == false and down == false then
			Player.Position.y = yDestination;
			Player.Position.x = previousX;
		end
	elseif up == true or down == true then
		if right == false and left == false then
			Player.Position.x = xDestination;
			Player.Position.y = previousY;
		end
	end

	if WG.CheckCollision(Player.Position.x,Player.Position.y) == true then
		Player.Position.x = previousX;
		Player.Position.y = previousY;
	end
end


function WG.CheckCollision(x,y)
	local offsetX = 0.2;
	local offsetY = 0.2;
	if x < Player.Position.x then offsetX = -offsetX; end
	if y < Player.Position.y then offsetY = -offsetY; end

	-- enemies
	for e = 1, AI.totalAliveEnemies, 1 do
		local sprite = Sprites.spriteList[AI.AliveEnemySprites[e]];
		if floor(x) == sprite.x and floor(y) == sprite.y then
			return true;
		end
	end

    local dataX = math.floor(x + offsetX);
    local dataY = math.floor(y + offsetY);

    -- map bounds force collision, exiting the map causes weird rendering
    if dataX < 0 or dataY < 0 or dataX >= Map.size or dataY >= Map.size then
        return true;
    end


	-- walls
	if Properties[Map.Data[dataX][dataY]].wall == true then
		return true;
	end

	-- doors
	--if Properties[Map.Data[math.floor(x+offsetX)][math.floor(y+offsetY)].blockType].door == true and Map.Data[math.floor(x+offsetX)][math.floor(y+offsetY)].property > 0.2 then
	if Properties[Map.Data[dataX][dataY]].door == true and Map.Doors[dataX][dataY] > 0.2 then
		return true;
	end
	return false;
end

function WG.OnUpdate(self, elapsed)
	WG.timeSinceLastUpdate = WG.timeSinceLastUpdate + elapsed; 	
	while (WG.timeSinceLastUpdate > Settings.UPDATE_INTERVAL) do
		if Settings.RunUpdateLoop == true then
			WG.UpdateLoop();
		end
		WG.timeSinceLastUpdate = WG.timeSinceLastUpdate - Settings.UPDATE_INTERVAL;
	end
end

WG.UpdateFrame = CreateFrame("frame")
WG.UpdateFrame:SetScript("OnUpdate", WG.OnUpdate)