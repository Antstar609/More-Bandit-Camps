--- @class ModCamps Manage camps entities
--- @field campEntities table List of camp entities
--- @field locations table List of different spawning locations
--- @field difficulty table List of different difficulties
--- @field meshes table List of different meshes to spawn (string)
ModCamps = {
	campEntities = {},

	locations = {
		test = { x = 856, y = 3913, z = 68 },
	},

	difficulty = {
		easy = 2,
		medium = 3,
		hard = 4,
	},

	meshes = {
		fireplace = "Objects/buildings/refugee_camp/fireplace.cgf",
		tents = {
			"Objects/structures/tent_cuman/tent_cuman_small_v1.cgf",
			"Objects/structures/tent_cuman/tent_cuman_v6.cgf",
			"Objects/structures/tent/tent.cgf",
		},
		crates = {
			"Objects/props/crates/crate_long.cgf",
			"Objects/props/crates/crate_short.cgf",
		},
	}
}

--- Spawn a camp entity at the given location with the given difficulty
--- @param _campName string Name of the camp entity
--- @param _locationName string Name of the location
--- @param _difficulty string Difficulty of the camp (default: easy)
--- @return table Camp entity
function ModCamps:SpawnCamp(_campName, _locationName, _difficulty)
	local spawnParams = {
		class = "CampEntity",
		name = _campName,
		position = self.locations[_locationName],
	}
	local camp = System.SpawnEntity(spawnParams)

	if (not (type(_difficulty) == "string")) then
		ModUtils:Log(_campName .. " spawned with default difficulty")
	end
	camp.difficulty = self.difficulty[_difficulty] or self.difficulty.easy

	self:SpawnMeshes(_campName, self.locations[_locationName])

	QuestSystem.ResetQuest("quest_testmod")
	QuestSystem.ActivateQuest("quest_testmod")
	if (not QuestSystem.IsQuestStarted("quest_testmod")) then
		QuestSystem.StartQuest("quest_testmod")
		QuestSystem.StartObjective("quest_testmod", "startBattle", false)
	end

	return camp
end

--- Spawn all meshes for the camp entity
--- @param _campName string Name of the camp entity
--- @param _position table Position of the camp entity (x, y, z)
function ModCamps:SpawnMeshes(_campName, _position)

	local tentOffset, tentOrientation = { x = 0, y = 0, z = 0 }
	local crateOffset, crateOrientation = { x = 0, y = 0, z = 0 }

	if (_campName == "TestCamp") then
		tentOffset = { x = 1.5, y = 1.2, z = 2 }
		tentOrientation = { x = 0, y = 0, z = 0 }
		crateOffset = { x = -1.8, y = -1.1, z = 2 }
		crateOrientation = { x = 0, y = 0, z = 0 }
	elseif (_campName == "") then
		tentOffset = { x = 1, y = 1, z = 0 }
		tentOrientation = { x = 0, y = 0, z = 0 }
		crateOffset = { x = -1, y = -1, z = 0 }
		crateOrientation = { x = 0, y = 0, z = 0 }
	end

	-- fireplace
	local fireplace = System.SpawnEntity({ class = "BasicEntity", name = "fireplace", position = _position })
	fireplace:LoadObject(0, self.meshes.fireplace)

	-- tents
	local tentPosition = { x = _position.x + tentOffset.x, y = _position.y + tentOffset.y, z = _position.z + tentOffset.z }
	local tent = System.SpawnEntity({ class = "BasicEntity", name = "tent", position = tentPosition, orientation = tentOrientation })
	local randomTent = math.random(1, #self.meshes.tents)
	tent:LoadObject(0, self.meshes.tents[randomTent])

	-- crates
	local cratePosition = { x = _position.x + crateOffset.x, y = _position.y + crateOffset.y, z = _position.z + crateOffset.z }
	local crate = System.SpawnEntity({ class = "BasicEntity", name = "crate", position = cratePosition, orientation = crateOrientation })
	local randomCrate = math.random(1, #self.meshes.crates)
	crate:LoadObject(0, self.meshes.crates[randomCrate])
end