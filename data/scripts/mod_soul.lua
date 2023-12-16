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

function modSoul:CheckValidType(type)

	for i, v in ipairs(self.soulType) do
		if v == type then
			return true
		end
	end
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
		spawnParams.class = "NPC"
		spawnParams.name = souls[randomNumber].name
		spawnParams.position = position or player:GetWorldPos()
		spawnParams.orientation = spawnParams.position
		spawnParams.properties = {}
		spawnParams.properties.sharedSoulGuid = souls[randomNumber].id

		local entity = System.SpawnEntity(spawnParams)
		entity.AI.invulnerable = true

		modMain:Log("Name : " .. entity:GetName() .. " | ID : " .. spawnParams.properties.sharedSoulGuid) --can't access to the ID on the entity
		Game.SendInfoText("Entity spawned", false, nil, 1)
	end
end
System.AddCCommand('spawnEntity', 'modSoul:spawnEntity(%line)', "Spawn an entity")