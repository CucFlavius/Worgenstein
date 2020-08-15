Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
local WG = Zee.Worgenstein;
Zee.Worgenstein.Data = Zee.Worgenstein.Data or {};
local Data = Zee.Worgenstein.Data;
Zee.Worgenstein.Map = Zee.Worgenstein.Map or {};
local Map = Zee.Worgenstein.Map;
Zee.Worgenstein.MapEditor = Zee.Worgenstein.MapEditor or {}
local MapEditor = Zee.Worgenstein.MapEditor;
local Ray = Zee.Worgenstein.Raycasting;
Map.size = 16;
Map.diagonal = Map.size * math.sqrt(2);
Map.DataType = Map.DataType or {};
Map.Orientation = Map.Orientation or {};
local DataType = Map.DataType;
local Property = Map.DataTypeProperties;
local Orientation = Map.Orientation;
Map.Doors = {};

-- enums --

function Map.LoadData()
	Map.Data = WorgensteinMapData; -- load saved variable instead
	--Map.Data = Data["Episode1Floor1"];
	WorgensteinMapData = Map.Data;
end

function Map.TwoDOneD(data)
	dataOneD = {};
	local index = 1;
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			dataOneD[index] = data[x][y];
			index = index + 1;
		end
	end	
	return dataOneD;
end

function Map.OneDTwoD(data)
	dataTwoD = {};
	local index = 1;
	for x = 0, Map.size, 1 do
		dataTwoD[x] = {};
		for y = 0, Map.size, 1 do
			--dataOneD[index] = data[x][y];
			dataTwoD[x][y] = data[index];
			index = index + 1;
		end
	end	
	return dataTwoD;
end

function Map.CompressData(data)
	local compressed = {};
	local compressedIndex = 1;
	local currentValue;
	local counter = 1;

	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			if currentValue ~= data[x][y] then
				currentValue = data[x][y];
				compressed[compressedIndex] = {}
				compressed[compressedIndex][1] = currentValue;
				compressed[compressedIndex][2] = counter;
				compressedIndex = compressedIndex + 1;
				counter = 1;
			else
				counter = counter + 1;
			end
		end
	end	

	--[[
	local dataString = "";
	local currentValue;
	local currentChar;
	local values = {};
	local index = 1;
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			currentValue = data[x][y];
			currentChar = string.char(currentValue);
			print (currentChar);
			values[index] = currentChar;
			index = index + 1;
		end
	end
	dataString = listvalues(values);
	return dataString;
	--]]

	return compressed;
end

local function listvalues(s)
    local t = { }
    for k,v in ipairs(s) do
        t[#t+1] = tostring(v)
    end
    return table.concat(t,"\n")
end

function Map.GenerateEmpty()
	Map.Data = {};
	for x = 0, Map.size, 1 do
		Map.Data[x] = {};
		for y = 0, Map.size, 1 do
			Map.Data[x][y] = {};
			Map.Data[x][y] = DataType.Nothing;
		end
	end
end

function Map.FillMissingData()
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			if Map.Data[x][y] == nil then
				Map.Data[x][y] = {};
				Map.Data[x][y] = DataType.GreyBrick1;
			end
		end
	end
end

function Map.GenerateOuterWalls()
	for x = 0, Map.size, 1 do
		for y = 0, Map.size, 1 do
			if x == 0 or x == Map.size or y == 0 or y == Map.size then
				Map.Data[x][y] = DataType.Wall;
			end
		end
	end
end

function Map.Fill()
	if MapEditor.selectedTab ~= nil then
		Map.Data = {};
		for x = 0, Map.size, 1 do
			Map.Data[x] = {};
			for y = 0, Map.size, 1 do
				Map.Data[x][y] = {};
				Map.Data[x][y] = MapEditor.selectedTab - 1;
			end
		end
	end
	MapEditor.UpdateMinimap();
	WorgensteinMapData = Map.Data;
end

function Map.LoadDoors()
	Map.Doors = {};
	for x = 0, Map.size, 1 do
		Map.Doors[x] = {};
		for y = 0, Map.size, 1 do
			local blockType = Map.Data[x][y]
			if Property[blockType] ~= nil then
				if Property[blockType].door ~= nil then
					Map.Doors[x][y] = 1;
				else
					Map.Doors[x][y] = -1;
				end
			end
		end
	end
end