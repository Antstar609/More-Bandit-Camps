modSoul = {}

modSoul.isDatabaseLoaded = false
modSoul.soulType = {
	"villager",
	"bandit",
	"guard",
	"soldier",
	"cuman",
	"townsman",
	"miner",
	"mason",
	"wanderer",
	"bailiff",
	"merchant",
	"weaponsmith",
	"circator",
	"lumberjack",
	"baker",
	"collier",
	"herold",
	"watchman",
	"innkeeper",
	"monk",
	"priest",
	"beggar",
	"executioner",
	"tanner",
	"armorer",
	"tailor",
	"blacksmith",
	"butcher",
	"shopGuard",
	"mercenary"
}

modSoul.wanderingGuards = {
	"f1c2611b-f0b9-469e-aad5-cf713a11790f",
	"47310cda-0bcc-4541-9401-0a29e68a61a3",
	"79862ell-4c5a-4a76-8461-58ed2875de99",
	"9773c67c-b2c4-46ee-a505-f4c2094bd11d",
	"0651c27f-bfda-4cb5-8ccc-0e874b05fad2",
	"ab05a713-1fce-4576-b128-e06c5d32f03f",
	"8bc427f7-8802-4326-99fc-b337233ecf90",
	"614e4495-1746-4c0e-9c22-642da7a3a3c3",
	"8d2ca8d7-9442-498c-8778-77bbd47e0256",
	"147ba959-a969-48e1-9948-67893566865d",
	"8f58f1e4-cb02-46eb-a5e7-df6f8b2d7587",
	"b00fe10f-7e8f-48b5-8b55-ea64cfe8990d",
}

function modSoul:CheckValidType(type)

	for i, v in ipairs(self.soulType) do
		if v == type then
			return true
		end
	end
end

function modSoul:SetGender(name)
	
	if string.find(name, "woman", 1, true) then
		return "NPC_Female"
	end
	return "NPC"
end

function modSoul:GetSoulsFromDatabase(type)

	if self:CheckValidType(type) then
		local souls = {}
		local tableName = "v_soul_character_data"

		--not sure if i need to load the database in the first place
		if not self.isDatabaseLoaded then
			Database.LoadTable(tableName)
			self.isDatabaseLoaded = true
		end

		local tableData = Database.GetTableInfo(tableName)
		local rows = tableData.LineCount - 1

		for i = 0, rows do
			local rowInfo = Database.GetTableLine(tableName, i)
			if string.find(rowInfo.name_string_id, type, 1, true) then
				local soul = {}
				soul.name = rowInfo.name_string_id
				soul.id = rowInfo.soul_id
				soul.row = i
				table.insert(souls, soul)
			end
		end

		return souls
	else
		modMain:Log("Type not in the list")
	end
end

function modSoul:spawnEntity(type, position)

	local souls = self:GetSoulsFromDatabase(type)

	if souls ~= nil then
		local randomNumber = math.random(1, #souls)

		local spawnParams = {}
		spawnParams.class = self:SetGender(souls[randomNumber].name)
		spawnParams.name = type.."_"..souls[randomNumber].row + 10 --to match the line in the file
		spawnParams.position = position or player:GetWorldPos()
		spawnParams.orientation = spawnParams.position
		spawnParams.properties = {}
		spawnParams.properties.sharedSoulGuid = souls[randomNumber].id

		local entity = System.SpawnEntity(spawnParams)
		entity.AI.invulnerable = true

		Game.SendInfoText("Entity spawned", false, nil, 1)
	end
end
System.AddCCommand('spawnEntity', 'modSoul:spawnEntity(%line)', "Spawn an entity")

function modSoul:SpawnWanderingGuard()

	local randomNumber = math.random(1, #self.wanderingGuards)
	local spawnParams = {}
	spawnParams.class = "NPC"
	spawnParams.name = "Guard"
	spawnParams.position = player:GetWorldPos()
	spawnParams.orientation = spawnParams.position
	spawnParams.properties = {}
	spawnParams.properties.sharedSoulGuid = self.wanderingGuards[randomNumber]

	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = true

	Game.SendInfoText("Entity spawned", false, nil, 1)
end
System.AddCCommand('wanderingGuard', 'modSoul:SpawnWanderingGuard()', "Spawn a wandering guard")