-- Global ID used for Slab control IDs
local id = 0;

local option = {
	id = nil
};

function option:new(o)
	o = o or {
		data = {}
	};
	setmetatable(o, self);
	self.__index = self;

	o.id = id;
	id = id + 1;

	return o;
end

function option:init(...)
	-- Generic initialisation method.
	-- Expected to be overwritten by child classes,
	--  and called with the appropriate parameters
	--  by code constructing this option.
end

function option:apply(leveldata)
	-- Callback called when the option should be applied.
	-- Returns another level data, ideally also doesn't modify
	--  the passed data.
	-- Can return the same if not changed, as
	--  code calling this won't be changing it further.
	-- This will be merged into the final result.

	return leveldata;
end

function option:update(dt)
	-- Callback every frame while this option is selected.
	-- Expected to draw the GUI here.
	-- Starting a window here is not advised,
	--  as it would be called inside of a window already.
end

function option:getid(common)
	-- Helper method to get the correct ID for a Slab control.
	-- Uses the option's associated global ID.

	return common .. self.id;
end

function option:copy()
	return {};
end

return option;