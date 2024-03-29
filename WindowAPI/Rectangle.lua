-------------------------- Zee's Window API ---------------------------
-- Developed it for use in my addons, but feel free to use in yours ---
-----------------------------------------------------------------------

--Rectangle--
Zee = Zee or {};
Zee.WindowAPI = Zee.WindowAPI or {};
local Win = Zee.WindowAPI;

function Win.CreateRectangle(posX, posY, sizeX, sizeY, parent, windowPoint, parentPoint, R, G, B, A)

	-- defaults --
	if posX == nil then posX = 0; end
	if posY == nil then posY = 0; end
	if sizeX == nil or sizeX == 0 then sizeX = 50; end
	if sizeY == nil or sizeY == 0 then sizeY = 50; end	
	if parent == nil then parent = UIParent; end
	if windowPoint == nil then windowPoint = "CENTER"; end
	if parentPoint == nil then parentPoint = "CENTER"; end
	if text == nil then text = ""; end

    local isVisible = true;
    if R == nil or G == nil or B == nil then
        isVisible = false;
    end

	-- text box frame --
	local Rectangle = CreateFrame("Frame", "Zee.WindowAPI.Rectangle", parent);
	Rectangle:SetPoint(windowPoint, parent, parentPoint, posX, posY);
	Rectangle:SetSize(sizeX, sizeY);
    if isVisible then
        Rectangle.texture = Rectangle:CreateTexture("Zee.WindowAPI.Rectangle texture", "BACKGROUND");
        Rectangle.texture:SetColorTexture(R,G,B,A);
        Rectangle.texture:SetAllPoints(Rectangle);
    end
	return Rectangle;

end