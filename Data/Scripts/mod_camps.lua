ModCamps = {
	campEntities = {},
	locations = {
		skalice = { x = 528.059, y = 3557.59, z = 26.5238 },
	},
	difficulty = {
		easy = 1,
		medium = 2,
		hard = 4,
	},
}

function ModCamps:SpawnCamp(campName, locationName, difficulty)
	local camp = System.SpawnEntity({ class = "CampEntity", name = campName, position = self.locations[locationName] })
	camp.name = campName

	if (difficulty == nil) then
		ModUtils:Log(campName .. " spawned with default difficulty")
	end
	camp.difficulty = self.difficulty[difficulty] or self.difficulty.easy

	return camp
end