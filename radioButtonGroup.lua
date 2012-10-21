--[[	
	LuaWidgets, a widgets library for Ginga.ar based applications.
Copyright (C) 2011, PLADEMA

	This file is part of LuaWidgets.

	LuaWidgets is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Ffunctionree Software Foundation, either version 3 of the License, or any later version.

	LuaWidgets is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
along with LuaWidgets.  If not, see <http://www.gnu.org/licenses/>.
]]--

---This module represents a RadioButton group. It is an special ComponentGroup which supports RadioButtons as components.
-- It has a special method called "getTrueIndex" which returns the ID of the RadioButton whose value is true.
module ('luawidgets.radioButtonGroup', package.seeall)

local componentGroup = require 'luawidgets.componentGroup';
local bitmapText = require'luawidgets.bitmapFonts.bitmapText'

--- Inherit function
--@see luawidgets.component
function inherit(  )
    local new_class = {}
    local class_mt = { __index = new_class }

	--- RadioButtonGroup Constructor.
	--@param x x position of the ComponentGroup
	--@param y y position of the ComponentGroup
	--@param w w dimension of the ComponentGroup
	--@param h h dimension of the ComponentGroup
    function new_class:new(x, y, w, h)
	
        	local temp = componentGroup.ComponentGroup:new(x, y, w, h)
		setmetatable( temp, class_mt );

        return temp
    end

    if componentGroup.ComponentGroup then
        setmetatable( new_class, { __index = componentGroup.ComponentGroup } )
    end

    return new_class
end

RadioButtonGroup = inherit()

---It returns the index of the RadioButtons that is set to true.
--@return The index of the RadioButtons that is set to true.
function RadioButtonGroup:getTrueIndex()
	for index,component in ipairs(self.components) do 
		if (component:getValue()) then
			return index;
		end
	end
end

---Adds a component to the RadioButtonGroup.
--@param component Component to add in the ComponentGroup
--@param order (Optional) the tab order. If it is not specified, it is inserted in the last place.
function RadioButtonGroup:addComponent (component, order)
	component:setIsInRadioGroup(true);

	-- Call the ComponentGroup "addComponent" method...
	componentGroup.ComponentGroup.addComponent(self, component, order);
end


