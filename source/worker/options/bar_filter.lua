local basic = require("source.worker.options.basic");
local range = require("source.range");
local util = require("source.util");
local Slab = require("Slab");

local bar_filter = basic:new{
	range = nil
};

function bar_filter:init()
	self.range = range:new();

	self.range:setstart(1);
	self.range:prepareoptions({
		MinNumber = 1
	}, {
		MinNumber = 1
	});

	self.data.options = {};

	self.data.options.title = {
		W = love.graphics.getWidth(),
		Align = "center"
	};

	self.data.options.layout = {
		Columns = 2,
		AlignX = "center"
	};

	self.data.filterchoices = {
		"Keep",
		"Remove"
	};

	self.data.options.combobox = {
		Selected = "Keep"
	};
end

function bar_filter:apply(leveldata)
	local newdata = {};

	newdata.bookmarks = util.deepcopy(leveldata.bookmarks);
	newdata.conditionals = util.deepcopy(leveldata.conditionals);
	newdata.settings = util.deepcopy(leveldata.settings);
	newdata.decorations = util.deepcopy(leveldata.decorations);
	newdata.rows = util.deepcopy(leveldata.rows);

	newdata.events = {};
	for _, event in ipairs(leveldata.events) do
		if self.data.options.combobox.Selected == "Keep" and event.bar >= self.range:getstart() and event.bar <= self.range:getend() then
			table.insert(newdata.events, event);
		elseif self.data.options.combobox.Selected == "Remove" and (event.bar < self.range:getstart() or event.bar > self.range:getend()) then
			table.insert(newdata.events, event);
		end
	end

	return newdata;
end

function bar_filter:update(dt)
	Slab.Textf("Bar Filter", self.data.options.title);

	Slab.Text("Keep or remove all events in the specified bars (range)");

	Slab.BeginLayout(self:getid("barfilter.layout."), self.data.options.layout);

	Slab.SetLayoutColumn(1);
	util.slabtext("Mode");

	Slab.SetLayoutColumn(2);
	if Slab.BeginComboBox(self:getid("barfilter.mode."), self.data.options.combobox) then
		for _, v in ipairs(self.data.filterchoices) do
			if Slab.TextSelectable(v) then
				self.data.options.combobox.Selected = v;
			end
		end

		Slab.EndComboBox()
	end

	Slab.EndLayout();

	self.range:update(self:getid("barfilter.range."), dt);
end

function bar_filter:copy()
	local copy = bar_filter:new();
	copy:init();
	copy.range:setstart(self.range:getstart());
	copy.range:setlength(self.range:getlength());
	copy.data.options.combobox.Selected = self.data.options.combobox.Selected;
	return copy;
end

return bar_filter;