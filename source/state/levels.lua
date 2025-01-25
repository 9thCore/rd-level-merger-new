local state = require("source.state.basic");
local levelholder = require("source.worker.levelholder");
local Slab = require("Slab");

local StateLevels = state();

local constants = {
	CONFIRMATION_NONE = 0,
	CONFIRMATION_REMOVE_ONE = 1,
	CONFIRMATION_REMOVE_ALL = 2
}

function StateLevels:enter()
	if not self.data.initialised then
		self.data.options = {};

		self.data.options.window = {
			Title = "Levels",
			X = 0,
			Y = 48,
			W = love.graphics.getWidth(),
			H = love.graphics.getHeight() - 48,
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

		self.data.options.layout = {
			Columns = 3,
			AlignX = "center"
		};

		self.data.options.levelname = {
			Align = "center"
		};

		self.data.options.confirmation = {
			Buttons = {"Yes", "No"}
		};

		self.data.initialised = true;
	end

	self.data.options.window.IsOpen = true;
	self.data.openpicker = false;

	self.data.confirmation = {
		type = constants.CONFIRMATION_NONE,
		index = 0
	};
end

function StateLevels:update(dt)
	Slab.BeginWindow("level.window", self.data.options.window);
	Slab.BeginLayout("level.layout", self.data.options.layout);

	local i = 1;
	while i <= #levelholder.levels do
		local level = levelholder.levels[i];

		Slab.SetLayoutColumn(1);
		Slab.Text(level.name, self.data.options.levelname);

		Slab.SetLayoutColumn(2);
		if Slab.Button("Options") then
			-- Options
		end

		Slab.SetLayoutColumn(3);
		if Slab.Button("Remove") then
			-- if shift then
			--     remove immediately
			-- else
			self.data.confirmation.type = constants.CONFIRMATION_REMOVE_ONE;
			self.data.confirmation.index = i;
		else
			i = i + 1;
		end
	end

	Slab.SetLayoutColumn(1);
	if Slab.Button("+") then
		self.data.openpicker = true;
	end

	-- Fill column with garbage, invisible data
	--  because otherwise it isn't there ??
	Slab.SetLayoutColumn(2);
	Slab.Text("");

	Slab.SetLayoutColumn(3);
	if Slab.Button("Remove all") then
		-- if shift then
		--     remove immediately
		-- else
		self.data.confirmation.type = constants.CONFIRMATION_REMOVE_ALL;
	end

	if self.data.confirmation.type == constants.CONFIRMATION_REMOVE_ONE then
		local choice = Slab.MessageBox("Remove", "Remove this level?", self.data.options.confirmation);

		if choice == "Yes" then
			levelholder.remove(self.data.confirmation.index);
		end

		if choice ~= "" then
			self.data.confirmation.type = constants.CONFIRMATION_NONE;
		end
	elseif self.data.confirmation.type == constants.CONFIRMATION_REMOVE_ALL then
		local choice = Slab.MessageBox("Remove", "Remove all levels?", self.data.options.confirmation);

		if choice == "Yes" then
			levelholder.removeall();
		end

		if choice ~= "" then
			self.data.confirmation.type = constants.CONFIRMATION_NONE;
		end
	end

	Slab.EndLayout();
	Slab.EndWindow();
end

function StateLevels:getstateadditions(statemachine)
	if self.data.openpicker then
		self.data.openpicker = false;
		return statemachine.constants.STATE_LEVEL_PICKER;
	end

	return nil;
end

function StateLevels:getstateremovals(statemachine)
	if not self.data.options.window.IsOpen then
		return self.state;
	end

	return nil;
end

return StateLevels;