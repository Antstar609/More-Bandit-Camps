ModCamps = {
	entity = nil,
	locations = {
		skalice = { x = 528.059, y = 3557.59, z = 26.5238 },
	},
	dificulty = {
		easy = 1,
		medium = 2,
		hard = 3,
	},
}

function ModCamps:SpawnCamp(campName, locationName, difficulty)
	self.entity = System.SpawnEntity({ class = "CampEntity", name = campName, position = self.locations[locationName] })
	self.entity.dificulty = difficulty or self.dificulty.easy
end