local Slab = require("Slab");

local util = {};

function util.deepcopy(table)
	if type(table) ~= "table" then
		return table;
	end

	local newtable = {};

	for k, v in pairs(table) do
		newtable[k] = util.deepcopy(v);
	end

	return newtable;
end

function util.merge(a, b)
	if a == nil or b == nil then
		return;
	end

	if type(a) ~= "table" and type(b) ~= "table" then
		return;
	elseif type(a) ~= "table" or type(b) ~= "table" then
		-- Trying to merge a table and non-table value,
		--  assume the non-table value must be appended
		--  to the table value and it would be correct
		if type(a) == "table" then
			table.insert(a, b);
		else
			table.insert(b, a);
		end
		
		return;
	end

	if b[1] ~= nil then
		for _, v in ipairs(b) do
			table.insert(a, util.deepcopy(v));
		end
		return;
	end

	for k, v in pairs(b) do
		if a[k] == nil or (type(a[k]) ~= "table" and type(v) ~= "table") then
			a[k] = util.deepcopy(v);
		else
			util.merge(a[k], v);
		end
	end
end

local slabtextdefault = {
	editedBySlabText = true,
	Color = {0, 0, 0, 0},
	HoverColor = {0, 0, 0, 0},
	PressColor = {0, 0, 0, 0},
	Align = "center"
};

-- Workaround: in a layout, text has
--  a different height than buttons,
--  so they misalign.
function util.slabtext(text, options)
	options = options or slabtextdefault;
	if not options.editedBySlabText then
		options.editedBySlabText = true;
		options.Color = {0, 0, 0, 0};
		options.HoverColor = {0, 0, 0, 0};
		options.PressColor = {0, 0, 0, 0};
		options.Align = "center";
	end

	Slab.Button(text, options);
end

return util;