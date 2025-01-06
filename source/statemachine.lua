local statemachine = {};

statemachine.constants = {
	STATE_MAIN = 0
}

statemachine.states = {
	[statemachine.constants.STATE_MAIN] = require("source.state.main")
}

-- Currently active states.
-- Slight misnomer, but allows
--  overlaying states on top
--  of another.
-- Clicking logic will only
--  be done on the last state.
statemachine.currentstates = {};
statemachine.stateactive = {};

function statemachine.run(state, funcname, ...)
	local object = statemachine.states[state];
	if object == nil or object[funcname] == nil then
		return;
	end

	return object[funcname](object, statemachine, ...);
end

function statemachine.runall(funcname, ...)
	for _, state in ipairs(statemachine.currentstates) do
		statemachine.run(state, funcname, ...);
	end
end

function statemachine.init(state)
	statemachine.stateactive[state] = true;
	statemachine.states[state].state = state;
	statemachine.run(state, "enter");
end

function statemachine.set(state)
	statemachine.runall("exit");
	
	statemachine.currentstates = {state};
	statemachine.stateactive = {};

	statemachine.init(state);
end

function statemachine.add(state, position)
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

return statemachine;