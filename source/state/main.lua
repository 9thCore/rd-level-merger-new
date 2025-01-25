local state = require("source.state.basic");
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

	self.data.openlevels = false;
end

function StateMenu:update(dt)
	Slab.BeginWindow("menu.window", self.data.options.window);

	Slab.Textf(self.data.title, self.data.options.title);
	Slab.Separator();

	Slab.NewLine(8);

	Slab.BeginLayout("menu.layout", self.data.options.layout);

	if Slab.Button("Choose levels") then
		self.data.openlevels = true;
	end

	Slab.EndLayout();
	Slab.EndWindow();
end

function StateMenu:getstateadditions(statemachine)
	if self.data.openlevels then
		self.data.openlevels = false;
		return statemachine.constants.STATE_LEVELS;
	end

	return nil;
end

return StateMenu;