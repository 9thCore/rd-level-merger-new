local Color = {1, 1, 1, 1};

function Color:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function Color:r(value)
	if value == nil then
		return self[1];
	end;
	
	self[1] = value;
end

function Color:g(value)
	if value == nil then
		return self[2];
	end;
	
	self[2] = value;
end

function Color:b(value)
	if value == nil then
		return self[3];
	end;
	
	self[3] = value;
end

function Color:a(value)
	if value == nil then
		return self[4];
	end;
	
	self[4] = value;
end

function Color:apply()
	love.graphics.setColor(self:r(), self:g(), self:b(), self:a());
end

Color.White = Color:new{};
Color.Black = Color:new{0, 0, 0};
Color.Red = Color:new{1, 0, 0};
Color.Green = Color:new{0, 1, 0};
Color.Blue = Color:new{0, 0, 1};

return Color;