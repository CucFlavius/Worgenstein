Zee.Worgenstein.Map.DataTypeProperties = Zee.Worgenstein.Map.DataTypeProperties or {};
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local DataType = Zee.Worgenstein.Map.DataType;
Properties.SecondLayerType = {};
local SecondLayerType = Zee.Worgenstein.Map.DataTypeProperties.SecondLayerType;
Zee.Worgenstein.Textures = {};
local Textures = Zee.Worgenstein.Textures;
Properties.Direction = {};
local Direction = Properties.Direction;


SecondLayerType.Off = 0;
SecondLayerType.Indented = 1;
SecondLayerType.OneLevelAbove = 2;

Direction.Vertical = 0;
Direction.Horizontal = 1;

Textures.Tileset1 = "Interface\\AddOns\\Worgenstein\\GFX\\Tileset1.blp";
Textures.Ground1 = "Interface\\AddOns\\Worgenstein\\GFX\\Ground1.blp";

--tileset/7.0/araknashal/data/7an_vrykulbones01_256.blp

-- Wood
-- dungeons/textures/6hu_garrison/6hu_garrison_stucco_long.blp
-- dungeons/textures/6hu_garrison/6hu_garrison_stucco_long_indoors_cracks.blp
-- dungeons/textures/6hu_garrison/6hu_garrison_westfall_wall_wood_2.blp

-- stone walls
-- dungeons/textures/6hu_garrison/lt_strmwnd_wall_05_tower.blp
-- dungeons/textures/6hu_garrison/lt_strmwnd_wall_05_tower_wall.blp


Properties[DataType.Nothing] = { wall = false }


---------------
---- Walls ----
---------------

Properties[DataType.DefaultWall] = 
{
wall = true
}

Properties[DataType.MansionExt_1A] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.5, 0.625},
coords_side = {0, 0.125, 0.5, 0.625},
layer2 = SecondLayerType.OneLevelAbove,
layer2_texture = Textures.Tileset1,
uv2_direction = 1,
coords2 = {0, 0.125, 0, 0.5},
coords2_side = {0, 0.125, 0.125, 0.5},
layer2_height = 4,
layer2_height_side = 3
}

Properties[DataType.MansionExt_1B] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.5, 0.625},
coords_side = {0, 0.125, 0.5, 0.625},
layer2 = SecondLayerType.OneLevelAbove,
layer2_texture = Textures.Tileset1,
uv2_direction = -1,
coords2 = {0.125, 0.25, 0, 0.5},
coords2_side = {0, 0.125, 0.125, 0.5},
layer2_height = 4,
layer2_height_side = 3
}

Properties[DataType.MansionExt_1C] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.5, 0.625},
coords_side = {0, 0.125, 0.5, 0.625},
layer2 = SecondLayerType.OneLevelAbove,
layer2_texture = Textures.Tileset1,
uv2_direction = 1,
coords2 = {0.125, 0.25, 0, 0.5},
coords2_side = {0.125, 0.25, 0.125, 0.5},
layer2_height = 4,
layer2_height_side = 3
}

Properties[DataType.MansionExt_1D] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.5, 0.625},
coords_side = {0, 0.125, 0.5, 0.625},
layer2 = SecondLayerType.OneLevelAbove,
layer2_texture = Textures.Tileset1,
uv2_direction = -1,
coords2 = {0.25, 0.375, 0, 0.5},
coords2_side = {0.25, 0.375, 0.125, 0.5},
layer2_height = 4,
layer2_height_side = 3
}

Properties[DataType.MansionExt_2A] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.5, 0.625},
coords_side = {0, 0.125, 0.5, 0.625},
layer2 = SecondLayerType.OneLevelAbove,
layer2_texture = Textures.Tileset1,
uv2_direction = 1,
coords2 = {0.25, 0.375, 0, 0.5},
coords2_side = {0.25, 0.375, 0.125, 0.5},
layer2_height = 4,
layer2_height_side = 3
}

Properties[DataType.MansionExt_2B] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.5, 0.625},
coords_side = {0, 0.125, 0.5, 0.625},
layer2 = SecondLayerType.OneLevelAbove,
layer2_texture = Textures.Tileset1,
uv2_direction = -1,
coords2 = {0.375, 0.5, 0, 0.5},
coords2_side = {0.375, 0.5, 0.125, 0.5},
layer2_height = 4,
layer2_height_side = 3
}

Properties[DataType.MansionExt_2C] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0.375, 0.5, 0.5, 0.625},
coords_side = {0.375, 0.5, 0.5, 0.625},
layer2 = SecondLayerType.OneLevelAbove,
layer2_texture = Textures.Tileset1,
uv2_direction = 1,
coords2 = {0.375, 0.5, 0, 0.5},
coords2_side = {0.375, 0.5, 0.125, 0.5},
layer2_height = 4,
layer2_height_side = 3
}

Properties[DataType.Fence_1Vertical] = 
{	
wall = true,
--flat = Direction.Vertical,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.625, 0.75},
coords_side = {0, 0.125, 0.625, 0.75},
--passthrough = true
}

Properties[DataType.Fence_1Horizontal] = 
{	
wall = true,
--flat = Direction.Horizontal,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0, 0.125, 0.625, 0.75},
coords_side = {0, 0.125, 0.625, 0.75},
--passthrough = true
}

Properties[DataType.WallExt_1] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0.5, 0.625, 0.5, 0.625},
coords_side = {0.5, 0.625, 0.5, 0.625},
}

Properties[DataType.WallExt_2] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0.625, 0.75, 0.5, 0.625},
coords_side = {0.625, 0.75, 0.5, 0.625},
}

Properties[DataType.WallExt_3] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0.75, 0.875, 0.5, 0.625},
coords_side = {0.75, 0.875, 0.5, 0.625},
}

Properties[DataType.Hedge1] = 
{	
wall = true,
texture = Textures.Tileset1,
uv_direction = 1,
coords = {0.125, 0.25, 0.625, 0.75},
coords_side = {0.125, 0.25, 0.625, 0.75},
}

Properties[DataType.Wood] = { wall = true, texture = 953619 }
Properties[DataType.Wood_Eagle] = {	wall = true, texture = 953628 }
Properties[DataType.Wood_Worgenstein] = { wall = true, texture = 953619 }
Properties[DataType.Wood_IronCross] = { wall = true, texture = 953619 }

--[[
DataType.EntranceToLevel = 19;
DataType.Steel = 20;
DataType.Steel_Sign = 21;
DataType.Landscape = 22;
DataType.RedBrick = 23;
DataType.RedBrick_WorgenSymbol = 24;
DataType.RedBrick_Flag = 25;
DataType.MulticolorBrick = 26;
DataType.Purple = 27;
DataType.Purple_Blood = 28;
DataType.BrownWeave = 29;
DataType.BrownWeave_Blood1 = 30;
DataType.BrownWeave_Blood2 = 31;
DataType.BrownWeave_Blood3 = 32;
DataType.StainedGlass = 33;
DataType.GreyWall1 = 34;
DataType.GreyWall2 = 35;
DataType.GreyWall_Worgenstein = 36;
DataType.GreyWall_Map = 37;
DataType.GreyWall_Vent = 38;
DataType.BlueWall = 39;
DataType.BlueWall_WorgenSymbol = 40;
DataType.BlueWall_Skull = 41;
DataType.BrownStone1 = 42;
DataType.BrownStone2 = 43;
DataType.BrownMarble1 = 44;
DataType.BrownMarble2 = 45;
DataType.BrownMarble_Flag = 46;
DataType.WoorPanel = 47;
DataType.FakeDoor = 48;
DataType.DoorExcavation = 49; -- side of door
DataType.FakeLockedDoor = 50;
DataType.ElevatorWall = 51;
DataType.Elevator = 52;
DataType.FakeElevator = 53;
--]]

Properties[DataType.DoorVertical] = { door = true, texture = 980112 }
Properties[DataType.DoorHorizontal] = {	door = true, texture = 980112 }

--[[
DataType.DoorVerticalGoldKey = 56;
DataType.DoorHorizontalGoldKey = 57;
DataType.DoorVerticalSilverKey = 58;
DataType.DoorHorizontalSilverKey = 59;
DataType.ElevatorDoorNormal = 60;
DataType.ElevatorDoorHorizontal = 61;
DataType.FloorDeafGuard = 62;
DataType.ElevatorToSecretFloor = 63;
-]]

----------------
---- Floors ----
----------------
Properties[DataType.Floor6C] = { floor = true, color = {.3,.3,.3,1} }
Properties[DataType.Floor6D] = { floor = true, color = {.3,.3,.3,1} }
Properties[DataType.Floor6E] = { floor = true }
Properties[DataType.Floor6F] = { floor = true }
Properties[DataType.Floor70] = { floor = true }
Properties[DataType.Floor71] = { floor = true }
Properties[DataType.Floor72] = { floor = true }
Properties[DataType.Floor73] = { floor = true }
Properties[DataType.Floor74] = { floor = true }
Properties[DataType.Floor75] = { floor = true }
Properties[DataType.Floor76] = { floor = true }
Properties[DataType.Floor77] = { floor = true }
Properties[DataType.Floor78] = { floor = true }
Properties[DataType.Floor79] = { floor = true }
Properties[DataType.Floor7A] = { floor = true }
Properties[DataType.Floor7B] = { floor = true }
Properties[DataType.Floor7C] = { floor = true }
Properties[DataType.Floor7D] = { floor = true }
Properties[DataType.Floor7E] = { floor = true }
Properties[DataType.Floor7F] = { floor = true }
Properties[DataType.Floor80] = { floor = true }
Properties[DataType.Floor81] = { floor = true }
Properties[DataType.Floor82] = { floor = true }
Properties[DataType.Floor83] = { floor = true }
Properties[DataType.Floor84] = { floor = true }
Properties[DataType.Floor85] = { floor = true }
Properties[DataType.Floor86] = { floor = true }
Properties[DataType.Floor87] = { floor = true }
Properties[DataType.Floor88] = { floor = true }
Properties[DataType.Floor89] = { floor = true }
Properties[DataType.Floor8A] = { floor = true }
Properties[DataType.Floor8B] = { floor = true }
Properties[DataType.Floor8C] = { floor = true }
Properties[DataType.Floor8D] = { floor = true }
Properties[DataType.Floor8E] = { floor = true }
Properties[DataType.Floor8F] = { floor = true }

----------------------
---- Player Start ----
----------------------
Properties[DataType.StartPositionU] = {	wall = false }
Properties[DataType.StartPositionR] = {	wall = false }
Properties[DataType.StartPositionD] = {	wall = false }
Properties[DataType.StartPositionL] = {	wall = false }

--[[
DataType.SecretDoor = 104;
DataType.GoldKey = 105;
DataType.SilverKey = 106;
DataType.Cross = 107;
DataType.Chalace = 108;
DataType.Jewels = 109;
DataType.Crown = 110;
DataType.DogFood = 111;
--]]

Properties[DataType.Food] = 
{
	sprite = true,
	enemy = false,
	modelPath = 642794,
	positionOffset = {-7,0.6,-1.8},
	rotationOffset = {0,0,0},
}

Properties[DataType.FirstAidKit] = 
{

}

Properties[DataType.ExtraLife] = 
{

}

Properties[DataType.SmallGun] = 
{

}

Properties[DataType.MachineGun] = 
{

}

Properties[DataType.Ammo] = 
{
	sprite = true,
	enemy = false,
	modelPath = 1020167,
	positionOffset = {-20,0,-5},
	rotationOffset = {0,0,0},
	unshaded = true
}

Properties[DataType.Chandelier] = 
{

}

Properties[DataType.CeilingLightGreen] = 
{
	sprite = true,
	enemy = false,
	modelPath = "304366",
	positionOffset = {-10, 0, -0.8},
	rotationOffset = {0,0,0},
	unshaded = true
}

--[[
DataType.FloorLamp = 120;
DataType.Well = 121;
DataType.WellWater = 122;
DataType.Water = 123;
DataType.PoolOfBlood = 124;
DataType.Barrel = 125;
DataType.OilDrum = 126;
DataType.Basket = 127;
--]]

Properties[DataType.TableWithChairs] = 
{
	sprite = true,
	enemy = false,
	modelPath = "249668",
	positionOffset = {0, 0, 0},
	rotationOffset = {0,0,0}
}

--[[
DataType.Table = 129;
DataType.WhiteColumn = 130;
--]]

Properties[DataType.GreenPlant] = 
{
	sprite = true,
	enemy = false,
	modelPath = 1307174,
	positionOffset = {0, 0, 0},
	rotationOffset = {0,0,0},
}

Properties[DataType.BrownPlant] = 
{
	sprite = true,
	enemy = false,
	modelPath = 1307286,
	positionOffset = {0, 0, 0},
	rotationOffset = {0,0,0},
}

--[[
DataType.Vase = 133;
DataType.Armor = 134;
DataType.Flag = 135;
DataType.Sink = 136;
DataType.UtensilsBrown = 137;
DataType.UtensilsBlue = 138;
DataType.Stove = 139;
DataType.Rack = 140; ??
DataType.Bed = 141;
DataType.EmptyCage = 142;
DataType.CageSkeleton = 143;
DataType.HangingSkeleton = 144;
--]]

Properties[DataType.Skeleton] = 
{
	sprite = true,
	enemy = false,
	modelPath = 198984,
	positionOffset = {-5, 0, -3},
	rotationOffset = {0,0,0},
}

Properties[DataType.Bones1] = 
{
	sprite = true,
	enemy = false,
	modelPath = 192651,
	positionOffset = {-5, 0, -3},
	rotationOffset = {0,0,0},
}
--[[
DataType.Bones2 = 147;
DataType.Bones3 = 148;
DataType.Bones4 = 149;
DataType.BonesBlood = 150;
DataType.AardwolfSign = 151;
DataType.Vines = 152;
DataType.Guard1_StandingR = 153;
DataType.Guard1_StandingU = 154;
DataType.Guard1_StandingL = 155;
--]]

Properties[DataType.Guard1_StandingD] = 
{
	sprite = true,
	enemy = true,
	alive = true,
	standing = true,
	hasCamera = true,
	displayID = 34892,
	positionOffset = {0, 0, -0.5},
	spriteYOffset = -100,
	startRotation = 0,
	Ani_Dead = 1,
	Ani_Idle = 2,
	Ani_IdleGun = 48
}

--[[
DataType.SS1_StandingR = 157;
DataType.SS1_StandingU = 158;
DataType.SS1_StandingL = 159;
DataType.SS1_StandingD = 160;
DataType.Officer1_StandingR = 161;
DataType.Officer1_StandingU = 162;
DataType.Officer1_StandingL = 163;
DataType.Officer1_StandingD = 164;
DataType.Mutant1_StandingR = 165;
DataType.Mutant1_StandingU = 166;
DataType.Mutant1_StandingL = 167;
DataType.Mutant1_StandingD = 168;
DataType.Guard3_StandingR = 169;
DataType.Guard3_StandingU = 170;
--]]

Properties[DataType.Guard3_StandingL] = 
{
	sprite = true,
	enemy = true,
	alive = true,
	standing = true,
	hasCamera = true,
	displayID = 34892,
	positionOffset = {0, 0, -0.5},
	spriteYOffset = -100,
	startRotation = 0,
	Ani_Dead = 1,
	Ani_Idle = 2,
	Ani_IdleGun = 48
}

Properties[DataType.Guard3_StandingD] = 
{
	sprite = true,
	enemy = true,
	alive = true,
	standing = true,
	hasCamera = false,
	displayID = 34892,
	positionOffset = {0, 0, -0.5},
	spriteYOffset = -100,
	startRotation = 0,
	Ani_Dead = 1,
	Ani_Idle = 2,
	Ani_IdleGun = 48
}

--[[
DataType.SS3_StandingR = 173;
DataType.SS3_StandingU = 174;
DataType.SS3_StandingL = 175;
DataType.SS3_StandingD = 176;
DataType.Officer3_StandingR = 177; 
DataType.Officer3_StandingU = 178;
DataType.Officer3_StandingL = 179;
DataType.Officer3_StandingD = 180;
DataType.Mutant3_StandingR = 181;
DataType.Mutant3_StandingU = 182;
DataType.Mutant3_StandingL = 183;
DataType.Mutant3_StandingD = 184;
--]]

Properties[DataType.Guard4_StandingR] = 
{
	sprite = true,
	enemy = true,
	alive = true,
	standing = true,
	hasCamera = true,
	displayID = 34892,
	positionOffset = {0, 0, -0.5},
	spriteYOffset = -100,
	startRotation = 180,
	Ani_Dead = 1,
	Ani_Idle = 2,
	Ani_IdleGun = 48
}

--[[
DataType.Guard4_StandingU = 186;
DataType.Guard4_StandingL = 187;
--]]

Properties[DataType.Guard4_StandingD] = 
{
	sprite = true,
	enemy = true,
	alive = true,
	standing = true,
	hasCamera = true,
	displayID = 34892,
	positionOffset = {0, 0, -0.5},
	spriteYOffset = -100,
	startRotation = 0,
	Ani_Dead = 1,
	Ani_Idle = 2,
	Ani_IdleGun = 48
}

--[[
DataType.SS4_StandingR = 189;
DataType.SS4_StandingU = 190;
DataType.SS4_StandingL = 191;
DataType.SS4_StandingD = 192;
DataType.Officer4_StandingR = 193; 
DataType.Officer4_StandingU = 194;
DataType.Officer4_StandingL = 195;
DataType.Officer4_StandingD = 196;
DataType.Mutant4_StandingR = 197;
DataType.Mutant4_StandingU = 198;
DataType.Mutant4_StandingL = 199;
DataType.Mutant4_StandingD = 200;
DataType.Dog1_MovingR = 201;
DataType.Dog1_MovingU = 202;
DataType.Dog1_MovingL = 203;
DataType.Dog1_MovingD = 204;
DataType.Guard1_MovingR = 205;
DataType.Guard1_MovingU = 206;
--]]

Properties[DataType.Guard1_MovingL] = 
{

}

--[[
DataType.Guard1_MovingD = 208;
DataType.SS1_MovingR = 209;
DataType.SS1_MovingU = 210;
DataType.SS1_MovingL = 211;
DataType.SS1_MovingD = 212;
DataType.Officer1_MovingR = 213; 
DataType.Officer1_MovingU = 214;
DataType.Officer1_MovingL = 215;
DataType.Officer1_MovingD = 216;
DataType.Mutant1_MovingR = 217;
DataType.Mutant1_MovingU = 218;
DataType.Mutant1_MovingL = 219;
DataType.Mutant1_MovingD = 220;
DataType.Dog3_MovingR = 221;
DataType.Dog3_MovingU = 222;
DataType.Dog3_MovingL = 223;
DataType.Dog3_MovingD = 224;
DataType.Guard3_MovingR = 225;
DataType.Guard3_MovingU = 226;
DataType.Guard3_MovingL = 227;
DataType.Guard3_MovingD = 228;
DataType.SS3_MovingR = 229;
DataType.SS3_MovingU = 230;
DataType.SS3_MovingL = 231;
DataType.SS3_MovingD = 232;
DataType.Officer3_MovingR = 233; 
DataType.Officer3_MovingU = 234;
DataType.Officer3_MovingL = 235;
DataType.Officer3_MovingD = 236;
DataType.Mutant3_MovingR = 237;
DataType.Mutant3_MovingU = 238;
DataType.Mutant3_MovingL = 239;
DataType.Mutant3_MovingD = 240;
DataType.Dog4_MovingR = 241;
DataType.Dog4_MovingU = 242;
--]]
Properties[DataType.Dog4_MovingL] = 
{

}
--[[
DataType.Dog4_MovingD = 244;
DataType.Guard4_MovingR = 245;
DataType.Guard4_MovingU = 246;
DataType.Guard4_MovingL = 247;
DataType.Guard4_MovingD = 248;
DataType.SS4_MovingR = 249;
DataType.SS4_MovingU = 250;
DataType.SS4_MovingL = 251;
DataType.SS4_MovingD = 252;
DataType.Officer4_MovingR = 253; 
DataType.Officer4_MovingU = 254;
DataType.Officer4_MovingL = 255;
DataType.Officer4_MovingD = 256;
DataType.Mutant4_MovingR = 257;
DataType.Mutant4_MovingU = 258;
DataType.Mutant4_MovingL = 259;
DataType.Mutant4_MovingD = 260;
--]]

Properties[DataType.DeadGuard] = 
{
	sprite = true,
	enemy = true,
	alive = false,
	hasCamera = true,
	displayID = 34892,
	positionOffset = {0, 0, -0.5},
	spriteYOffset = -100,
	rotationOffset = {0,0,0},
	Ani_Dead = 6,
	Ani_Idle = 2,
	Ani_IdleGun = 48
}

--[[
DataType.RedPacman = 262;
DataType.YellowPacMan = 263;
DataType.RosePacMan = 264;
DataType.BluePacMan = 265;
DataType.Hans = 266;
DataType.Doctor = 267;
DataType.RobedWorgenstein = 268;
DataType.Worgenstein = 269;
DataType.Otto = 270;
DataType.Gretel = 271;
DataType.General = 272;
--]]

-----------------
---- Pathing ----
-----------------
Properties[DataType.TurningPointR] = { }
Properties[DataType.TurningPointUR] = { }
Properties[DataType.TurningPointU] = { }
Properties[DataType.TurningPointUL] = { }
Properties[DataType.TurningPointL] = { }
Properties[DataType.TurningPointDL] = { }
Properties[DataType.TurningPointD] = { }
Properties[DataType.TurningPointDR] = { }

Properties[DataType.EndgameTrigger] = { }