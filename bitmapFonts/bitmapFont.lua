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


--- This module represents a Bitmap Font that can be used to render text as an image

module ('luawidgets.bitmapFonts.bitmapFont', package.seeall)

BitmapFont = {
	path  = nil,
	image = nil,
	charWidth = nil,
	charHeight = nil,
	rowCount = nil,
	columnCount = nil,
	charReference = nil,
	charTable = {}
}

Class_Metatable = { __index = BitmapFont }

---Bitmap Constructor
--@param path Image location
--@param charReference String which contains a reference about the characters in the image.
--@param charWidth Character width
--@param charHeight Character height
--@param rowCount Amount of rows in the character matrix
--@param columnCount Amount of columns in the character matrix
function BitmapFont:new (path, charReference, charWidth, charHeight, rowCount, columnCount)
	local temp = {};
	setmetatable ( temp, Class_Metatable );

	temp.path = path;
	temp.charReference = charReference;
	temp.charWidth = charWidth;
	temp.charHeight = charHeight;
	temp.rowCount = rowCount;
	temp.columnCount = columnCount;

	temp:loadImage();

    return temp;
end

---This function transforms an image into a bitmap font
function BitmapFont:loadImage()
	-- Load the image
	self.image = canvas:new(self.path);

	-- Generate the info to locate each character in the image
	for i = 0, self.rowCount - 1 do
		for j = 0, self.columnCount - 1 do
			-- Calculate the index of the actual char in the reference array
			local charNumber = i * self.columnCount + j + 1;

			-- Set the info about the char in the charTable
			local actualChar = self.charReference:sub(charNumber, charNumber);
			self.charTable[actualChar] = { left = j * self.charWidth, top = i * self.charHeight }
		end
	end
end

---This function transforms an image into a bitmap font
--@return A canvas containing the image that represents the character
function BitmapFont:getCharImage(character)
	local data = self.charTable[ character ];

	local charImg = canvas:new(self.charWidth, self.charHeight);
	charImg:compose(0, 0, self.image, data.left, data.top, self.charWidth, self.charHeight);
	return charImg;

	--self.image:attrCrop ( data.left, data.top, self.charWidth, self.charHeight );
	--return self.image;

end

---This function returns the char width
--@return char width
function BitmapFont:getCharWidth()
	return self.charWidth;
end

---This function returns the char height
--@return char height
function BitmapFont:getCharHeight()
	return self.charHeight;
end

