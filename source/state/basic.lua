return function()
	local obj = {
		data = {},
		state = nil
	};

	function obj:enter()
		-- Callback when the state has just been entered.
		-- Expected to be initialised here.
	end

	function obj:update(dt)
		-- Callback on every frame, relating to updating logic.
		-- Expected to be updated here.
	end

	function obj:draw()
		-- Callback on every frame, relating to drawing to the screen.
		-- Expected to be drawn here, but not necessary as Slab can handle it, really.
	end

	function obj:mousemoved(x, y, dx, dy, istouch)
		-- Callback when the mouse is moved.
	end

	function obj:mousepressed(x, y, button, istouch, presses)
		-- Callback when the mouse is pressed.
	end

	function obj:filedropped(file)
		-- Callback when a file is dropped.
	end

	function obj:exit()
		-- Callback when the state has been exited.
		-- Expected to reset stuff here.
	end

	function obj:getstateadditions(statemachine)
		-- Callback on every frame, relating to updating state.
		-- Must return either nil (meaning no change),
		--  a state, or a list of states.
		-- Adds the returned states to the machine on the next frame.

		return nil;
	end

	function obj:getstateremovals(statemachine)
		-- Callback on every frame, relating to updating state.
		-- Must return either nil (meaning no change),
		--  a state, or a list of states.
		-- Removes the returned states from the machine on the next frame.

		return nil;
	end

	return obj;
end