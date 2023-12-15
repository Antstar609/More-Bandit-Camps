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
	"horse",
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
		modMain:Log("Type not in the list")
	end
end