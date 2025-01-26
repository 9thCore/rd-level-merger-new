local state = require("source.state.basic");
local Slab = require("Slab");

local StateError = state();

function StateError:enter(data)
	self.data.external = data.error;
	self.data.open = true;
end

function StateError:update(dt)
	local result = Slab.MessageBox("Error", string.format("An error has been encountered:\n%s\nCould not write level.", self.data.external));

	if result ~= "" then
		self.data.open = false;
	end
end

function StateError:getstateremovals(statemachine)
	if not self.data.open then
		return self.state;
	end

	return nil;
end

return StateError;