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

---This module represents a GuiScene, where different components can be added
module ('luawidgets.guiScene', package.seeall)
local componentGroup = require 'luawidgets.componentGroup';

GuiScene = {}
	--x = 0,
	--y = 0,
	--w = 0,
	--h = 0,
	--enabled = true,
	--visible = true,
	--background = nil,
	--backgroundPath = nil,
	--buttonListeners = {};
--}
--Class_Metatable = { __index = GuiScene }
GuiScene.__index = GuiScene

---GuiScene constructor.
--@param x x position of the GuiScene
--@param y y position of the GuiScene
--@param w w Width of the GuiScene
--@param h h Height of the GuiScene
function GuiScene:new (x, y, w, h)
	local temp = {};
	--setmetatable ( temp, Class_Metatable );
	setmetatable ( temp, GuiScene );

	temp.x = x
	temp.y = y
	temp.h = h
	temp.w = w
	temp.enabled = true
	temp.visible = true
	temp.background = nil
	temp.backgroundPath = nil
	temp.buttonListeners = {}

	--Those varialbes contains the active components list and tab order.
        --It can be changed to navigate over different contexts of tabOrder, as CheckButton grups

	temp.rootComponentGroup = componentGroup.ComponentGroup:new(x, y, w, h)
	temp.componentGroupStack = {}
	temp.activeComponentGroup = temp.rootComponentGroup
	--temp.activeTabOrder = components:getTabOrder();

	print ("el nuevo va a ser: " .. tostring(temp))

    return temp;
end

---Adds a component to the GuiScene.
--@param component Component to add in the GuiScene
--@param order (Optional) the tab order. If it is not specified, it is inserted in the last place.
function GuiScene:addComponent (component, order)
	-- Set itself as the associated GuiScene
	component:setGuiScene(self);

	if (#(self.rootComponentGroup:getComponents()) == 0) then
		component:setFocus(true);
	end
	-- Add the component to the root component group
	self.rootComponentGroup:addComponent(component, order);

end

---Draws the scene on the global canvas
function GuiScene:draw()
	if self.background then
		canvas:compose(self.x, self.y, self.background)
	end

	self.rootComponentGroup:draw();
end

---It takes an event and communicates it to the components
--@param evt Event to be processed
function GuiScene:processEvent(evt)
	print("Clase de evento: " .. evt.class)
	if evt.class == 'key' and evt.type == 'press' then
		if evt.key=='CURSOR_LEFT' then
			self.activeComponentGroup:getActiveComponent():onLeftDefaultAction();
			self.activeComponentGroup:onLeftDefaultAction();
			--self.activeComponentGroup:execOnEnterAction();
		elseif evt.key=='CURSOR_RIGHT' then
			print("On right");
			self.activeComponentGroup:getActiveComponent():onRightDefaultAction();
		elseif evt.key=='CURSOR_UP' then
			self.activeComponentGroup:getActiveComponent():onExitDefaultAction();
			self.activeComponentGroup:getActiveComponent():execOnExitAction();
			self.activeComponentGroup:decTabOrder();
			self.activeComponentGroup:getActiveComponent():onEnterDefaultAction();
			self.activeComponentGroup:getActiveComponent():execOnEnterAction();
		elseif evt.key=='CURSOR_DOWN' then
			self.activeComponentGroup:getActiveComponent():onExitDefaultAction();
			self.activeComponentGroup:getActiveComponent():execOnExitAction();
			self.activeComponentGroup:incTabOrder();
			self.activeComponentGroup:getActiveComponent():onEnterDefaultAction();
			self.activeComponentGroup:getActiveComponent():execOnEnterAction();
		elseif (evt.key=='ENTER' or evt.key =='OK') then
			self.activeComponentGroup:getActiveComponent():onSelectDefaultAction();
			self.activeComponentGroup:getActiveComponent():execOnSelectAction();
		elseif (evt.key=='RED') or (evt.key=='GREEN') or (evt.key=='BLUE') or (evt.key=='YELLOW') or (evt.key=="F1") or (evt.key=="F2") or (evt.key=="F3") or (evt.key=="F4") then
			if (self.buttonListeners[evt.key]) then
				self.buttonListeners[evt.key]();
			end
		elseif (evt.key=="1") or (evt.key=="2") or (evt.key=="3") or (evt.key=="4") or (evt.key=="5") or (evt.key=="6") or (evt.key=="7") or (evt.key=="8") or (evt.key=="9") or (evt.key=="0") then
			if (self.activeComponentGroup:getActiveComponent()) then
				self.activeComponentGroup:getActiveComponent():onNumberPressed(evt.key)
			end
		end
	end
end

---Returns the visible value
--@return Visible value
function GuiScene:getVisible()
	return self.visible;
end

---Returns the enabled value
--@return enabled value
function GuiScene:getEnabled()
	return self.enabled;
end

---Sets the enalbed value
--@param enabled Enabled new value
function GuiScene:setEnabled(enabled)
	self.enabled = enabled;
end

---Sets the visible value
--@param visible Visible new value
function GuiScene:setVisible(visible)
	self.visible = visible;
end

---Adds button action
--@param button Button that triggers the event
--@param action Function to be excecuted when the button has been pressed
function GuiScene:addButtonAction(button, action)
	-- "RED"	=	"F1"
	-- "GREEN"	=	"F2"
	-- "YELLOW" =	"F3"
	-- "BLUE"	=	"F4"
	if(button=="RED")			then	button = "F1" --self.buttonListeners["F1"]=action
	elseif(button=="GREEN")		then	button = "F2" --self.buttonListeners["F2"]=action
	elseif(button=="YELLOW")	then	button = "F3" --self.buttonListeners["F3"]=action
	elseif(button=="BLUE")		then	button = "F4" --self.buttonListeners["F4"]=action
	end

	self.buttonListeners[button] = action;

	print("a la escena " .. tostring(self) .. "le agrego la accion " .. tostring(action))

end

---Returns the image background
--@return The GuiScene background
function GuiScene:getBackground ()
	return self.background;
end

---Sets the image background
--@param bp The path to the new background
function GuiScene:setBackgroundPath (bp)
	self.backgroundPath = bp;
	self.background = canvas:new(bp);
end

---Changes the actual component group and save the actual one in a stack to return to it. Before doing it, it executes the onExitAction of the last focused component.
--@param bp The path to the new background
function GuiScene:changeActiveComponentGroup (compGroup)
	-- It executes the onExitAction of the last focused component.
	self.activeComponentGroup:getActiveComponent():onExitDefaultAction();
	-- Change the active ComponentGroup
	self.activeComponentGroup = compGroup;
	-- Excecute the activeComponentGroup's onEnterAction to set the focus to the component into the new activeGroup
	self.activeComponentGroup:getActiveComponent():onEnterDefaultAction();
end



