local level = {
	data = nil,
	name = nil,
	options = nil
};

function level:new(data, name)
	local lvl = {
		data = data,
		name = name,
		options = {}
	};

	setmetatable(lvl, self);
	self.__index = self;
	return lvl;
end

function level:apply()
	local data = self.data;

	for _, option in ipairs(self.options) do
		data = option:apply(data);
	end

	return data;
end

return level;