modSoul = {}

modSoul.isDatabaseLoaded = false
modSoul.soulType = {
	"villager", -- 1
	"bandit", -- 2
	"guard", -- 3
	"soldier", -- 4
	"cuman", -- 5
	"townsman", -- 6
	"miner", -- 7
	"mason", -- 8
	"wanderer", -- 9
	"bailiff", -- 10
	"merchant", -- 11
	"horse", -- 12
	"weaponsmith", -- 13
	"circator", -- 14
	"lumberjack", -- 15
	"baker", -- 16
	"collier", -- 17
	"herold", -- 18
	"watchman", -- 19
	"innkeeper", -- 20
	"monk", -- 21
	"priest", -- 22
	"beggar", -- 23
	"executioner", -- 24
	"tanner", -- 25
	"armorer", -- 26
	"tailor", -- 27
	"blacksmith", -- 28
	"butcher", -- 29
	"shopGuard", -- 30
	"mercenary" -- 31
}

function modSoul:CheckValidType(type)

	for i, v in ipairs(modSoul.soulType) do
		if v == type then
			return true
		end
	end
end

function modSoul:GetSoulsFromDatabase(type)

	if modSoul:CheckValidType(type) then
		local souls = {}
		local tableName = "v_soul_character_data"
		
		--not sure if i need to load the database in the first place
		if not modSoul.isDatabaseLoaded then
			Database.LoadTable(tableName)
			modSoul.isDatabaseLoaded = true
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
		modMain:Log("Type not found")
	end
end