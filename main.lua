-- Level merger helper utility 
-- 9thCore

local Color = require("source.color");
local resources = require("source.resources");
local statemachine = require("source.statemachine");

local VERSION = "2.0";
local TITLE = "Level Merger v" .. VERSION;

function love.load(args)
	love.window.setIcon(resources.icon);
	love.window.setTitle(TITLE);

	love.audio.setVolume(1/4);

	statemachine.set(statemachine.constants.STATE_MAIN);
end

function love.update(dt)
	statemachine.update(dt);
end

function love.draw()
	statemachine.draw();

	Color.White:apply();
	love.graphics.printf(TITLE, resources.font, 0, 10, 400, "center", 0, 2, 2)
end

function love.mousemoved(x, y, dx, dy, istouch)
	statemachine.mousemoved(x, y, dx, dy, istouch);
end

function love.mousepressed(...)
	statemachine.mousepressed(...);
end