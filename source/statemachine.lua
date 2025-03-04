local statemachine = {};

statemachine.constants = {
	STATE_MAIN = 0,
	STATE_LEVELS = 1,
	STATE_LEVEL_PICKER = 2,
	STATE_OPTIONS = 3,
	STATE_OPTION_PICKER = 4,
	STATE_ERROR = 5
}

statemachine.states = {
	[statemachine.constants.STATE_MAIN] = require("source.state.main"),
	[statemachine.constants.STATE_LEVELS] = require("source.state.levels"),
	[statemachine.constants.STATE_LEVEL_PICKER] = require("source.state.levelpicker"),
	[statemachine.constants.STATE_OPTIONS] = require("source.state.options"),
	[statemachine.constants.STATE_OPTION_PICKER] = require("source.state.optionpicker"),
	[statemachine.constants.STATE_ERROR] = require("source.state.error")
}

-- Currently active states.
-- Slight misnomer, but allows
--  overlaying states on top
--  of another.
-- Clicking logic will only
--  be done on the last state.
statemachine.currentstates = {};
statemachine.stateactive = {};

-- State-specific externally-manipulable data.
-- Does not need the state to be active.
statemachine.data = {};

-- Lock any changes to the
--  states while functions
--  are being run.
-- Will throw.
local runningall = false;

function statemachine.run(state, funcname, ...)
	local object = statemachine.states[state];
	if object == nil or object[funcname] == nil then
		return;
	end

	return object[funcname](object, ...);
end

function statemachine.runallwithcallback(callback, funcname, ...)
	runningall = true;
	for _, state in ipairs(statemachine.currentstates) do
		callback(statemachine.run(state, funcname, ...));
	end
	runningall = false;
end

function statemachine.runall(funcname, ...)
	statemachine.runallwithcallback(function() end, funcname, ...);
end

function statemachine.init(state)
	statemachine.stateactive[state] = true;
	statemachine.states[state].state = state;
	statemachine.run(state, "enter", statemachine.getdata(state));
end

function statemachine.set(state)
	if runningall then
		error("Cannot set state during runall of a function");
	end

	statemachine.runall("exit");
	
	statemachine.currentstates = {state};
	statemachine.stateactive = {};

	statemachine.init(state);
end

function statemachine.add(state, position)
	if runningall then
		error("Cannot add a state during runall of a function");
	end

	if statemachine.active(state) then
		return;
	end

	if position == nil then
		table.insert(statemachine.currentstates, state);
	else
		table.insert(statemachine.currentstates, position, state);
	end

	statemachine.init(state);
end

function statemachine.remove(state)
	if runningall then
		error("Cannot remove a state during runall of a function");
	end

	if not statemachine.active(state) then
		return;
	end

	for index, currentstate in ipairs(statemachine.currentstates) do
		if currentstate == state then
			statemachine.run(state, "exit");
			table.remove(statemachine.currentstates, index);
			statemachine.stateactive[state] = false;
			return;
		end
	end
end

function statemachine.active(state)
	return statemachine.stateactive[state];
end

function statemachine.update(dt)
	statemachine.runall("update", dt);

	local newstates = {};
	statemachine.runallwithcallback(function(result)
		if result == nil then
			return;
		end

		if type(result) == "number" then
			table.insert(newstates, result);
			return;
		end

		for _, state in ipairs(result) do
			table.insert(newstates, result);
		end
	end, "getstateadditions", statemachine);

	for _, state in ipairs(newstates) do
		statemachine.add(state);
	end

	local removedstates = {};
	statemachine.runallwithcallback(function(result)
		if result == nil then
			return;
		end

		if type(result) == "number" then
			table.insert(removedstates, result);
			return;
		end

		for _, state in ipairs(result) do
			table.insert(removedstates, result);
		end
	end, "getstateremovals", statemachine);

	for _, state in ipairs(removedstates) do
		statemachine.remove(state);
	end
end

function statemachine.getdata(state)
	if not statemachine.data[state] then
		statemachine.data[state] = {};
	end

	return statemachine.data[state];
end

function statemachine.draw()
	statemachine.runall("draw");
end

function statemachine.mousemoved(...)
	statemachine.runall("mousemoved", ...);
end

function statemachine.mousepressed(...)
	local laststate = statemachine.currentstates[#statemachine.currentstates];
	statemachine.run(laststate, "mousepressed", ...);
end

function statemachine.filedropped(...)
	local laststate = statemachine.currentstates[#statemachine.currentstates];
	statemachine.run(laststate, "filedropped", ...);
end

return statemachine;