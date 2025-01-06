local StateBasic = require("source.state.basic");
local Slab = require("Slab");

local StateMenu = StateBasic:new{};

function StateMenu:enter(statemachine)
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
			AutoSizeContent = false
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
end

function StateMenu:update(statemachine, dt)
	Slab.BeginWindow("menu.window", self.data.options.window);

	Slab.Textf(self.data.title, self.data.options.title);
	Slab.Separator();

	Slab.BeginLayout("menu.layout", self.data.options.layout);

	if Slab.Button("Choose levels") then
		
	end

	Slab.EndLayout();
	Slab.EndWindow();
end

return StateMenu;