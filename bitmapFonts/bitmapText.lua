--[[	
	BitmapFonts for Ginga
	Copyright (C) 2011, PLADEMA

	This file is part of Athus.

	BitmapFonts for Ginga is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or any later version.

	BitmapFonts for Ginga is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
along with Athus.  If not, see <http://www.gnu.org/licenses/>.
]]--

--- This module represents a Bitmap Text that must be compiled using a Bitmap Font to generate an image representing the text.

module ('luawidgets.bitmapFonts.bitmapText', package.seeall)

BitmapText = {
	image = nil,
	text = nil,
	font = nil,
	backgroundPath = nil,
	xOffset = 0,
	yOffset = 0,
	charWidth = 0,
	charHeight = 0,
	changes = 0
}

Class_Metatable = { __index = BitmapText }

---BitmapText Constructor
--@param text Text to be represented by an image
--@param font Font to render the text
--@param backgroundPath Path to the image that will be used as the text background
--@param xOff offset to be added to the text X position
--@param yOff offset to be added to the text Y position
function BitmapText:new (text, font, backgroundPath, xOff, yOff)
	local temp = {};
	setmetatable ( temp, Class_Metatable );

	if (text and font) then
		temp.font = font;
		temp.text = text;
		temp.charWidth = font:getCharWidth();
		temp.charHeight = font:getCharHeight();
	end

	if ( backgroundPath ) then
		temp.backgroundPath = backgroundPath;
		temp.image = canvas:new( backgroundPath );
	end
	
    return temp;
end

---This function generates an image that represents the text.
-- @param background (optional) If this parameter is passed, then it cantains the canvas that will be used as background (remember that this parameter is passed by reference).
function BitmapText:compile(background)
	if ( background ) then
		self.image = background;
	-- If a background has been setted
	elseif ( not self.backgroundPath ) then
		-- Generate the canvas to store the compiled image
		self.image = canvas:new( #self.text * self.charWidth, self.font:getCharHeight() );
		self.image:clear();
	elseif ( self.changes ) then
		self.image = canvas:new( self.backgroundPath );
	end

	local char = nil
	local actualCharNumber = 1

	-- For each char...
	for char in self.text:gmatch"." do
		-- Add the image that corresponds to the char
		self.image:compose( (actualCharNumber - 1) * self.charWidth + self.xOffset, self.yOffset, self.font:getCharImage(char) );
		actualCharNumber = actualCharNumber + 1;		
	end

	self.changes = 0
end

---This function returns the image that represents the text
--@return A canvas containing the image that represents the character
function BitmapText:getImage()
	return self.image;
end

---This function sets the background to the text and the text's offsets optionally. After that, it compiles the new image to update the changes
--@param backgroundPath Path to the image that will be used as the text background
--@param xOff offset to be added to the text X position
--@param yOff offset to be added to the text Y position
function BitmapText:setBackgroundPath(backgroundPath, xOff, yOff)
	self.backgroundPath = backgroundPath

	if ( xOff ) then
		self.xOffset = xOff
	end

	if ( yOff ) then
		self.yOffset = yOff
	end

	self.changes = 1

	self:compile()
end

---This function calculates the coordinates to draw the text in the center of the background and recompiles the image to update the changes
-- @param background (optional) If this parameter is passed, then it cantains the canvas that will be used as background (remember that this parameter is passed by reference).
function BitmapText:centerText(background)
	if (background) then
		local w, h = background:attrSize()
		self.xOffset = (w / 2) - (#self.text * self.charWidth) / 2
		self.yOffset = (h / 2) - self.charHeight / 2	
	elseif ( not self.backgroundPath ) then
		self.xOffset = 0; self.yOffset = 0
	else
		local w, h = self.image:attrSize()
		self.xOffset = (w / 2) - (#self.text * self.charWidth) / 2
		self.yOffset = (h / 2) - self.charHeight / 2
	end

	self.changes = 1

	self:compile(background)
end


