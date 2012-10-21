--[[	
	LuaWidgets, a widgets library for Ginga.ar based applications.
Copyright (C) 2011, PLADEMA

	This file is part of LuaWidgets.

	LuaWidgets is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or any later version.

	LuaWidgets is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
along with LuaWidgets.  If not, see <http://www.gnu.org/licenses/>.
]]--

---This module represents a Check Button component which can be shown in a GUIScene. A Check Button is a button which has an associated value: true or false.
module ('luawidgets.checkButton', package.seeall)

local bitmapText = require'luawidgets.bitmapFonts.bitmapText'
local button = require 'luawidgets.button';

--- Inherit function
--@see luawidgets.button
function inherit(  )
    local new_class = {}
    local class_mt = { __index = new_class }

	--- CheckButton Constructor
	--@param x x position of the object
	--@param y y position of the object
	--@param bFont BitmapFont used to render the text of the component.
	--@param text Text that will be shown in the button
	--@param backgroundFalsePath path to the image that will be used as background when the check button value is false
	--@param backgroundTruePath path to the image that will be used as background when the check button value is true
	--@name CheckButton:new 
    function new_class:new(x, y, bFont, text, backgroundFalsePath, backgroundTruePath)
		
        	local temp = button.Button:new(x, y, bFont, text, backgroundFalsePath );
		setmetatable( temp, class_mt );

		temp.backgroundTruePath = backgroundTruePath;
		temp.backgroundTrue = canvas:new(backgroundTruePath);

		temp.imageTrue = nil;

		temp.value = false;
        return temp;
    end

    if button.Button then
        setmetatable( new_class, { __index = button.Button } )
    end

    return new_class
end

CheckButton = inherit()

---Sets the onFocusImage path that will be used when the checkButton's value is false.
--@param ofip The image that will be used to render the 
function CheckButton:setOnFocusFalseImagePath (ofip)
	self:setOnFocusImagePath(ofip);
end

---Sets the onFocusImage path that will be used when the checkButton's value is true.
--@param ofip The image that will be used to render the 
function CheckButton:setOnFocusTrueImagePath (ofip)
	self.onFocusTrueImagePath = ofip;
	
	-- Render the image to be used when the object is focused
	local bText = bitmapText.BitmapText:new(self.text, self.bitmapFont, ofip)
	-- Center the text
	bText:centerText();
	-- Save the image
	self.onFocusTrueImage = bText:getImage();
end

---Sets the value (true or false) to the checkButton
--@param value The new value 
function CheckButton:setValue(value)
	self.value = value;
end

---Gets the checkButton's value
--@return The checkButton's value 
function CheckButton:getValue()
	return self.value;
end

---Changes the value from true to false or from false to true.
--@param value The new value 
function CheckButton:changeValue()
	self.value = not self.value;
end

---Draws the Check Button in the canvas. If it has an image that represents the focused (true and false) component, then it
-- uses these images when the component is focused. Else, it uses a colored rectangle 
--@see luawidget.checkButton:setOnFocusColor
function CheckButton:draw()
	local xOffset = 0;
	local yOffset = 0; 

	if (self.parent) then
		xOffset = self.parent:getX();
		yOffset = self.parent:getY();
	end

	local sizeW, sizeH = self.image:attrSize();

	-- Draw the image...
	if (self.value) then
		canvas:compose(self.x + xOffset, self.y + yOffset, self.imageTrue);
	else
		canvas:compose(self.x + xOffset, self.y + yOffset, self.image);
	end

	-- If it is focused...
	if (self.focus) then
		-- If it has not an image to show when it is focused (true or false)...
		if (not self.onFocusTrueImage or not self.onFocusFalseImage) then
			canvas:attrColor(self.onFocusColor);
			canvas:drawRect('frame', self.x + xOffset, self.y + yOffset, sizeW, sizeH);
		else -- If it has an image to show when it is focused...
			if (self.value) then
				canvas:compose(self.x + xOffset, self.y + yOffset, self.onFocusTrueImage);
			else
				canvas:compose(self.x + xOffset, self.y + yOffset, self.onFocusImage);
			end
		end	
	end
end

---Default action that is executed when the event "onEnter" occurs. 
function CheckButton:onSelectDefaultAction ()
	self:changeValue();
end

---Renders the component generating the appropriate image and saving it into the Component state. When the component will be drawn using "draw" method, this image will be painted
function CheckButton:prerender()
	-- Render the falseImage using the button prerender method
	button.Button.prerender(self);

	-- Create the bitmap text
	local bText = bitmapText.BitmapText:new(self.text, self.bitmapFont, self.backgroundTruePath)
	-- Center the text
	bText:centerText();
	-- Save the image
	self.imageTrue = bText:getImage();
	-- Update the dimensions
	self.w, self.h = self.image:attrSize();
	
end
