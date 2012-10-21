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

---This module represents a generic component which can be shown in a GUIScene.
module ('luawidgets.component', package.seeall)

Component = {
	x = 0,
	y = 0,
	w = 0,
	h = 0,
	focus = false,
	enabled = true,
	visible = true,
	onEnterAction = nil,
	onSelectAction = nil,
	onRedAction = nil,
	onBlueAction = nil,
	onGreenAction = nil,
	onYellowAction = nil,
	onExitAction = nil,
	background = nil,
	backgroundPath = nil,
	image = nil,
	bitmapFont = nil,

	parent = nil,
	associatedGuiScene = nil
}
Class_Metatable = { __index = Component }

---Component constructor.
--@param x x position of the object
--@param y y position of the object
--@param bFont BitmapFont used to render the text of the component.
function Component:new (x, y, bFont)
	local temp = {};
	setmetatable ( temp, Class_Metatable );

	temp.x = x;
	temp.y = y;
	temp.bitmapFont = bFont;
	onExitAction = nil;
	onSelectAction = nil;
	onExitAction = nil;
    return temp;
end

--========== Setters ==========

---Sets the focus value
--@param focus Focus new value
function Component:setFocus (focus)
	self.focus = focus;
end

---Sets the enalbed value
--@param enabled Enabled new value
function Component:setEnabled (enabled)
	self.enabled = enabled;
end

---Sets the visible value
--@param visible Visible new value
function Component:setVisible (visible)
	self.visible = visible;
end

---Sets the X value
--@param x X new value
function Component:setX (x)
	self.x = x;
end

---Sets the Y value
--@param y Y new value
function Component:setY (y)
	self.y = y;
end

---Sets the Width value
--@param w Width new value
function Component:setWidth (w)
	self.w = w;
end

---Sets the Height value
--@param h Height new value
function Component:setHeight (h)
	self.h = h;
end

---Sets the onEnterAction value. It must be a function with one parameter "component". When the function is called,
--the parameter "component" contains the component on which the event has ocurred.
--@param onEnterAction Y new value
function Component:setOnEnterAction (onEnterAction)
	self.onEnterAction = onEnterAction;
end

---Sets the onSelectAction value. It must be a function with one parameter "component". When the function is called,
--the parameter "component" contains the component on which the event has ocurred.
--@param onSelectAction onSelectAction new value
function Component:setOnSelectAction (onSelectAction)
	self.onSelectAction = onSelectAction;
end

---Sets the onExitAction value. It must be a function with one parameter "component". When the function is called,
--the parameter "component" contains the component on which the event has ocurred.
--@param onExitAction onExitAction new value
function Component:setOnExitAction (onExitAction)
	self.onExitAction = onExitAction;
end

---Sets the image background
--@param bp The path to the new background
function Component:setBackgroundPath (bp)
	self.backgroundPath = bp;
	self.background = canvas:new(bp);
end

---Sets the bitmap font that will be used to render the text in the widget
--@param b Background new value
function Component:setBitmapFont (bFont)
	self.bitmapFont = bFont;
end

---Sets the ComponentGroup parent
--@param parent The component group where is located this component
function Component:setParent (parent)
	self.parent = parent;
end

---Sets the Associated GuiScene where the component is drawn
--@param gScene The GuiScene where is located this component
function Component:setGuiScene (gScene)
	self.associatedGuiScene = gScene;
end

--========== Getters ==========

---Returns the focus value
--@return Focus value
function Component:getFocus ()
	return self.focus;
end

---Returns the enabled value
--@return enabled value
function Component:getEnabled ()
	return self.enabled;
end

---Returns the visible value
--@return visible value
function Component:getVisible ()
	return self.visible;
end

---Returns the x value
--@return x value
function Component:getX ()
	return self.x;
end

---Returns the y value
--@return y value
function Component:getY ()
	return self.y;
end

---Returns the Width value
--@return Width value
function Component:getWidth ()
	return self.w;
end

---Returns the Height value
--@return Height value
function Component:getHeight ()
	return self.h;
end

---Returns the BackgroundPath value
--@return BackgroundPath value
function Component:getBackgroundPath()
	return self.backgroundPath;
end

---Returns the image background
--@return BackgroundPath value
function Component:getBackground()
	return self.background;
end

---Returns the prerendered image
--@return BackgroundPath value
function Component:getImage()
	return self.image;
end

---Returns the bitmap font used to render the component
--@return the asscociated bitmap font
function Component:getBitmapFont()
	return self.bitmapFont;
end

---Returns the onEnterAction function
--@return onEnterAction the onSelectAction function
function Component:getOnEnterAction ()
	return self.onEnterAction;
end

---Returns the onSelectAction function
--@return onSelectAction the onSelectAction function
function Component:getOnSelectAction ()
	return self.onSelectAction;
end

---Returns the onExitAction function
--@return onExitAction the onExitAction function
function Component:getOnExitAction ()
	return self.onExitAction;
end

---Executes the onExitAction if it has been set.
function Component:execOnEnterAction ()
	if self.onEnterAction then
		self.onEnterAction(self);
	end
end

---Executes the onExitAction if it has been set.
function Component:execOnSelectAction ()
	if self.onSelectAction then
		self.onSelectAction(self);
	end
end

---Executes the onExitAction if it has been set.
function Component:execOnExitAction ()
	if (self.onExitAction) then
		self.onExitAction(self);
	end
end

---Returns the parent ComponentGroup, where the component is located
--@return The component group where is located this component
function Component:getParent ()
	return self.parent;
end

---Returns the Associated GuiScene where the component is drawn
--@return The GuiScene where is located this component
function Component:getGuiScene (gScene)
	return self.associatedGuiScene;
end

--========== Abstract methods ==========

---Draws the component in the canvas. This abstract method must be implemented by all the classes that ihnerit from Component.
function Component:draw ()
	return 0;
end

---Renders the component generating the appropriate image and saving it into the Component state. When the component will be drawn using "draw" method, this image will be painted over the given canvas.
function Component:prerender()
	return 0;
end

---Default action that is executed when the event "onEnter" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function Component:onEnterDefaultAction ()
	return 0;
end

---Default action that is executed when the event "onSelect" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function Component:onSelectDefaultAction ()
	return 0;
end

---Default action that is executed when the event "onExit" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function Component:onExitDefaultAction ()
	return 0;
end

---Default action that is executed when the event left key is pressed over this component. This abstract method could be implemented by all the classes that ihnerit from Component.
function Component:onLeftDefaultAction ()
	return 0;
end

---Default action that is executed when the event right key is pressed over this component. This abstract method could be implemented by all the classes that ihnerit from Component.
function Component:onRightDefaultAction ()
	return 0;
end

function Component:onNumberPressed (n)
	print (n)
end
