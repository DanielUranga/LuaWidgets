module ('luawidgets.numberEntry', package.seeall)

local component = require 'luawidgets.component';
local bitmapText = require'luawidgets.bitmapFonts.bitmapText'

function inherit(  )
    local new_class = {}
    local class_mt = { __index = new_class }

	--- NumberEntry constructor
	--@param x x position of the object
	--@param y y position of the object
	--@param bFont BitmapFont used to render the text of the component.
	--@name NumberEntry:new
    function new_class:new(x, y, bFont)

			local temp = component.Component:new(x, y, bFont);
		setmetatable( temp, class_mt );
		temp.enabled = true;
		temp.onFocusColor = "red";
		temp.text = "20";
        return temp
    end

    if component.Component then
        setmetatable( new_class, { __index = component.Component } )
    end

    return new_class
end

NumberEntry = inherit()

---Sets the text to the label.
--@param text Text
function NumberEntry:setText(text)
	self.text = text;
end

---Returns the text to the label.
--@return Text
function NumberEntry:getText()
	return self.text;
end

---Default action that is executed when the event "onEnter" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function NumberEntry:onEnterDefaultAction ()
	self.focus = true;
end

---Default action that is executed when the event "onExit" occurs. This abstract method could be implemented by all the classes that ihnerit from Component.
function NumberEntry:onExitDefaultAction ()
	self.focus = false;
end

---Sets the enalbed value. If an object is enabled, then it can be focused.
--@param enabled Enabled new value
function NumberEntry:setEnabled (enabled)
	self.enabled = enabled;
end

---Decrement action
function NumberEntry:onLeftDefaultAction ()
	--self.text = tostring(tonumber(self.text)-1);
	--self.text = tostring(math.floor(tonumber(self.text)/10));
	self.text = tostring(tonumber(self.text)-1);
	self:prerender(self);
	return 0;
end

---Increment action
function NumberEntry:onRightDefaultAction ()
	--self.text = tostring(tonumber(self.text)+1);
	--self.text = tostring(math.floor(tonumber(self.text)/10));
	self.text = tostring(tonumber(self.text)+1);
	self:prerender(self);
	return 0;
end

---Draw
function NumberEntry:draw()
	local xOffset = 0;
	local yOffset = 0;

	if (self.parent) then
		xOffset = self.parent:getX();
		yOffset = self.parent:getY();
	end

	if (self.image) then
		canvas:compose(self.x + xOffset, self.y + yOffset, self.image);
	end

	-- Adds the focus part..
	if (self.focus) then
		canvas:attrColor(self.onFocusColor);
		local sizeW, sizeH = self.image:attrSize();
		canvas:drawRect('frame', self.x + xOffset, self.y + yOffset, sizeW, sizeH);
	end

end

function NumberEntry:onNumberPressed (n)
	self.text = tostring(tonumber(self.text)*10+n);
	self:prerender(self);
end

---Renders the component generating the appropriate image and saving it into the Component state.
---When the component will be drawn using "draw" method, this image will be painted over the given canvas.
function NumberEntry:prerender()
	-- Create the bitmap text
	local bText = bitmapText.BitmapText:new(self.text, self.bitmapFont, nil)
	-- Center the text
	bText:centerText();
	-- Save the image
	self.image = bText:getImage();
	-- Update the dimensions
	self.w, self.h = self.image:attrSize();
end
