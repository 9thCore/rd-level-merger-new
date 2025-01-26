local basic = require("source.worker.options.basic");
local range = require("source.range");
local util = require("source.util");
local Slab = require("Slab");

local strip_metadata = basic:new{};

function strip_metadata:init()
	self.data.options = {};

	self.data.options.title = {
		W = love.graphics.getWidth(),
		Align = "center"
	};
end

function strip_metadata:apply(leveldata)
	local newdata = {};

	newdata = util.deepcopy(leveldata);
	newdata.settings = {};

	return newdata;
end

function strip_metadata:update(dt)
	Slab.Textf("Strip Metadata", self.data.options.title);

	Slab.Text("Remove metadata from a level.");
end

function strip_metadata:copy()
	local copy = strip_metadata:new();
	copy:init();
	return copy;
end

return strip_metadata;