-- Level merger helper utility 
-- 9thCore

local Color = require("source.color");
local resources = require("source.resources");
local statemachine = require("source.statemachine");
local levelholder = require("source.worker.levelholder");
local Slab = require("Slab");

local VERSION = "2.0";
local TITLE = "Level Merger v" .. VERSION;

function love.load(args)
	love.window.setIcon(resources.icon);
	love.window.setTitle(TITLE);

	love.audio.setVolume(1/4);

	Slab.Initialize(args);
	Slab.PushFont(resources.font);
	Slab.DisableDocks{"Left", "Right", "Bottom"};

	local style = Slab.GetStyle();
	style.TextColor = {1.0, 1.0, 1.0, 1.0};

	statemachine.set(statemachine.constants.STATE_MAIN);
	levelholder.ensure();
end

function love.update(dt)
	Slab.Update(dt);
	statemachine.update(dt);
end

function love.draw()
	Slab.Draw();
	statemachine.draw();
end

function love.mousemoved(x, y, dx, dy, istouch)
	statemachine.mousemoved(x, y, dx, dy, istouch);
end

function love.mousepressed(...)
	statemachine.mousepressed(...);
end