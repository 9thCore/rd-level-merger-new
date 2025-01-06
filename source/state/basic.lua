local Slab = require("Slab");

local StateBasic = {
	data = {},
	state = nil
};

function StateBasic:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function StateBasic:enter(statemachine)
	-- Callback when the state has just been entered.
	-- Expected to be initialised here.
end

function StateBasic:update(statemachine, dt)
	-- Callback on every frame, relating to updating logic.
	-- Expected to be updated here.
end

function StateBasic:draw(statemachine)
	-- Callback on every frame, relating to drawing to the screen.
	-- Expected to be drawn here, but not necessary as Slab can handle it, really.
end

function StateBasic:mousemoved(statemachine, x, y, dx, dy, istouch)
	-- Callback when the mouse is moved.
end

function StateBasic:mousepressed(statemachine, x, y, button, istouch, presses)
	-- Callback when the mouse is pressed.
end

function StateBasic:exit(statemachine)
	-- Callback when the state has been exited.
	-- Expected to reset stuff here.
end

return StateBasic;