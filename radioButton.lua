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

---This module represents a RadioButton component. This component just can be used into a RadioButtonGroup. 
--@see luawidgets.radioButtonGroup
module ('luawidgets.radioButton', package.seeall)

local checkButton = require 'luawidgets.checkButton';
local bitmapText = require'luawidgets.bitmapFonts.bitmapText'

--- Inherit function
--@see luawidgets.checkButton
function inherit(  )
    local new_class = {}
    local class_mt = { __index = new_class }

	--- Labe Constructor
	--@param x x position of the ComponentGroup
	--@param y y position of the ComponentGroup
	--@param bFont BitmapFont used to render the text of the component.
	--@param text Text that will be shown in the button
	--@param backgroundFalsePath path to the image that will be used as background when the radio button value is false
	--@param backgroundTruePath path to the image that will be used as background when the radio button value is true
	--@name RadioButton:new 
    function new_class:new(x, y, bFont, text, backgroundFalsePath, backgroundTruePath)
	
        	local temp = checkButton.CheckButton:new(x, y, bFont, text, backgroundFalsePath, backgroundTruePath)
		setmetatable( temp, class_mt );

		temp.isInRadioGroup = false;
        return temp;
    end

    if checkButton.CheckButton then
        setmetatable( new_class, { __index = checkButton.CheckButton } )
    end

    return new_class
end

RadioButton = inherit()

---Default action that is executed when the event "onEnter" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function RadioButton:onSelectDefaultAction ()
	self.value = true;
	--If it's located into a RadioButtoGroup, then it set to false the value of all the other components in the same parent.
	if (self.isInRadioGroup) then
		for index,component in ipairs(self.parent:getComponents()) do 
			if (not (component == self)) then
				component:setValue(false);
			end
		end
	end
end

---Determines if the RadioButton is into a RadioButtonGroup. It is set on true by the RadioButtonGroup when 
-- a RadioButton is added to it. If this parameter is true, when one RadioButton is set to true, all the others are set to false.
function RadioButton:setIsInRadioGroup (isInRadioGroup)
	self.isInRadioGroup = isInRadioGroup;
end

