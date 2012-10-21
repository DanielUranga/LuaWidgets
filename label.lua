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

---This module represents a label component which can be shown in a GUIScene.
module ('luawidgets.label', package.seeall)

local component = require 'luawidgets.component';
local bitmapText = require'luawidgets.bitmapFonts.bitmapText'

--- Inherit function
--@see luawidgets.component
function inherit(  )
    local new_class = {}
    local class_mt = { __index = new_class }

	--- Label Constructor. You must specify an image to use as background. If you want a transparent background, then specify a .png transparent image.
	--@param x x position of the object
	--@param y y position of the object
	--@param bFont BitmapFont used to render the text of the component.
	--@param text Text to be displayed in the 
	--@param backgroundPath path to the image that will be used as background. If 
	--@name Label:new 
    function new_class:new(x, y, bFont, text, backgroundPath)
	
        	local temp = component.Component:new(x, y, bFont);
		setmetatable( temp, class_mt );

		if (backgroundPath) then 
			temp.background = canvas:new(backgroundPath);
			temp.backgroundPath = backgroundPath;
		end

		temp.text = text;
		temp.enabled = false;

        return temp
    end

    if component.Component then
        setmetatable( new_class, { __index = component.Component } )
    end

    return new_class
end

Label = inherit()

---Sets the text to the label.
--@param text Text that will be shown in the label
function Label:setText(text)
	self.text = text;
end

---Returns the text to the label.
--@return Text that will be shown in the label
function Label:getText()
	return self.text;
end

---Draws the label in the given canvas. 
--@param scene The canvas where the component must be drawn
function Label:draw()
	local xOffset = 0;
	local yOffset = 0; 

	if (self.parent) then
		xOffset = self.parent:getX();
		yOffset = self.parent:getY();
	end

	if (self.image) then
		canvas:compose(self.x + xOffset, self.y + yOffset, self.image);
	end
end

---Renders the component generating the appropriate image and saving it into the Component state. When the component will be drawn using "draw" method, this image will be painted over the given canvas.
function Label:prerender()
	-- Create the bitmap text
	local bText = bitmapText.BitmapText:new(self.text, self.bitmapFont, self.backgroundPath)
	-- Center the text
	bText:centerText();
	-- Save the image
	self.image = bText:getImage();
	-- Update the dimensions
	self.w, self.h = self.image:attrSize();
end

---Sets the enabled value. A label can never be enabled because it can't receive the focus.
--@param enabled Enabled new value
function Label:setEnabled(enabled)
	self.enabled = false;
end

