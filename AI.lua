
Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
Zee.Worgenstein.AI = Zee.Worgenstein.AI or {}
local AI = Zee.Worgenstein.AI;
local Canvas = Zee.Worgenstein.Canvas;
local Ray = Zee.Worgenstein.Raytracing;
local Player = Zee.Worgenstein.Player;
local Settings = Zee.Worgenstein.Settings;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local BlockName = Zee.Worgenstein.Map.DataTypeNames;
local MapEditor = Zee.Worgenstein.MapEditor;

AI.EnemySprites = {};
AI.totalEnemies = 0;
AI.AliveEnemySprites = {};
AI.totalAliveEnemies = 0;

AI.EnemyState = {};
AI.EnemyState.IDLE = 0;
AI.EnemyState.PATROLLING = 1;
AI.EnemyState.AGGRO = 2;
AI.EnemyState.DEAD = 3;

function AI.Initialize()
	--compile a list of all enemies
	for s = 1, Canvas.totalSprites, 1 do
		if Canvas.spriteList[s].property.enemy == true then
			AI.totalEnemies = AI.totalEnemies + 1;
			AI.EnemySprites[AI.totalEnemies] = s;
			if Canvas.spriteList[s].property.alive == true then
				AI.totalAliveEnemies = AI.totalAliveEnemies + 1;
				AI.AliveEnemySprites[AI.totalAliveEnemies] = s;
				if Canvas.spriteList[s].property.standing == true then
					Canvas.spriteList[s].enemyStatus = AI.EnemyState.IDLE;
				end
				if Canvas.spriteList[s].property.patrolling == true then
					Canvas.spriteList[s].enemyStatus = AI.EnemyState.PATROLLING;
				end				
			else
				Canvas.spriteList[s].enemyStatus = AI.EnemyState.DEAD;
			end
		end
	end
	print ("Total Enemies : " .. AI.totalEnemies);
	print ("Total Alive Enemies : " .. AI.totalAliveEnemies);
end

-- 0 = turn right
-- 1 = die
-- 2 = stand
-- 4 = walk
-- 5 = run
-- 6 = dead
-- 8 = take damage
-- 9 = take damage 2
-- 10 = take damage 3
-- 11 = turn left
-- 12 = turn right
-- 13 = walk backwards
-- 14 = dazed
-- 16 = punch
-- 17 = slash
-- 18 = slash 2
-- 19 = slash 3
-- 20 = block
-- 21 = stab
-- 22 = parry
-- 23 = parry 2
-- 24 = block 2
-- 25 = idle fists
-- 26 = idle aggro
-- 27 = idle 2 handed
-- 28 = idle 2 handed 2
-- 29 = idle bow
-- 30 = dodge
-- 32 = punch 2
-- 33 = punch 3
-- 36 = damage
-- 37 = start jump
-- 38 = jumping
-- 39 = end jump / land
-- 41 = swim float
-- 42 = swim forward
-- 43 = swim left
-- 44 = swim right
-- 45 = swim backwards
-- 46 = aim bow
-- 48 = idle gun
-- 49 = shoot
-- 50 = pick up
-- 51 = cast
-- 52 = cast 2
-- 52 = cast 3
-- 53 = cast 4
-- 55 = roar

local aggroRange = 5;

function AI.Update()
	local sprite;
	local distance;
	for e = 1, AI.totalEnemies, 1 do
		sprite = Canvas.spriteList[AI.EnemySprites[e]];

		-- Aggro Enter
		distance = Ray.DistanceBetweenTwoPoints(Player.Position.x, Player.Position.y, sprite.x, sprite.y);
		if distance < aggroRange and sprite.enemyStatus ~= AI.EnemyState.AGGRO and sprite.enemyStatus ~= AI.EnemyState.DEAD then
			local ray = Ray.Simple(Player.Position.x, Player.Position.y, sprite.x + sprite.offsetX, sprite.y + sprite.offsetY);
			if ray.hit == true then
				sprite:SetAnimation(48);
				sprite.currentRotation = -Player.Direction + sprite.currentRotation - (distance*2);
				if sprite.currentRotation >= 0 and sprite.currentRotation < 180 then
					sprite.rotateTo = 0;
				elseif sprite.currentRotation >= 180 then
					sprite.rotateTo = 360;
				elseif sprite.currentRotation < 0 and sprite.currentRotation > -180 then
					sprite.rotateTo = 0;
				elseif sprite.currentRotation <= -180 then
					sprite.rotateTo = -360;
				end
				sprite.enemyStatus = AI.EnemyState.AGGRO;
			end
		end

		-- Aggro
		if sprite.enemyStatus == AI.EnemyState.AGGRO then
			AI.Combat(sprite);
		end

		-- Idle
		if sprite.enemyStatus == AI.EnemyState.IDLE then
			sprite:SetRotation(math.rad(-Player.Direction + sprite.currentRotation - (distance*2)));
		end

		-- Patrolling
		if sprite.enemyStatus == AI.EnemyState.PATROLLING then
			sprite:SetRotation(math.rad(-Player.Direction + sprite.currentRotation - (distance*2)));
		end

		-- Dead
		if sprite.enemyStatus == AI.EnemyState.DEAD then
			sprite:SetRotation(math.rad(-Player.Direction + sprite.currentRotation - (distance*2)));
		end

		-- Move
		if sprite.moveToX ~= sprite.x or sprite.moveToY ~= sprite.y then
			local moveIncrement = 0.01;
			if sprite.moveToX < sprite.x then
				--sprite.x = sprite.x + 0.1;
				sprite.offsetX = sprite.offsetX - moveIncrement;
				if sprite.offsetX <= -0.5 then
					sprite.x = sprite.moveToX;
					sprite.offsetX = 0.5;
				end
			end
			if sprite.moveToX > sprite.x then
				--sprite.x = sprite.x - 0.1;
				sprite.offsetX = sprite.offsetX + moveIncrement;
				if sprite.offsetX >= 1.5 then
					sprite.x = sprite.moveToX;
					sprite.offsetX = 0.5;
				end				
			end

			if sprite.moveToY < sprite.y then
				--sprite.y = sprite.y + 0.1;
				sprite.offsetY = sprite.offsetY - moveIncrement;
				if sprite.offsetY <= -0.5 then
					sprite.y = sprite.moveToY;
					sprite.offsetY = 0.5;
				end				
			end
			if sprite.moveToY > sprite.y then
				--sprite.y = sprite.y - 0.1;
				sprite.offsetY = sprite.offsetY + moveIncrement;
				if sprite.offsetY >= 1.5 then
					sprite.y = sprite.moveToY;
					sprite.offsetY = 0.5;
				end					
			end	
				
			--sprite.x = sprite.moveToX;
			--sprite.y = sprite.moveToY;
		end		

		-- Rotate
		if sprite.rotateTo < sprite.currentRotation or sprite.rotateTo > sprite.currentRotation then
			if sprite.currentRotation < sprite.rotateTo then
				sprite.currentRotation = sprite.currentRotation + Settings.EnemyTurnSpeed;
			end
			if sprite.currentRotation > sprite.rotateTo then
				sprite.currentRotation = sprite.currentRotation - Settings.EnemyTurnSpeed;
			end
		end

	end
end

function AI.Combat(sprite)

	-- reset last action time
	if sprite.lastActionTime == nil then
		sprite.lastActionTime = GetTime();
	end

	-- action every 1 second
	if GetTime() >= sprite.lastActionTime + 1 then
		sprite.lastActionTime = GetTime();

		local distance = Ray.DistanceBetweenTwoPoints(Player.Position.x, Player.Position.y, sprite.x + sprite.offsetX, sprite.y + sprite.offsetY);
		if distance <= aggroRange then -- shoot
			local ray = Ray.Simple(Player.Position.x, Player.Position.y, sprite.x + sprite.offsetX, sprite.y + sprite.offsetY);

			if ray.hit == true then
				sprite:SetAnimation(49);
			else
				sprite:SetAnimation(48);
			end
		else 		-- chase player
			sprite:SetAnimation(4);
			local ray = Ray.Simple(sprite.x + sprite.offsetX, sprite.y + sprite.offsetY, Player.Position.x, Player.Position.y);
			if ray.hit == true then 
				sprite.moveToX = ray.BoxesHit[1].x;
				sprite.moveToY = ray.BoxesHit[1].y;
				--print(sprite.x .. " " .. sprite.y)
			else
				sprite.enemyStatus = AI.EnemyState.IDLE
				sprite:SetAnimation(48);
			end
		end
	end

end
