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

---This module represents a Button component which can be shown in a GUIScene.
module ('luawidgets.button', package.seeall)

local label = require 'luawidgets.label';
local bitmapText = require'luawidgets.bitmapFonts.bitmapText'

--- Inherit function
--@see luawidgets.label
function inherit(  )
    local new_class = {}
    local class_mt = { __index = new_class }

	--- Button Constructor
	--@param x x position of the object
	--@param y y position of the object
	--@param bFont BitmapFont used to render the text of the component.
	--@param text Text that will be shown in the button
	--@param backgroundPath path to the image that will be used as background
	--@name Button:new
    function new_class:new(x, y, bFont, text, backgroundPath)

        local temp = label.Label:new(x, y, bFont, text, backgroundPath);
		setmetatable( temp, class_mt );

		temp.enabled = true;
		temp.onFocusImagePath = nil;
		temp.onFocusImage = nil;
		temp.onFocusColor = 'red';
        return temp;
    end

    if label.Label then
        setmetatable( new_class, { __index = label.Label } )
    end

    return new_class
end

Button = inherit()

---Default action that is executed when the event "onEnter" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function Button:onEnterDefaultAction ()
	self.focus = true;
end

---Default action that is executed when the event "onExit" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function Button:onExitDefaultAction ()
	self.focus = false;
end

---Sets the enalbed value. If an object is enabled, then it can be focused.
--@param enabled Enabled new value
function Button:setEnabled (enabled)
	self.enabled = enabled;
end

---Sets the onFocusColor that will be used to render the focus rectangle when there isn't a focus image set.
--@param ofc The new color that will be used to render the focus rectangle when there isn't a focus image set.
function Button:setOnFocusColor (ofc)
	self.onFocusColor = ofc;
end

---Sets the onFocusImage path that will be used to render the image button correspondant to the focused state
--@param ofip The image that will be used to render the
function Button:setOnFocusImagePath (ofip)
	self.onFocusImagePath = ofip;

	-- Render the image to be used when the object is focused
	local bText = bitmapText.BitmapText:new(self.text, self.bitmapFont, ofip)
	-- Center the text
	bText:centerText();
	-- Save the image
	self.onFocusImage = bText:getImage();
end

---Draws the button in canvas. It uses the parent Draw method and adds the focus part.
function Button:draw()
	local xOffset = 0;
	local yOffset = 0;

	if (self.parent) then
		xOffset = self.parent:getX();
		yOffset = self.parent:getY();
	end

	local sizeW, sizeH = self.image:attrSize();

	-- Calls the super draw method, i.e, the Label's draw method
	label.Label.draw(self);

	-- Adds the focus part..
	if (self.focus) then
		if (not self.onFocusImage) then
			canvas:attrColor(self.onFocusColor);
			canvas:drawRect('frame', self.x + xOffset, self.y + yOffset, sizeW, sizeH);
		else
			canvas:compose(self.x + xOffset, self.y + yOffset, self.onFocusImage);
		end
	end
end
