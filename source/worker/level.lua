local level = {
	data = nil,
	name = nil
};

function level:new(data, name)
	local lvl = {
		data = data,
		name = name
	};

	setmetatable(lvl, self);
	self.__index = self;
	return lvl;
end

return level;