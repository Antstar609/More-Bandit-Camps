modCommands = {}

function modCommands:ShowText()

	message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand(modMain.modPrefix .. 'ShowText', 'modCommands:ShowText()', "Shows the intro banner from startup")

---------------------------------------------------------------------------------------------------

function modCommands:PrintText()

	Game.SendInfoText("Ceci est un test !", false, nil, 5)
end
System.AddCCommand(modMain.modPrefix .. 'PrintText', 'modCommands:PrintText()', "Print text to the screen")

---------------------------------------------------------------------------------------------------

function modCommands:ListEntities()

	entities = System.GetEntities(player:GetWorldPos(), 2)
	for i, entity in ipairs(entities) do
		modMain:Log("Name: " .. entity:GetName() .. " | Class: " .. entity.class)
	end
end
System.AddCCommand(modMain.modPrefix .. 'ListEntities', 'modCommands:ListEntities()', "List entities in a sphere")

---------------------------------------------------------------------------------------------------

function modSoul:GetSubbrainFromDatabase()

	local subbrains = {}
	local tableName = "subbrain"

	Database.LoadTable(tableName)
	local tableData = Database.GetTableInfo(tableName)
	local rows = tableData.LineCount - 1

	for i = 0, rows do
		local lineInfo = Database.GetTableLine(tableName, i)
		local subbrain = {}
		subbrain.name = lineInfo.subbrain_name
		subbrain.id = lineInfo.subbrain_id
		subbrain.row = i + 12 --to match the line in the xml file
		table.insert(subbrains, subbrain)
	end

	return subbrains
end

function modSoul:PrintSubbrains()

	local subbrains = self:GetSubbrainFromDatabase()
	for i, sb in ipairs(subbrains) do
		modMain:Log("Subbrain | Name: " .. sb.name .. " | Id: " .. sb.id .. " | Row: " .. sb.row)
	end
end
System.AddCCommand(modMain.modPrefix .. 'PrintSubbrains', 'modSoul:PrintSubbrains()', "Print all subbrains")

---------------------------------------------------------------------------------------------------

