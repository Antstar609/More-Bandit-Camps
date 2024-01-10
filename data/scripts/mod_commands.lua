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

function modCommands:GetDatabase(tableName)

	local data = {}
	Database.LoadTable(tableName)
	local tableData = Database.GetTableInfo(tableName)

	local columnsSize = tableData.ColumnCount
	modMain:Log("Columns: " .. tostring(columnsSize))
	for i = 0, columnsSize do
		local columnInfo = Database.GetTableColumnData(tableName, i)
		modMain:Log("Name: " .. tostring(columnInfo.name))
	end

	local rowsSize = tableData.LineCount
	modMain:Log("Rows: " .. tostring(rowsSize))
	for i = 0, rowsSize do
		local lineInfo = Database.GetTableLine(tableName, i)
	end

	return data
end

function modCommands:PrintDatabase(line)

	local database = self:GetDatabase(line)
	for i, data in ipairs(database) do
	end
end
System.AddCCommand(modMain.modPrefix .. 'PrintDatabase', 'modCommands:PrintDatabase(%line)', "Print a database")

---------------------------------------------------------------------------------------------------

