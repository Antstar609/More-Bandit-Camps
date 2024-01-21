---@class ModDatabase : ModScript - Used to get data from any database (.xml files) in the game
ModDatabase = {}

--- Get a database from the game
--- @param tableName string Name of the database
--- @return table Database data
function ModDatabase:GetDatabase(tableName)
	if (not Database.LoadTable(tableName)) then
		ModUtils:Log("No database found")
		return nil
	end

	local tableData = Database.GetTableInfo(tableName)
	local columnsSize = tableData.ColumnCount - 1
	local rowsSize = tableData.LineCount - 1

	local data = {}
	for row = 0, rowsSize do
		local line = {}
		local lineInfo = Database.GetTableLine(tableName, row)

		for column = 0, columnsSize do
			local columnInfo = Database.GetColumnInfo(tableName, column)
			line[columnInfo.Name] = lineInfo[columnInfo.Name]
		end
		table.insert(data, line)
	end

	return data
end

--- Print a database to the console
--- @param databaseName string Name of the database
function ModDatabase:PrintDatabase(databaseName)
	local database = self:GetDatabase(databaseName)

	if (database == nil) then
		return
	end

	for i, data in ipairs(database) do
		ModUtils:Log("Row " .. i .. ":")
		for columnName, columnValue in pairs(data) do
			ModUtils:Log("\t" .. columnName .. ": " .. tostring(columnValue))
		end
	end
end
System.AddCCommand(ModMain.prefix .. 'PrintDatabase', 'ModDatabase:PrintDatabase(%line)', "Print a database")