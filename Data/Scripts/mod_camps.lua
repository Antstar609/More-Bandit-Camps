--- @class ModCamps Manage camps entities
--- @field locations table List of different spawning locations
--- @field difficulty table List of different difficulties
--- @field meshes table List of spawned meshes
--- @field meshesFilePath table List of file paths for the meshes
--- @field tagpoint table Tag point for the camp entity
ModCamps = {
	spawnedCamp = nil,

	locations = {
		test = { x = 526, y = 3560, z = 27 }
	},

	difficulty = {
		easy = 2,
		medium = 3,
		hard = 4,
	},

	meshesFilePath = {
		fireplace = "Objects/buildings/refugee_camp/fireplace.cgf",
		tents = {
			"Objects/structures/tent_cuman/tent_cuman_small_v1.cgf",
			--"Objects/structures/tent_cuman/tent_cuman_v6.cgf",
			--"Objects/structures/tent/tent.cgf",
		},
		crates = {
			"Objects/props/crates/crate_long.cgf",
			"Objects/props/crates/crate_short.cgf",
		},
	},
}

--- Spawn a camp entity at the given location with the given difficulty
--- @param _locationName string Name of the location
--- @param _difficulty string Difficulty of the camp (default: easy)
function ModCamps:SpawnCamp(_locationName, _difficulty, _isWithoutTagpoint)
	local spawnParams = {
		class = "CampEntity",
		name = "Camp",
		position = self.locations[_locationName],
	}
	local camp = System.SpawnEntity(spawnParams)
	camp.name = _campName

	if (not (type(_difficulty) == "string")) then
		ModUtils:Log(_campName .. " spawned with default difficulty")
	end
	camp.difficulty = self.difficulty[_difficulty] or self.difficulty.easy
	self.spawnedCamp = camp

	self:SpawnMeshes(_locationName, self.locations[_locationName])
	
	if (not _isWithoutTagpoint) then
		self:SpawnTagPoint(self.locations[_locationName])
		ModUtils:Log("Spawned camp with tagpoint")
	else
		ModUtils:Log("Spawned camp without tagpoint")
	end
end

--- Spawn all meshes for the camp entity
--- @param _locationName string Name of the camp entity
--- @param _position table Position of the camp entity (x, y, z)
function ModCamps:SpawnMeshes(_locationName, _position)

	local tentPosition, tentOrientation, cratePosition, crateOrientation = { x = 0, y = 0, z = 0 }

	if (_locationName == "test") then
		tentPosition = { x = 525, y = 3563, z = 27 }
		tentOrientation = { x = 0, y = 360, z = 0 }

		cratePosition = { x = 523, y = 3559, z = 27 }
		crateOrientation = { x = 10, y = 10, z = 0 }
	end

	-- fireplace
	local fireplace = System.SpawnEntity({ class = "BasicEntity", name = "fireplace", position = _position, properties = { bSaved_by_game = 0 } })
	fireplace:LoadObject(0, self.meshesFilePath.fireplace)
	table.insert(self.spawnedCamp.meshes, fireplace)

	-- tents
	local tent = System.SpawnEntity({ class = "BasicEntity", name = "tent", position = tentPosition, orientation = tentOrientation, properties = { bSaved_by_game = 0 } })
	local randomTent = math.random(1, #self.meshesFilePath.tents)
	tent:LoadObject(0, self.meshesFilePath.tents[randomTent])
	table.insert(self.spawnedCamp.meshes, tent)

	-- crates
	local crate = System.SpawnEntity({ class = "BasicEntity", name = "crate", position = cratePosition, orientation = crateOrientation, properties = { bSaved_by_game = 0 } })
	local randomCrate = math.random(1, #self.meshesFilePath.crates)
	crate:LoadObject(0, self.meshesFilePath.crates[randomCrate])
	table.insert(self.spawnedCamp.meshes, crate)
end

--- Spawn an invisible npc to use it as a tag point for the camp entity
function ModCamps:SpawnTagPoint(_position)
	local spawnParams = {
		class = "NPC",
		name = "tagpoint",
		position = { x = _position.x, y = _position.y, z = _position.z },
		properties = {
			sharedSoulGuid = "00000000-6666-0000-9999-000000000000",
			fileModel = "none",
		},
	}
	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = false
	entity.lootable = false
	entity.lootIsLegal = false
	self.spawnedCamp.tagpoint = entity
end