local state = require("source.state.basic");
local levelholder = require("source.worker.levelholder");
local Slab = require("Slab");

local StateLevelPicker = state();

function StateLevelPicker:enter()
	if not self.data.initialised then
		self.data.options = {};

		self.data.options.window = {
			Title = "Adding levels",
			NoSavedSettings = true,
			ShowMinimize = false,
			ConstrainPosition = true
		};

		self.data.options.layout = {
			W = love.graphics.getWidth() / 2,
			AlignX = "center"
		};

		self.data.initialised = true;
	end

	self.data.options.window.IsOpen = true;
end

function StateLevelPicker:update(dt)
	Slab.BeginWindow("levelpicker.window", self.data.options.window);
	Slab.BeginLayout("levelpicker.layout", self.data.options.layout);

	Slab.NewLine();
	Slab.Textf("Drag and drop .rdlevel here");
	Slab.NewLine();

	Slab.Separator();
	Slab.Textf("or");
	Slab.Separator();

	Slab.NewLine(2);

	if Slab.Button("Add all from directory") then
		levelholder.addlevels();
	end

	Slab.NewLine();

	if Slab.Button("Open working directory") then
		levelholder.opendirectory();
	end

	Slab.NewLine();

	Slab.EndLayout();
	Slab.EndWindow();
end

function StateLevelPicker:getstateremovals(statemachine)
	if not self.data.options.window.IsOpen then
		return self.state;
	end

	return nil;
end

return StateLevelPicker;