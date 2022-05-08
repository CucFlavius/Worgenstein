local Door = Zee.Worgenstein.Door;
local Settings = Zee.Worgenstein.Settings;
local Map = Zee.Worgenstein.Map;

Door.currentDoorAnimation = nil;
Door.animatingDoor = false;
Door.openDoor = nil;
Door.doorCoords = {};

function Door.DoorAnimation()
	if Door.animatingDoor == true then
		if Door.openDoor == true then
			if Door.currentDoorAnimation > 0 then
				Door.currentDoorAnimation = Door.currentDoorAnimation - Settings.DoorOpenSpeed;
			else
				Door.animatingDoor = false;
			end
		elseif Door.openDoor == false then
			if Door.currentDoorAnimation < 1 then
				Door.currentDoorAnimation = Door.currentDoorAnimation + Settings.DoorOpenSpeed;
			else
				Door.animatingDoor = false;
			end
		end
		Map.Doors[Door.doorCoords.x][Door.doorCoords.y] = Door.currentDoorAnimation;
		--Map.Data[Door.doorCoords.x][Door.doorCoords.y].property = Door.currentDoorAnimation;
	end
end

function Door.OpenDoor(x,y)
	Door.doorCoords.x = x;
	Door.doorCoords.y = y;
	Door.animatingDoor = true;
	Door.openDoor = true;
	Door.currentDoorAnimation = 1;
end

function Door.CloseDoor(x,y)
	Door.doorCoords.x = x;
	Door.doorCoords.y = y;
	Door.animatingDoor = true;
	Door.openDoor = false;
	Door.currentDoorAnimation = 0;
end