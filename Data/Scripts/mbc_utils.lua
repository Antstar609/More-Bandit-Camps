--- @class MBC_Utils Utility functions
MBC_Utils = {}

--- Logs a message to the console
--- @param _message string Message to log
function MBC_Utils:Log(_message)
	if (MBC_Main.debugLog == true) then
		System.LogAlways("$5[" .. MBC_Main.name .. "] " .. tostring(_message))
	end
end

--- Logs a message to the screen
--- @param _message string Message to show
--- @param _forceClear boolean Force clear the screen (default: false)
--- @param _time number Time in seconds to show the message (default: 3)
function MBC_Utils:LogOnScreen(_message, _forceClear, _time)
	Game.SendInfoText(tostring(_message), _forceClear or false, nil, _time or 3)
end

--- Dump Entity
--- @param _entityName string Name of the entity in the game
function MBC_Utils:DumpEntity(_entityName)
	dump(System.GetEntityByName(_entityName))
end
System.AddCCommand(MBC_Main.prefix .. 'dumpEntity', 'MBC_Utils:DumpEntity(%line)', "Dump the entity")

--- Prints the player's location to the console and the screen
function MBC_Utils:PrintLoc()
	local pos = player:GetWorldPos()
	self:Log(string.format("{ x = %.3f, y = %.3f, z = %.3f }", pos.x, pos.y, pos.z))
	self:LogOnScreen(Vec2Str(pos), true, 10)
end
System.AddCCommand(MBC_Main.prefix .. 'loc', 'MBC_Utils:PrintLoc()', "Prints the player's location")

--- Teleports the player to the given position
--- @param _xyz string Position to teleport to (x y z) or camp name (test)
function MBC_Utils:Teleport(_xyz)
	-- Teleport to npc
	if (_xyz == "npc") then
		local pos = { x = MBC_Quest.npcPosition.x, y = MBC_Quest.npcPosition.y + 2, z = MBC_Quest.npcPosition.z }
		player:SetWorldPos(pos)
		return
	end

	-- Teleport to camp
	if (_xyz == "camp") then
		if (MBC_Quest.spawnedCamp.name == "") then
			MBC_Utils:LogOnScreen("No camp spawned")
			return
		else
			local pos = MBC_Camps.locations[MBC_Quest.spawnedCamp.name]
			player:SetWorldPos(pos)
			return
		end
	end

	-- Teleport to camp by name
	for campName, campPos in pairs(MBC_Camps.locations) do
		if (_xyz == campName) then
			player:SetWorldPos(campPos)
			return
		end
	end

	-- Teleport to the given position
	local function SplitStringToCoordinates(_string)
		local coordinates = { "x", "y", "z" }
		local result = {}
		local i = 1
		for value in string.gmatch(_string, "%d+") do
			result[coordinates[i]] = tonumber(value)
			i = i + 1
		end
		return result
	end
	local pos = SplitStringToCoordinates(_xyz)
	self:LogOnScreen("Teleported to " .. pos.x .. ", " .. pos.y .. ", " .. pos.z, true, 5)
	player:SetWorldPos(pos)
end
System.AddCCommand(MBC_Main.prefix .. 'teleport', 'MBC_Utils:Teleport(%line)', "Teleports the player to the given position")

function MBC_Utils:TagpointStatus()
	local tagpoint = System.GetEntityByName("Tagpoint")
	if (tagpoint == nil) then
		self:Log("Tagpoint not found")
		return
	end

	local pos = tagpoint:GetWorldPos()
	self:Log("Tagpoint position: " .. Vec2Str(pos))
end
System.AddCCommand(MBC_Main.prefix .. 'tagpoint', 'MBC_Utils:TagpointStatus()', "Get the tagpoint status")

function MBC_Utils:CampStatus()
	local camp = System.GetEntityByName("MBCCampEntity")
	if (camp == nil) then
		self:Log("Camp not found")
		return
	end

	local pos = camp:GetWorldPos()
	self:Log("Camp position: " .. Vec2Str(pos))
end
System.AddCCommand(MBC_Main.prefix .. 'camp', 'MBC_Utils:CampStatus()', "Get the camp status")