module ('luawidgets.image', package.seeall)

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
    function new_class:new(x, y, imagePath)

			local temp = component.Component:new(x, y, nil);
		setmetatable( temp, class_mt );
		temp.enabled = false;
		temp.image = canvas:new(imagePath);
		temp.w, temp.h = temp.image:attrSize();
        return temp;
    end

    if component.Component then
        setmetatable( new_class, { __index = component.Component } )
    end

    return new_class
end

Image = inherit()

---Draw
function Image:draw()
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
