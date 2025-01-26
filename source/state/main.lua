local state = require("source.state.basic");
local levelholder = require("source.worker.levelholder");
local Slab = require("Slab");

local StateMenu = state();

function StateMenu:enter()
	if not self.data.initialised then
		self.data.options = {};

		self.data.options.window = {
			X = 0,
			Y = 0,
			W = love.graphics.getWidth(),
			H = love.graphics.getHeight(),
			AutoSizeWindow = false,
			AllowResize = false,
			AllowMove = false,
			NoOutline = true,
			Border = 10,
			AutoSizeContent = false,
			NoSavedSettings = true,
			ShowMinimize = false,
			ConstrainPosition = true,
			AllowFocus = false
		};

		self.data.title = love.window.getTitle();
		self.data.options.title = {
			W = love.graphics.getWidth(),
			Align = "center"
		};

		self.data.options.layout = {
			AlignX = "center"
		};

		self.data.initialised = true;
	end

	self.data.opendefaults = false;
	self.data.openlevels = false;
end

function StateMenu:update(dt)
	Slab.BeginWindow("menu.window", self.data.options.window);

	Slab.Textf(self.data.title, self.data.options.title);
	Slab.Separator();

	Slab.NewLine(4);

	Slab.BeginLayout("menu.layout", self.data.options.layout);

	if Slab.Button("Default options") then
		self.data.opendefaults = true;
	end

	Slab.NewLine(4);

	if Slab.Button("Choose levels") then
		self.data.openlevels = true;
	end

	Slab.NewLine(4);

	if Slab.Button("Merge") then
		levelholder.merge();
	end

	Slab.EndLayout();
	Slab.EndWindow();
end

function StateMenu:getstateadditions(statemachine)
	if self.data.openlevels then
		self.data.openlevels = false;
		return statemachine.constants.STATE_LEVELS;
	elseif self.data.opendefaults then
		self.data.opendefaults = false;

		local data = statemachine.getdata(statemachine.constants.STATE_OPTIONS);
		data.list = levelholder.defaultoptions;

		return statemachine.constants.STATE_OPTIONS;
	end

	return nil;
end

return StateMenu;