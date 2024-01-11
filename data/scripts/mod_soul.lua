modSoul = {}

modSoul.tableName = "soul"
modSoul.rowOffset = 81
modSoul.soulType = {
	"villager",
	"bandit",
	"guard",
	"soldier",
	"cuman",
	"towns",
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
	"79862e11-4c5a-4a76-8461-58ed2875de99",
	"9773c67c-b2c4-46ee-a505-f4c2094bd11d",
	"0651c27f-bfda-4cb5-8ccc-0e874b05fad2",
	"ab05a713-1fce-4576-b128-e06c5d32f03f",
	"8bc427f7-8802-4326-99fc-b337233ecf90",
	"614e4495-1746-4c0e-9c22-642da7a3a3c3",
	"8d2ca8d7-9442-498c-8778-77bbd47e0256",
	"147ba959-a969-48e1-9948-67893566865d",
	"8f58f1e4-cb02-46eb-a5e7-df6f8b2d7587",
	"b00fe10f-7e8f-48b5-8b55-ea64cfe8990d",
	"2622671b-6597-4c3e-9a19-e38a6f67107a",
	"e80212ac-3579-44a0-8009-9e76e5101e4f",
	"e5e59f4d-3e7c-4e4f-b5e4-f80e659497b9",
}

modSoul.wanderingVillager = {
	"ef3e35a8-8147-4ca4-b220-c75848754e95",
}

function modSoul:CheckValidType(type)

	for i, v in ipairs(self.soulType) do
		if v == type then
			return true
		end
	end
end

function modSoul:SetGender(id)

	if id == 1 then
		Game.SendInfoText("Woman", false, nil, 1)
		return "NPC_Female"
	end
	Game.SendInfoText("Man", false, nil, 1)
	return "NPC"
end

function modSoul:GetSoulsFromDatabase(type)

	if self:CheckValidType(type) then
		local souls = {}

		Database.LoadTable(self.tableName)
		local tableData = Database.GetTableInfo(self.tableName)
		
		local rows = tableData.LineCount - 1
		for i = 0, rows do
			local lineInfo = Database.GetTableLine(self.tableName, i)
			if string.find(lineInfo.soul_name, type, 1, true) then
				local soul = {}
				soul.name = lineInfo.soul_name
				soul.id = lineInfo.soul_id
				soul.archetype_id = lineInfo.soul_archetype_id
				soul.row = i + self.rowOffset --to match the line in the xml file
				table.insert(souls, soul)
			end
		end

		return souls
	else
		modMain:Log("Type not in the list")
	end
end

function modSoul:SpawnEntityByType(type, position)

	local souls = self:GetSoulsFromDatabase(type)

	if souls ~= nil then
		local randomNumber = math.random(1, #souls)

		local spawnParams = {}
		spawnParams.class = self:SetGender(souls[randomNumber].archetype_id)
		spawnParams.name = souls[randomNumber].name .. "_" .. souls[randomNumber].row
		spawnParams.position = position or player:GetWorldPos()
		spawnParams.orientation = spawnParams.position
		spawnParams.properties = {}
		spawnParams.properties.sharedSoulGuid = souls[randomNumber].id

		local entity = System.SpawnEntity(spawnParams)
		entity.AI.invulnerable = true

		Game.SendInfoText("Entity spawned", false, nil, 1)
	end
end
System.AddCCommand(modMain.modPrefix .. 'SpawnEntityByType', 'modSoul:SpawnEntityByType(%line)', "")

function modSoul:SpawnEntityByLine(line, position)

	local soul = Database.GetTableLine(self.tableName, line - self.rowOffset)

	local spawnParams = {}
	spawnParams.class = self:SetGender(soul.soul_archetype_id)
	spawnParams.name = soul.soul_name .. "_" .. line
	spawnParams.position = position or player:GetWorldPos()
	spawnParams.orientation = spawnParams.position
	spawnParams.properties = {}
	spawnParams.properties.sharedSoulGuid = soul.soul_id

	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = true

	Game.SendInfoText("Entity spawned", false, nil, 1)
end
System.AddCCommand(modMain.modPrefix .. 'SpawnEntityByLine', 'modSoul:SpawnEntityByLine(%line)', "")

function modSoul:SpawnWanderingGuard()

	local randomNumber = math.random(1, #self.wanderingGuards)
	local spawnParams = {}
	spawnParams.class = "NPC"
	spawnParams.name = "wandering_guard" .. "_" .. randomNumber
	spawnParams.position = player:GetWorldPos()
	spawnParams.orientation = spawnParams.position
	spawnParams.properties = {}
	spawnParams.properties.sharedSoulGuid = self.wanderingGuards[randomNumber]

	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = true

	Game.SendInfoText("Entity spawned", false, nil, 1)
end
System.AddCCommand(modMain.modPrefix .. 'SpawnWanderingGuard', 'modSoul:SpawnWanderingGuard()', "Spawn a wandering guard")