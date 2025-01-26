local Slab = require("Slab");
local util = require("source.util");

local range = {
	begin = 0,
	length = 0
};

function range:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

function range:setstart(value)
	self.begin = value;
	self:updatedstart();
end

function range:setend(value)
	self.length = math.max(0, value - self.begin);
	self:updatedend();
end

function range:setlength(value)
	self.length = value;
	self:updatedend();
end

function range:getstart()
	return self.begin;
end

function range:getend()
	return self.begin + self.length;
end

function range:getlength()
	return self.length;
end

function range:updatedstart()
	if not self.startoptions or not self.endoptions then
		return;
	end

	self.startoptions.Text = self:getstart();
end

function range:updatedend()
	if not self.startoptions or not self.endoptions then
		return;
	end

	self.endoptions.Text = self:getend();
end

function range:prepareoptions(startoptions, endoptions, layoutoptions)
	self.startoptions = startoptions or {};
	self.endoptions = endoptions or {};
	self.layoutoptions = layoutoptions or {
		AlignX = "center"
	};

	self.startoptions.Text = self:getstart();
	self.startoptions.NumbersOnly = true;

	self.endoptions.Text = self:getend();
	self.endoptions.NumbersOnly = true;

	self.layoutoptions.Columns = 3;
end

function range:update(id, dt)
	Slab.BeginLayout(id .. "layout", self.layoutoptions);

	Slab.SetLayoutColumn(2);
	util.slabtext("Range");
	util.slabtext("to");

	Slab.SetLayoutColumn(1);

	util.slabtext("");
	if Slab.Input(id .. "start", self.startoptions) then
		local num = Slab.GetInputNumber();
		self:setstart(num);
	end

	Slab.SetLayoutColumn(3);

	util.slabtext("");
	if Slab.Input(id .. "end", self.endoptions) then
		local num = Slab.GetInputNumber();
		self:setend(num);
	end

	Slab.EndLayout();
end

return range;