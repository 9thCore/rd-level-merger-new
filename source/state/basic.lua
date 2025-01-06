return function()
	local obj = {
		data = {},
		state = nil
	};

	function obj:enter(statemachine)
		-- Callback when the state has just been entered.
		-- Expected to be initialised here.
	end

	function obj:update(statemachine, dt)
		-- Callback on every frame, relating to updating logic.
		-- Expected to be updated here.
	end

	function obj:draw(statemachine)
		-- Callback on every frame, relating to drawing to the screen.
		-- Expected to be drawn here, but not necessary as Slab can handle it, really.
	end

	function obj:mousemoved(statemachine, x, y, dx, dy, istouch)
		-- Callback when the mouse is moved.
	end

	function obj:mousepressed(statemachine, x, y, button, istouch, presses)
		-- Callback when the mouse is pressed.
	end

	function obj:exit(statemachine)
		-- Callback when the state has been exited.
		-- Expected to reset stuff here.
	end

	return obj;
end