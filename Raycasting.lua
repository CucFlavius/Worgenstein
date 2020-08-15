Zee = Zee or {};
Zee.Worgenstein = Zee.Worgenstein or {};
local WG = Zee.Worgenstein;
WG.Player = WG.Player or {};
local Player = WG.Player;
Zee.Worgenstein.Raycasting = Zee.Worgenstein.Raycasting or {};
local Ray = Zee.Worgenstein.Raycasting;
Zee.Worgenstein.Map = Zee.Worgenstein.Map or {};
local Map = Zee.Worgenstein.Map;
Map.DataType = Map.DataType or {};
local DataType = Map.DataType;
Zee.Worgenstein.Canvas = Zee.Worgenstein.Canvas or {};
local Canvas = Zee.Worgenstein.Canvas;
local Properties = Zee.Worgenstein.Map.DataTypeProperties;
local BlockName = Zee.Worgenstein.Map.DataTypeNames;
Zee.Worgenstein.Settings = Zee.Worgenstein.Settings or {};
local Settings = Zee.Worgenstein.Settings;
local Debugger = Zee.Worgenstein.Debugger;
local Direction = Properties.Direction;

Ray.BoxesHitMap = {};
Ray.HitPoint = {};

Ray.Log = "";

local sin = sin;
local cos = cos;
local tan = tan;
local atan = atan;
local abs = abs;
local floor = floor;
local sqrt = sqrt;

-- Get the intersection point of two lines --
-- params a, b = first line
-- params c, d = second line
-- If they intersect, returns the point where the two lines intersect, else returns nil
local L1;
local L2;
local denom;
local n_a;
local n_b;
local ua;
local ub;

function Ray.LinesIntersection( a, b, c, d )
        -- parameter conversion
        L1 = {X1=a.x,Y1=a.y,X2=b.x,Y2=b.y}
        L2 = {X1=c.x,Y1=c.y,X2=d.x,Y2=d.y}
        
        -- Denominator for ua and ub are the same, so store this calculation
        denom = (L2.Y2 - L2.Y1) * (L1.X2 - L1.X1) - (L2.X2 - L2.X1) * (L1.Y2 - L1.Y1)
        
        -- Make sure there is not a division by zero - this also indicates that the lines are parallel.
        -- If n_a and n_b were both equal to zero the lines would be on top of each
        -- other (coincidental).  This check is not done because it is not
        -- necessary for this implementation (the parallel check accounts for this).
        if (denom == 0) then
                return nil
        end
        
        -- n_a and n_b are calculated as seperate values for readability
        n_a = (L2.X2 - L2.X1) * (L1.Y1 - L2.Y1) - (L2.Y2 - L2.Y1) * (L1.X1 - L2.X1)
        n_b = (L1.X2 - L1.X1) * (L1.Y1 - L2.Y1) - (L1.Y2 - L1.Y1) * (L1.X1 - L2.X1)
        
        -- Calculate the intermediate fractional point that the lines potentially intersect.
        ua = n_a / denom
        ub = n_b / denom
        
        -- The fractional point will be between 0 and 1 inclusive if the lines
        -- intersect.  If the fractional calculation is larger than 1 or smaller
        -- than 0 the lines would need to be longer to intersect.
        if (ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1) then
                local x = L1.X1 + (ua * (L1.X2 - L1.X1))
                local y = L1.Y1 + (ua * (L1.Y2 - L1.Y1))
                local result = {}
                result.x = x;
                result.y = y;
                return result
        end
    	return nil;
end

-- version 2
local adjacentCathetus;
local sideCathetus;
local xPoint;
local yPoint;
local result = {};
function Ray.LinesIntersectionV2( edgeHit, rayAngle, x, y )
	if rayAngle % 90 == 0 then
		return nil;
	end
	if edgeHit == 1 then
		sideCathetus = Player.Position.xCell;
		adjacentCathetus = tan(180 - rayAngle) * sideCathetus;
		xPoint = 0;
		yPoint = adjacentCathetus + Player.Position.yCell;
	elseif edgeHit == 2 then
		sideCathetus = 1 - Player.Position.xCell;
		adjacentCathetus = tan(rayAngle) * sideCathetus;
		xPoint = 1;
		yPoint = adjacentCathetus + Player.Position.yCell;
	elseif edgeHit == 3 then
		sideCathetus = Player.Position.yCell;
		adjacentCathetus = tan(rayAngle - 270) * sideCathetus;
		xPoint = adjacentCathetus + Player.Position.xCell;
		yPoint = 0;
	elseif edgeHit == 4 then
		sideCathetus = 1 - Player.Position.yCell;
		adjacentCathetus = tan(90 - rayAngle) * sideCathetus;
		xPoint = adjacentCathetus + Player.Position.xCell;
		yPoint = 1;
	else
		return nil;
	end
--[[
	if Player.Position.x < x then
		result.x = x + xPoint;
	elseif Player.Position.x > x then
		result.x = x + xPoint;
	else
		result.x = x;
	end

	if Player.Position.y < y then
		result.y = y + yPoint;
	elseif Player.Position.y > y then
		result.y = y + yPoint;
	else
		result.y = y;
	end
--]]
	result.x = x + xPoint;
	result.y = y + yPoint;

	return result;
end


-- Find the distance between two points --
-- params x1, y1 = first point
-- params x2, y2 = second point
function Ray.DistanceBetweenTwoPoints ( x1, y1, x2, y2 )
	local distx = x1 - x2
	local disty = y1 - y2
	return math.sqrt ( distx * distx + disty * disty )
end

-- version 2
--[[
function Ray.DistanceBetweenTwoPoints ( x1, y1, x2, y2 )

end
--]]


-- Cast a ray and return information on the point it hit
-- param id = an index for the ray, 0 if not necessary
-- params positionX, positionY = the point where the ray is shot from
-- param angle = the angle at which the ray is shot
-- param distance = maximum distance the ray can shoot
local ray = {};
local x0;
local y0;
local x1;
local y1;
local dx;
local dy;
local x;
local y;
local n;
local x_inc, y_inc;
local err;
local previousHitBoxX;
local previousHitBoxY;
local hitPointX;
local hitPointY;
local a = {};
local b = {};
local c = {};
local d = {};
local edgeHit;	
local result;
local passed;
function Ray.Cast(id, positionX, positionY, angle, distance)
	passed = true;
	Ray.Log = "";
	ray.passthrough = false;	
	ray.uvDistance = 0;
	ray.uvDirection = 1;
	Ray.BoxesHit = {};
	Ray.BoxesHitMap = {};
	x0 = positionX;
	y0 = positionY;
	x1 = cos(angle) * distance * 50;
	y1 = sin(angle) * distance * 50;
    dx = abs(x1 - x0);
    dy = abs(y1 - y0);
    x = floor(x0);
    y = floor(y0);
    n = 1;
    if (dx == 0) then
        x_inc = 0;
        err = math.huge;
    elseif (x1 > x0) then
        x_inc = 1;
        n = n + (floor(x1) - x);
        err = (floor(x0) + 1 - x0) * dy;
    else
        x_inc = -1;
        n = n + (x - (floor(x1)));
        err = (x0 - floor(x0)) * dy;
    end
    if (dy == 0) then
        y_inc = 0;
        err = err -math.huge;
    elseif (y1 > y0) then
        y_inc = 1;
        n = n + ((floor(y1)) - y);
        err = err - ((floor(y0) + 1 - y0) * dx);
    else
        y_inc = -1;
        n = n + (y - (floor(y1)));
        err = err - ((y0 - floor(y0)) * dx);
    end
    previousHitBoxX = floor(positionY);
    previousHitBoxY = floor(positionX);
    hitPointX = 0;
    hitPointY = 0;
    for k = 1, n, 1 do
    	if (x <= Map.size and y <= Map.size) then
    		if x < 0 then x = 0; end
    		if y < 0 then y = 0; end
    		-- check first wall hit
    		if Map.Data[x][y] ~= nil then
    			if Properties[Map.Data[x][y]] == nil then 
					print ("Worgenstein: Error: Missing Block Property for " .. Map.Data[x][y]);
					Settings.RunUpdateLoop = false;
    			end
	    		if Map.Data[x][y] ~= DataType.Nothing and Properties[Map.Data[x][y]] ~= nil then
	    			-- ignoring floor tiles for performance
	    			if Properties[Map.Data[x][y]].floor ~= true then
	    				-- debug middle ray
		    			if id == 80 then -- center line
		    				Ray.Log =  Ray.Log .. " | " .. x .. " " .. y .. " " .. Zee.Worgenstein.Map.DataTypeNames[Map.Data[x][y]+1];
		    			end
		    			ray.blockType = Map.Data[x][y];
		    			ray.hitBoxX = x;
		    			ray.hitBoxY = y;
		    			-- Ray hit wall
		    			if Properties[Map.Data[x][y]].wall == true and Properties[Map.Data[x][y]].flat == nil then
							a.x = positionX;
							a.y = positionY;
							b.x = positionX + cos(angle) * distance--(Map.size * sqrt(2)));
							b.y = positionY + sin(angle) * distance--(Map.size * sqrt(2)));
							c.x = 0;
							c.y = 0;
							d.x = 0;
							d.y = 0;
							edgeHit = 0;			
							-- left edge
							if x > previousHitBoxX then
								c.x = x;
								c.y = 0;
								d.x = x;
								d.y = Map.size;
								edgeHit = 1;
								ray.uvDirection = -1;
							end
							-- right edge
							if x < previousHitBoxX then
								c.x = x + 1;
								c.y = 0;
								d.x = x + 1;
								d.y = Map.size;
								edgeHit = 2;
								ray.uvDirection = 1;
							end
							-- bottom edge
							if y > previousHitBoxY then
								c.x = 0;
								c.y = y;
								d.x = Map.size;
								d.y = y;
								edgeHit = 3;
								ray.uvDirection = 1;
							end
							-- top edge
							if y < previousHitBoxY then
								c.x = 0;
								c.y = y + 1;
								d.x = Map.size;
								d.y = y + 1;
								edgeHit = 4;
								ray.uvDirection = -1;
							end
							result = Ray.LinesIntersection(a,b,c,d);
							--result = Ray.LinesIntersectionV2(edgeHit, angle, x, y);
							if result ~= nil then
				    			hitPointX = result.x;
				    			hitPointY = result.y;
				    			if (edgeHit <= 2) then	-- hit side edge
				    				ray.uvDistance = hitPointY - floor(hitPointY);
				    			end
				    			if (edgeHit >= 3 ) then	-- hit top/bottom edge
				    				ray.uvDistance = hitPointX - floor(hitPointX);
				    			end

				    		end
				    		ray.edgeHit = edgeHit;

				    		if Properties[Map.Data[x][y]].passthrough == true then
				    			passed = false;
				    		else
				    			passed = true;
				    		end

				    		if passed == true then	    			
			    				break
			    			else
			    				ray.passthrough = true;	
				    			ray.blockType2 = ray.blockType;
				    			ray.hitBoxX2 = ray.hitBoxX;
				    			ray.hitBoxY2 = ray.hitBoxY;
				    			ray.uvDirection2 = ray.uvDirection;
				    			ray.uvDistance2 = ray.uvDistance;
				    			ray.hitPointX2 = hitPointX;
				    			ray.hitPointY2 = hitPointY;
				    			ray.edgeHit2 = ray.edgeHit;
			    			end
			    		end
			    		-- Ray hit flat
			    		if Properties[Map.Data[x][y]].flat ~= nil then --and Map.Doors[x][y] > 0 then
			    			if Properties[Map.Data[x][y]].flat == Direction.Horizontal then
								a.x = positionX;
								a.y = positionY;
			 					b.x = positionX + cos(angle) * distance
								b.y = positionY + sin(angle) * distance
								c.x = 0;
								c.y = 0;
								d.x = 0;
								d.y = 0;
								edgeHit = 0;			
								-- bottom edge
								if y > previousHitBoxY then
									c.x = x;
									c.y = y + 0.4;
									d.x = x+1;
									d.y = y + 0.4;
									edgeHit = 3;
									ray.uvDirection = 1;
								end
								-- top edge
								if y < previousHitBoxY then
									c.x = x;
									c.y = y + 0.4;
									d.x = x+1;
									d.y = y + 0.4;
									edgeHit = 4;
									ray.uvDirection = -1;
								end
								result = Ray.LinesIntersection(a,b,c,d);
								--result = Ray.LinesIntersectionV2(edgeHit, x, y);
								if result ~= nil then
					    			hitPointX = result.x;
					    			hitPointY = result.y;

					    			if (edgeHit <= 2) then	-- hit side edge
					    				ray.uvDistance = hitPointY%1 --+(1-Map.Doors[x][y]);
					    			end
					    			if (edgeHit >= 3 ) then	-- hit top/bottom edge
					    				ray.uvDistance = hitPointX%1 --+(1-Map.Doors[x][y]);
					    			end
					    		end
								ray.edgeHit = edgeHit;
					    		-- pass ray through
					    		if c.x < hitPointX then--and Map.Doors[x][y] > hitPointX%1 then
				    				break	
				    			end
				    		elseif Properties[Map.Data[x][y]].flat == Direction.Vertical then
								a.x = positionX;
								a.y = positionY;
								b.x = positionX + cos(angle) * distance
								b.y = positionY + sin(angle) * distance
								c.x = 0;
								c.y = 0;
								d.x = 0;
								d.y = 0;
								local edgeHit = 0;
							-- left edge
							if x > previousHitBoxX then
								c.x = x + 0.4;
								c.y = y;
								d.x = x + 0.4;
								d.y = y + 1;
								edgeHit = 1;
								ray.uvDirection = -1;
							end
							-- right edge
							if x < previousHitBoxX then
								c.x = x + 0.6;
								c.y = y;
								d.x = x + 0.6;
								d.y = y+1;
								edgeHit = 2;
								ray.uvDirection = 1;
							end
								result = Ray.LinesIntersection(a,b,c,d);
								--result = Ray.LinesIntersectionV2(edgeHit, x, y);
								if result ~= nil then
					    			hitPointX = result.x;
					    			hitPointY = result.y;

					    			if (edgeHit <= 2) then	-- hit side edge
					    				ray.uvDistance = hitPointY%1 --+(1-Map.Doors[x][y]);
					    			end
					    			if (edgeHit >= 3 ) then	-- hit top/bottom edge
					    				ray.uvDistance = hitPointX%1 --+(1-Map.Doors[x][y]);
					    			end
					    		end
								ray.edgeHit = edgeHit;
					    		-- pass ray through
					    		if c.y < hitPointY then--and Map.Doors[x][y] > hitPointY%1 then
				    				break	
				    			end			    										
				    		end	
			    		end
			    	end
	    		end
	    	else
	    		print ("Worgenstein: Error: Missing data at x=".. x .. " y=" .. y);
	    	end
		    previousHitBoxX = x;
		    previousHitBoxY = y;
	        if (err > 0) then
	            y = y + y_inc;
	            err = err - dx;
	        else
	            x = x + x_inc;
	            err = err + dy;
			end
		end
	end
	local distance = Ray.DistanceBetweenTwoPoints ( hitPointX, hitPointY, positionX, positionY );
	local fi = abs(angle - Player.Direction);
	local distanceCorrected = distance * cos(fi); --fisheye correction
	ray.distanceCorrected = distanceCorrected;
	ray.distance = distance;
	ray.x = hitPointX;
	ray.y = hitPointY;

	if ray.passthrough == true then 
		local distance2 = Ray.DistanceBetweenTwoPoints ( ray.hitPointX2, ray.hitPointY2, positionX, positionY );
		local distanceCorrected2 = distance2 * cos(fi); --fisheye correction
		ray.distanceCorrected2 = distanceCorrected2;
		ray.distance2 = distance2;
		ray.x2 = ray.hitPointX2;
		ray.y2 = ray.hitPointY2;		
	end

	if id == 80 then -- center line
		Player.HitPoint:SetPoint("BOTTOMLEFT",ray.x * 11, ray.y * 11);
		Debugger.Log.text:SetText(Ray.Log);
	end
	return ray;
end

function Ray.Simple(x0, y0, x1, y1)
	ray.uvDistance = 0;
	ray.uvDirection = 1;
	ray.BoxesHit = {};
	Ray.BoxesHitMap = {};
    dx = abs(x1 - x0);
    dy = abs(y1 - y0);
    x = floor(x0);
    y = floor(y0);
    n = 1;
    if (dx == 0) then
        x_inc = 0;
        err = math.huge;
    elseif (x1 > x0) then
        x_inc = 1;
        n = n + (floor(x1) - x);
        err = (floor(x0) + 1 - x0) * dy;
    else
        x_inc = -1;
        n = n + (x - (floor(x1)));
        err = (x0 - floor(x0)) * dy;
    end
    if (dy == 0) then
        y_inc = 0;
        err = err -math.huge;
    elseif (y1 > y0) then
        y_inc = 1;
        n = n + ((floor(y1)) - y);
        err = err - ((floor(y0) + 1 - y0) * dx);
    else
        y_inc = -1;
        n = n + (y - (floor(y1)));
        err = err - ((y0 - floor(y0)) * dx);
    end
    previousHitBoxX = floor(y0);
    previousHitBoxY = floor(x0);
    ray.hit = true;
    for k = 1, n, 1 do
    	if (x <= Map.size and y <= Map.size) then
    		if x < 0 then x = 0; end
    		if y < 0 then y = 0; end
    		-- check first wall hit
    		if Map.Data[x][y] ~= nil then
    			if Properties[Map.Data[x][y]] == nil then 
					print ("Worgenstein: Error: Missing Block Property for " .. Map.Data[x][y]);
					Settings.RunUpdateLoop = false;
    			end
	    		if Map.Data[x][y] ~= DataType.Nothing and Properties[Map.Data[x][y]] ~= nil then
	    			--print (BlockName[Map.Data[x][y].blockType + 1]);
	    			-- ignoring floor tiles for performance
	    			if Properties[Map.Data[x][y]].floor ~= true then
		    			ray.blockType = Map.Data[x][y];
		    			ray.blockProperty = Map.Doors[x][y];
		    			ray.hitBoxX = x;
		    			ray.hitBoxY = y;
		    			-- Ray hit wall
		    			if Properties[Map.Data[x][y]].wall == true then
		    				ray.hit = false;
		    			end
		    			if Properties[Map.Data[x][y]].door == true and Map.Doors[x][y] > 0 then
		    				ray.hit = false;
		    			end		    			
		    		end
		    	end
		    end
		    previousHitBoxX = x;
		    previousHitBoxY = y;
	        if (err > 0) then
	            y = y + y_inc;
	            err = err - dx;
	        else
	            x = x + x_inc;
	            err = err + dy;
			end
    		ray.BoxesHit[k] = {};
    		ray.BoxesHit[k].x = x;
    		ray.BoxesHit[k].y = y;
		end
	end
	return ray
end

-- unused
function Ray.MinimapHighlightBoxesHit()
	for _, hit in ipairs(Ray.BoxesHit) do
		if hit.x >= 0 and hit.x <= Map.size and hit.y >= 0 and hit.y <= Map.size then
			Ray.BoxesHitMap[hit.x .. "-" .. hit.y] = 2; -- hit box
		end
	end
end