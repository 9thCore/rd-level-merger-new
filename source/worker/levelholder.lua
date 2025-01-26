local json = require("lib.json");
local levelclass = require("source.worker.level");
local util = require("source.util");

local levelholder = {
	-- Parsed levels go here
	levels = {},
	defaultoptions = {},
	workingdirectory = "Input",
	outputlevel = "out.rdlevel",
	nullreplica = "\"LEVELMERGER_NULL\""
};

function levelholder.ensure()
	if not love.filesystem.getInfo(levelholder.workingdirectory) then
		love.filesystem.createDirectory(levelholder.workingdirectory);
	end
end

function levelholder.read(filename, text)
	-- remove random-ass first character
	text = text:sub(4);

	-- Replace nulls with a replica
	local in_str = false
	local i = 1

	-- Patchy work, but it does the job
	while i <= #text do
		if text:sub(i, i) == "\"" and text:sub(i - 1, i) ~= "\\\"" then
			in_str = not in_str;
		elseif text:sub(i, i + 3) == "null" and not in_str then
			text = string.format("%s%s%s", text:sub(1, i - 1), levelholder.nullreplica, text:sub(i + 4));
			i = i - 1;
		end

		i = i + 1;
	end

	local passed, level = pcall(json.decode, text);

	if not passed then
		return;
	end

	local object = levelclass:new(level, filename);
	object.options = {};

	for k, v in ipairs(levelholder.defaultoptions) do
		object.options[k] = v:copy();
	end
	
	table.insert(levelholder.levels, object);
end

function levelholder.add(filename, url)
	local info = love.filesystem.getInfo(url);
	if info.type ~= "file" then
		return;
	end

	local contents, size = love.filesystem.read(url);

	if contents == nil then
		-- Something went horribly wrong!
		-- In this case, size is an error string
		error(size);
	end

	levelholder.read(filename, contents);
end

function levelholder.addlevels()
	levelholder.ensure();

	local files = love.filesystem.getDirectoryItems(levelholder.workingdirectory);
	for _, file in ipairs(files) do
		local url = string.format("%s/%s", levelholder.workingdirectory, file);
		levelholder.add(file, url);
	end
end

function levelholder.write(data)
	local passed, text = pcall(json.encode, data);

	if not passed then
		error(text);
		return;
	end

	-- Replace replica with the real null
	text = text:gsub(levelholder.nullreplica, "null");

	local url = string.format("%s", levelholder.outputlevel);
	love.filesystem.write(url, text);
end

function levelholder.merge()
	local finaldata = {};

	for _, level in ipairs(levelholder.levels) do
		local data = level:apply();
		util.merge(finaldata, data);
	end

	local passed, err = levelholder.verify(finaldata);
	if not passed then
		return false, err;
	end

	levelholder.write(finaldata);

	return true, nil;
end

function levelholder.remove(position)
	if position > #levelholder.levels or position < 1 then
		return;
	end

	table.remove(levelholder.levels, position);
end

function levelholder.removeall()
	levelholder.levels = {};
end

function levelholder.opendirectory()
	local savedir = love.filesystem.getSaveDirectory();
	local url = string.format("file://%s/%s", savedir, levelholder.workingdirectory);
	love.system.openURL(url);
end

function levelholder.verify(leveldata)
	-- Must have some sort of metadata
	local good = false;
	for _, _ in pairs(leveldata.settings) do
		good = true;
		break;
	end

	if not good then
		return false, "Must have at least one level with metadata!";
	end

	return true, nil;
end

return levelholder;