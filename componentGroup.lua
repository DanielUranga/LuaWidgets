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

---This module represents a component group which can be shown in a GUIScene. A Component Group is a container for Components. Each the component's position is relative to the ComponentGroup's position
module ('luawidgets.componentGroup', package.seeall)
local component = require 'luawidgets.component';

--- Inherit function
--@see luawidgets.component
function inherit(  )
    local new_class = {}
    local class_mt = { __index = new_class }
	
	--- ComponentGroup Constructor
	--@param x x position of the ComponentGroup
	--@param y y position of the ComponentGroup
	--@param w w dimension of the ComponentGroup
	--@param h h dimension of the ComponentGroup
	--@name ComponentGroup:new 
    function new_class:new(x, y, w, h)
        	local temp = component.Component:new(x,y);
		setmetatable( temp, class_mt );

		temp.w = w;
		temp.h = h;
		temp.enabled = true;
		temp.tabOrder = 1;
		temp.components = {};
		temp.onFocusColor = 'red';
        return temp
    end

    if component.Component then
        setmetatable( new_class, { __index = component.Component } )
    end

    return new_class
end

ComponentGroup = inherit()

---Adds a component to the ComponentGroup constructor.
--@param component Component to be added in the ComponentGroup
--@param order (Optional) the tab order. If it is not specified, it is inserted in the last place.
function ComponentGroup:addComponent (component, order)
	component:setParent(self);

	if (order) then
		table.insert(self.components, order, component);
	else
		table.insert(self.components, component);
	end
end

---Sets the tab order to a given component. THIS FUNCTION IS NOT IMPLEMENTED
--@param component Component to add in the GuiScene
--@param order the new tab order
function ComponentGroup:setTabOrder (component, order)
	-- TO DO
end

---Draws the ComponentGroup on the global canvas
function ComponentGroup:draw()
	-- Draw each component into the ComponentGroup
	for index,component in ipairs(self.components) do 
		if (component:getVisible()) then
			component:draw();
		end
	end

	local xOffset = 0;
	local yOffset = 0; 

	if (self.parent) then
		xOffset = self.parent:getX();
		yOffset = self.parent:getY();
	end

	-- Adds the focus part..
	if (self.focus) then
		canvas:attrColor(self.onFocusColor);
		canvas:drawRect('frame', self.x + xOffset, self.y + yOffset, self.w, self.h);
	end
end

---Returns the components that are into the ComponentGroup
--@return A table with the group components
function ComponentGroup:getComponents()
	return self.components;
end

---Returns the actual tab order
--@return the actual tab order
function ComponentGroup:getTabOrder()
	return self.tabOrder;
end

---It increments in a ciclyc way the tabOrder variable to change the focus
--between the group components. If the component isn't enabled, it can't recive the focus.
function ComponentGroup:incTabOrder()
	local initialTabOrder = self.tabOrder;

	repeat
		self.tabOrder = self.tabOrder + 1;
		if self.tabOrder > #(self.components) then
			self.tabOrder = 1;
		end
	until (self.components[self.tabOrder]:getEnabled() or initialTabOrder == self.tabOrder	)
end

---It decrements in a ciclyc way the tabOrder variable to change the focus
--between the group components. If a component is not enabled, it can't recive the focus
function ComponentGroup:decTabOrder()
	local initialTabOrder = self.tabOrder;

	repeat
		self.tabOrder = self.tabOrder - 1;
		if self.tabOrder < 1 then
			self.tabOrder = #(self.components);
		end
	until (self.components[self.tabOrder]:getEnabled() or initialTabOrder == self.tabOrder)
end

---It returns the component that is active in the group
function ComponentGroup:getActiveComponent()
	return self.components[self.tabOrder];
end

---Default action that is executed when the event "onEnter" occurs. It sets the component's focus to true.
function ComponentGroup:onEnterDefaultAction ()
	self.focus = true;
end

---Default action that is executed when the event "onExit" occurs. It sets the component's focus to false.
function ComponentGroup:onExitDefaultAction ()
	self.focus = false;
end

---Default action that is executed when the Right key is pressed. This component sets itself as the activeComponentGroup in the associated GuiScene.
function ComponentGroup:onRightDefaultAction ()
	self.associatedGuiScene:changeActiveComponentGroup(self);
end

---Default action that is executed when the Left key is pressed. This component sets its parent (if it has one) as the activeComponentGroup in the associated GuiScene.
function ComponentGroup:onLeftDefaultAction ()
	-- If it isn't the rootComponentGroup of the GuiScene...
	if (self.parent) then
		self.associatedGuiScene:changeActiveComponentGroup(self.parent);
	end
end

---Sets the onFocusColor that will be used to render the focus rectangle
--@param ofc The new color that will be used to render the focus rectangle
function ComponentGroup:setOnFocusColor (ofc)
	self.onFocusColor = ofc;
end
