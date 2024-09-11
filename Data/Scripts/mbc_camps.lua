--- @class MBC_Camps Manage camps entities
--- @field locations table List of different spawning locations
--- @field difficulty table List of different difficulties
--- @field meshes table List of spawned meshes
--- @field modelsFilePath table List of file paths for the meshes
--- @field tagpoint table Tag point for the camp entity
MBC_Camps = {
	spawnedCamp = nil,

	locations = {
		uzhitz = { x = 3504.877, y = 3766.421, z = 161.006 },
		forest = { x = 1933.638, y = 1941.377, z = 135.456 },
		vranik = { x = 540.977, y = 418.813, z = 178.359 },
		forest2 = { x = 493.028, y = 2234.995, z = 54.999 },
		forest3 = { x = 1918.524, y = 3379.129, z = 103.369 },
		idk = { x = 3393.676, y = 2375.124, z = 161.180 },
		lastone = { x = 3348.984, y = 332.899, z = 78.839 }
	},

	difficulty = {
		0, --none
		2, --easy
		3, --medium
		4, --hard
	},

	modelsFilePath = {
		fireplace = "Objects/buildings/refugee_camp/fireplace.cgf",
		tents = {
			"Objects/structures/tent_cuman/tent_cuman_small_v1.cgf",
			"Objects/structures/tent_cuman/tent_cuman_v6.cgf",
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
function MBC_Camps:SpawnCamp(_locationName, _difficulty)
	local spawnParams = {
		class = "MBCCampEntity",
		name = "MBCCamp",
		position = self.locations[_locationName],
	}
	local camp = System.SpawnEntity(spawnParams)
	camp.name = _locationName

	camp.difficulty = self.difficulty[_difficulty] or self.difficulty[3]
	self.spawnedCamp = camp

	MBC_Utils:Log("Camp spawned at " .. camp.name .. " with " .. camp.difficulty .. " enemies")

	self:SpawnModels(_locationName, self.locations[_locationName])
	self:SpawnTagPoint(self.locations[_locationName])
end

--- Spawn all meshes for the camp entity
--- @param _locationName string Name of the camp entity
--- @param _position table Position of the camp entity (x, y, z)
function MBC_Camps:SpawnModels(_locationName, _position)

	local tent, crate = { x = 0, y = 0, z = 0 }

	if (_locationName == "uzhitz") then
		crate = { position = { x = 3505.997, y = 3764.233, z = 160.900 }, orientation = { x = 0.000, y = -0.000, z = 0.478 } }
		tent = { position = { x = 3506.176, y = 3770.788, z = 160.891 }, orientation = { x = 0.000, y = 0.000, z = -0.264 } }

	elseif (_locationName == "forest") then
		crate = { position = { x = 1932.694, y = 1938.647, z = 135.280 }, orientation = { x = 0.000, y = -0.000, z = 3.054 } }
		tent = { position = { x = 1936.807, y = 1939.924, z = 135.198 }, orientation = { x = 0.000, y = 0.000, z = -2.002 } }

	elseif (_locationName == "vranik") then
		crate = { position = { x = 538.727, y = 417.104, z = 178.445 }, orientation = { x = 0.000, y = -0.000, z = 2.181 } }
		tent = { position = { x = 544.495, y = 421.721, z = 178.178 }, orientation = { x = 0.000, y = 0.000, z = -0.902 } }

	elseif (_locationName == "forest2") then
		crate = { position = { x = 495.311, y = 2233.110, z = 54.963 }, orientation = { x = 0.000, y = 0.000, z = -2.280 } }
		tent = { position = { x = 496.265, y = 2238.323, z = 54.454 }, orientation = { x = 0.000, y = 0.000, z = -0.829 } }

	elseif (_locationName == "forest3") then
		crate = { position = { x = 1916.330, y = 3377.803, z = 103.060 }, orientation = { x = 0.000, y = -0.000, z = 2.133 } }
		tent = { position = { x = 1921.661, y = 3375.754, z = 103.338 }, orientation = { x = 0.000, y = 0.000, z = -2.438 } }

	elseif (_locationName == "idk") then
		crate = { position = { x = 3392.077, y = 2378.869, z = 161.347 }, orientation = { x = 0.000, y = 0.000, z = -2.786 } }
		tent = { position = { x = 3393.050, y = 2371.457, z = 161.028 }, orientation = { x = 0.000, y = -0.000, z = 2.942 } }

	elseif (_locationName == "lastone") then
		crate = { position = { x = 3392.077, y = 2378.869, z = 161.347 }, orientation = { x = 0.000, y = 0.000, z = -2.786 } }
		tent = { position = { x = 3393.050, y = 2371.457, z = 161.028 }, orientation = { x = 0.000, y = -0.000, z = 2.942 } }
	end

	-- fireplace
	self:SpawnModelEntity("fireplace", _position, { x = 0, y = -0, z = 0 }, self.modelsFilePath.fireplace)

	-- tents
	local randomTent = math.random(1, #self.modelsFilePath.tents)
	self:SpawnModelEntity("tent", tent.position, tent.orientation, self.modelsFilePath.tents[randomTent])

	-- crates
	local randomCrate = math.random(1, #self.modelsFilePath.crates)
	self:SpawnModelEntity("crate", crate.position, crate.orientation, self.modelsFilePath.crates[randomCrate])
end

--- Helper function to spawn a model entity
--- @param _name string Name of the entity
--- @param _position table Position of the entity (x, y, z)
--- @param _orientation table Orientation of the entity (x, y, z)
--- @param _modelPath string Path to the model file
function MBC_Camps:SpawnModelEntity(_name, _position, _orientation, _modelPath)
	local entity = System.SpawnEntity({
		class = "BasicEntity",
		name = _name,
		position = _position,
		properties = {
			bSaved_by_game = 0,
			object_Model = _modelPath
		}
	})
	entity:SetAngles(_orientation)
	entity:SetFlags(ENTITY_FLAG_RAIN_OCCLUDER, 1)
	entity:SetFlags(ENTITY_FLAG_CASTSHADOW, 1)
	table.insert(self.spawnedCamp.meshes, entity)
	return entity
end

--- Spawn an invisible npc to use it as a tag point for the camp entity
--- @param _position table Position of the tag point (x, y, z)
function MBC_Camps:SpawnTagPoint(_position)
	local spawnParams = {
		class = "NPC",
		name = "tagpoint",
		position = _position,
		properties = {
			sharedSoulGuid = "1b036f85-f939-4ec6-89a3-0229a87fafaf",
			fileModel = "none"
		},
	}
	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = true
	entity.lootable = false
	entity.lootIsLegal = false
	self.spawnedCamp.tagpoint = entity
end