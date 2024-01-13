ModCamps = {
	entity = nil,
	locations = {
		skalice = { x = 528.059, y = 3557.59, z = 26.5238 },
	},
	difficulty = {
		easy = 1,
		medium = 3,
		hard = 6,
	},
}

function ModCamps:SpawnCamp(campName, locationName, difficulty)
	self.entity = System.SpawnEntity({ class = "CampEntity", name = campName, position = self.locations[locationName] })
	
	if difficulty == nil then
		ModUtils:Log(campName .. " spawned with default difficulty")
	end
	self.entity.difficulty = self.difficulty[difficulty] or self.difficulty.easy
end