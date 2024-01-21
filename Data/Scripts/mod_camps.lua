---@class ModCamps : ModScript - Manage camps entities
---@field campEntities table List of camp entities
---@field locations table List of different spawning locations
---@field difficulty table List of different difficulties
ModCamps = {
	campEntities = {},
	locations = {
		skalice = { x = 528.059, y = 3557.59, z = 26.5238 },
	},
	difficulty = {
		easy = 2,
		medium = 3,
		hard = 4,
	},
}

--- Spawn a camp entity at the given location with the given difficulty
--- @param campName string Name of the camp entity
--- @param locationName string Name of the location
--- @param difficulty string Difficulty of the camp (default: easy)
--- @return table Camp entity
function ModCamps:SpawnCamp(campName, locationName, difficulty)
	local camp = System.SpawnEntity({ class = "CampEntity", name = campName, position = self.locations[locationName] })
	camp.name = campName

	if (not (type(difficulty) == "string")) then
		ModUtils:Log(campName .. " spawned with default difficulty")
	end
	camp.difficulty = self.difficulty[difficulty] or self.difficulty.easy

	return camp
end