ModSoul = {
	tableName = "soul",
	rowOffset = 81,

	soulType = {
		"villager", "bandit", "guard", "soldier", "cuman", "towns", "miner", "mason",
		"wanderer", "bailiff", "merchant", "weaponsmith", "circator", "lumberjack", "baker",
		"collier", "herold", "watchman", "innkeeper", "monk", "priest", "beggar",
		"executioner", "tanner", "armorer", "tailor", "blacksmith", "butcher", "shopGuard", "mercenary"
	},

	wanderingGuards = {
		"f1c2611b-f0b9-469e-aad5-cf713a11790f", "47310cda-0bcc-4541-9401-0a29e68a61a3",
		"79862e11-4c5a-4a76-8461-58ed2875de99", "9773c67c-b2c4-46ee-a505-f4c2094bd11d",
		"0651c27f-bfda-4cb5-8ccc-0e874b05fad2", "ab05a713-1fce-4576-b128-e06c5d32f03f",
		"8bc427f7-8802-4326-99fc-b337233ecf90", "614e4495-1746-4c0e-9c22-642da7a3a3c3",
		"8d2ca8d7-9442-498c-8778-77bbd47e0256", "147ba959-a969-48e1-9948-67893566865d",
		"8f58f1e4-cb02-46eb-a5e7-df6f8b2d7587", "b00fe10f-7e8f-48b5-8b55-ea64cfe8990d",
		"2622671b-6597-4c3e-9a19-e38a6f67107a", "e80212ac-3579-44a0-8009-9e76e5101e4f",
		"e5e59f4d-3e7c-4e4f-b5e4-f80e659497b9",
	},

	wanderingVillager = {
		"ef3e35a8-8147-4ca4-b220-c75848754e95",
	},
}

function ModSoul:CheckValidType(type)
	return table.contains(self.soulType, type)
end

function ModSoul:SetGender(id)
	--local gender = (id == 1) and "Woman" or "Man"
	return (id == 1) and "NPC_Female" or "NPC" -- ternary test
end

function ModSoul:GetSoulsFromDatabase(soulType)
	if (not self:CheckValidType(soulType)) then
		ModUtils:Log("Type not in the list")
		return nil
	end

	local souls = {}
	Database.LoadTable(self.tableName)
	local tableData = Database.GetTableInfo(self.tableName)
	local rows = tableData.LineCount - 1

	for i = 0, rows do
		local lineInfo = Database.GetTableLine(self.tableName, i)
		if (string.find(lineInfo.soul_name, soulType, 1, true)) then
			local soulData = {
				name = lineInfo.soul_name,
				id = lineInfo.soul_id,
				archetype_id = lineInfo.soul_archetype_id,
				row = i + self.rowOffset,
			}

			-- to prevent bugged entity (not perfect for all entities)
			local activity = lineInfo.activity_0
			if (activity ~= "dummyWait") then
				table.insert(souls, soulData)
			end
		end
	end

	return souls
end

function ModSoul:SpawnEntityByType(entityType, position, numberOfEntities, offsetPosition)
	local soul = self:GetSoulsFromDatabase(entityType)
	if (soul == nil) then
		ModUtils:Log("No souls found")
		return
	end

	local entities = {}
	for _ = 1, (numberOfEntities or 1) do
		local randomNumber = math.random(1, #soul)

		if (offsetPosition ~= nil) then
			local offsetX = math.random(-offsetPosition, offsetPosition)
			local offsetY = math.random(-offsetPosition, offsetPosition)
			position = { x = position.x + offsetX, y = position.y + offsetY, z = position.z }
		end

		local spawnParams = {
			class = self:SetGender(soul[randomNumber].archetype_id),
			name = soul[randomNumber].name .. "_" .. soul[randomNumber].row,
			position = position or player:GetWorldPos(),
			orientation = player:GetWorldPos(),
			properties = {
				sharedSoulGuid = soul[randomNumber].id,
			},
		}

		local entity = System.SpawnEntity(spawnParams)
		entity.AI.invulnerable = true
		entity.lootIsLegal = true

		table.insert(entities, entity)
	end
	return entities
end
System.AddCCommand(ModMain.prefix .. 'SpawnEntityByType', 'ModSoul:SpawnEntityByType(%line)', "")

function ModSoul:SpawnEntityByLine(lineNumber, position)
	local soul = Database.GetTableLine(self.tableName, lineNumber - self.rowOffset)
	if (soul == nil) then
		ModUtils:Log("No souls found")
		return
	end

	local spawnParams = {
		class = self:SetGender(soul.soul_archetype_id),
		name = soul.soul_name .. "_" .. lineNumber,
		position = position or player:GetWorldPos(),
		orientation = player:GetWorldPos(),
		properties = {
			sharedSoulGuid = soul.soul_id,
		},
	}

	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = true
	entity.lootIsLegal = true

	ModUtils:Log("Entity spawned")
end
System.AddCCommand(ModMain.prefix .. 'SpawnEntityByLine', 'ModSoul:SpawnEntityByLine(%line)', "")

function ModSoul:SpawnWanderingGuard()
	local randomNumber = math.random(1, #self.wanderingGuards)
	local spawnParams = {
		class = "NPC",
		name = "wandering_guard" .. "_" .. randomNumber,
		position = player:GetWorldPos(),
		orientation = player:GetWorldPos(),
		properties = {
			sharedSoulGuid = self.wanderingGuards[randomNumber],
		},
	}

	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = true

	ModUtils:Log("Entity spawned")
end
System.AddCCommand(ModMain.prefix .. 'SpawnWanderingGuard', 'ModSoul:SpawnWanderingGuard()', "Spawn a wandering guard")