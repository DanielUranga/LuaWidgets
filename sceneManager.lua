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

---This module represents an EventManager, which can be
module ('luawidgets.sceneManager', package.seeall)

SceneManager = {
	guis = {};
	canvas = nil;
}

Class_Metatable = { __index = SceneManager }

---SceneManager constructor.
function SceneManager:new ()
	local temp = {};
	setmetatable ( temp, Class_Metatable );

    return temp;
end

---Adds a a guiScene to the manager
--@param guiScene a guiScene that will listen to the events
function SceneManager:addGuiScene (guiScene)
	table.insert(self.guis, guiScene);
--	print('::: Listener agregado. Cantidad actual: ' .. #self.guis);
end

---Sets a scene as "the current" scene
--@param guiScene the only scene that will be enabled after calling this method
function SceneManager:setCurrentScene (guiScene)
	habiaUnaEscena = false
	for _,gui in ipairs(self.guis) do
		if gui==guiScene then
			gui:setEnabled(true)
			habiaUnaEscena = true
		else
			gui:setEnabled(false)
		end
	end
	if habiaUnaEscena==false then
		print "No encontre la escena para ponerla como current"
	end
end

---Removes a listener from the manager
--@param guiScene the guiScene that will be removed
function SceneManager:removeListener (guiScene)
	self.guis[guiScene] = nil;
end

---It checks the events and communicates it to the enabled gui
--@param evt event to be checked
function SceneManager:checkEvents (evt)
--	print('::: Procesando eventos. Guis registrados: ' .. #self.guis);
	for _,gui in ipairs(self.guis) do
		if gui:getEnabled() then
			print('::: La gui va a procesar un evento');
			gui:processEvent(evt);
		end
	end

end

---It implements the main loop of a Scene.
--This method must be registered as an events' listener using "event.register(scnMgr:mainLoop)"
--function, being scnMgr the SceneManager of your application.
--@param evt event to be checked
function SceneManager:mainLoop(evt)
	-- Update the components as the event indicates
	self:checkEvents(evt);

	-- Clean the screen or redraw the background
	canvas:attrColor('black');
	canvas:clear();

	-- Redraw each active Gui

	for _,gui in ipairs(self.guis) do
		if gui:getEnabled() then
			gui:draw();
		end
	end

	--Refresh the screen
	canvas:flush();
	return false;
end

---It initializes the SceneManager registering the mainLoop method to listen the events. It is mandatory to run it once after setting up the SceneManager.
function SceneManager:init()
	event.register(function(evt) self:mainLoop(evt); return false; end);
end
