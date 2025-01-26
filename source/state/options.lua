local state = require("source.state.basic");
local Slab = require("Slab");

local StateOptions = state();

local constants = {
	CONFIRMATION_NONE = 0,
	CONFIRMATION_REMOVE_ONE = 1,
	CONFIRMATION_REMOVE_ALL = 2
}

function StateOptions:enter(data)
	if not self.data.initialised then
		self.data.options = {};

		self.data.options.window = {
			Title = "Options",
			X = 0,
			Y = 48,
			W = love.graphics.getWidth(),
			H = love.graphics.getHeight() - 48,
			AutoSizeWindow = false,
			AllowResize = false,
			AllowMove = false,
			NoOutline = true,
			Border = 10,
			NoSavedSettings = true,
			ShowMinimize = false,
			ConstrainPosition = true,
			AllowFocus = false
		};

		self.data.options.confirmation = {
			Buttons = {"Yes", "No"}
		};

		self.data.options.layout = {
			Columns = 3,
			AlignX = "center"
		};

		self.data.options.removelayout = {
			AlignX = "right"
		};

		self.data.initialised = true;
	end

	self.data.options.window.IsOpen = true;
	self.data.external = data.list;

	self.data.openpicker = false;
	self.data.confirmation = {
		type = constants.CONFIRMATION_NONE,
		index = 0
	};
end

function StateOptions:update(dt)
	Slab.BeginWindow("options.window", self.data.options.window);

	local i = 1;
	while i <= #self.data.external do
		local option = self.data.external[i];

		Slab.Separator();
		option:update(dt);

		Slab.BeginLayout("options.removelayout", self.data.options.removelayout);

		if Slab.Button("Remove") then
			if Slab.IsKeyDown("lshift") or Slab.IsKeyDown("rshift") then
				table.remove(self.data.external, i);
			else
				self.data.confirmation.type = constants.CONFIRMATION_REMOVE_ONE;
				self.data.confirmation.index = i;
				i = i + 1;
			end
		else
			i = i + 1;
		end

		Slab.EndLayout();
		Slab.Separator();
	end

	Slab.BeginLayout("options.layout", self.data.options.layout);

	Slab.SetLayoutColumn(1);
	if Slab.Button("+") then
		self.data.openpicker = true;
	end

	Slab.SetLayoutColumn(2);
	Slab.Text("");

	Slab.SetLayoutColumn(3);
	if Slab.Button("Remove all") then
		if Slab.IsKeyDown("lshift") or Slab.IsKeyDown("rshift") then
			for k, _ in ipairs(self.data.external) do
				self.data.external[k] = nil
			end
		else
			self.data.confirmation.type = constants.CONFIRMATION_REMOVE_ALL;
		end
	end

	Slab.EndLayout();
	Slab.EndWindow();

	if self.data.confirmation.type == constants.CONFIRMATION_REMOVE_ONE then
		local choice = Slab.MessageBox("Remove", "Remove this option?", self.data.options.confirmation);

		if choice == "Yes" then
			table.remove(self.data.external, self.data.confirmation.index);
		end

		if choice ~= "" then
			self.data.confirmation.type = constants.CONFIRMATION_NONE;
		end
	elseif self.data.confirmation.type == constants.CONFIRMATION_REMOVE_ALL then
		local choice = Slab.MessageBox("Remove", "Remove all options?", self.data.options.confirmation);

		if choice == "Yes" then
			for k, _ in ipairs(self.data.external) do
				self.data.external[k] = nil
			end
		end

		if choice ~= "" then
			self.data.confirmation.type = constants.CONFIRMATION_NONE;
		end
	end
end

function StateOptions:getstateadditions(statemachine)
	if self.data.openpicker then
		self.data.openpicker = false;

		local data = statemachine.getdata(statemachine.constants.STATE_OPTION_PICKER);
		data.list = self.data.external;

		return statemachine.constants.STATE_OPTION_PICKER;
	end

	return nil;
end

function StateOptions:getstateremovals(statemachine)
	if not self.data.options.window.IsOpen then
		return self.state;
	end

	return nil;
end

return StateOptions;