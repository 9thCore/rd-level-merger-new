local state = require("source.state.basic");
local Slab = require("Slab");

local alloptions = {
	{
		name = "Bar Filter",
		desc = "Keeps or filters out events in a given bar range.",
		class = require("source.worker.options.bar_filter"),
		init = function(object)
			object:init();
		end
	}
};

local StateOptionPicker = state();

function StateOptionPicker:enter(data)
	if not self.data.initialised then
		self.data.options = {};

		self.data.options.window = {
			Title = "Option Picker",
			W = love.graphics.getWidth() * 0.75,
			AutoSizeWindow = false,
			NoSavedSettings = true,
			ShowMinimize = false,
			ConstrainPosition = true
		};

		self.data.options.layout = {
			AlignX = "center",
			Columns = 2
		};

		self.data.initialised = true;
	end

	self.data.options.window.IsOpen = true;
	self.data.external = data.list;
end

function StateOptionPicker:update(dt)
	Slab.BeginWindow("optionpicker.window", self.data.options.window);
	Slab.BeginLayout("optionpicker.layout", self.data.options.layout);

	for _, option in ipairs(alloptions) do
		Slab.SetLayoutColumn(1);
		
		if Slab.Button(option.name) then
			local obj = option.class:new();
			obj:init();
			table.insert(self.data.external, obj);
		end

		Slab.SetLayoutColumn(2);
		Slab.Text(option.desc);
	end

	Slab.EndLayout();
	Slab.EndWindow();
end

function StateOptionPicker:getstateremovals(statemachine)
	if not self.data.options.window.IsOpen then
		return self.state;
	end

	return nil;
end

return StateOptionPicker;