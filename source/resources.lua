local FONT = love.graphics.newFont("resource/font.otf", 24);
FONT:setFilter("nearest", "nearest");

local SOUND = love.audio.newSource("resource/sfx.ogg", "static");

local ICON = love.image.newImageData("resource/icon.png");

return {
	font = FONT,
	sound = SOUND,
	icon = ICON
};