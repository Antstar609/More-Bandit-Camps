--- @class MBCDatabase Used to get data from any database (.xml files) in the game
MBCDatabase = {}

--- Get a database from the game
--- @param _tableName string Name of the database
--- @return table Database data
function MBCDatabase:GetDatabase(_tableName)
	if (not Database.LoadTable(_tableName)) then
		MBCUtils:Log("No database found")
		return nil
	end

	local tableData = Database.GetTableInfo(_tableName)
	local columnsSize = tableData.ColumnCount - 1
	local rowsSize = tableData.LineCount - 1

	local data = {}
	for row = 0, rowsSize do
		local line = {}
		local lineInfo = Database.GetTableLine(_tableName, row)

		for column = 0, columnsSize do
			local columnInfo = Database.GetColumnInfo(_tableName, column)
			line[columnInfo.Name] = lineInfo[columnInfo.Name]
		end
		table.insert(data, line)
	end

	return data
end

--- Print a database to the console
--- @param _databaseName string Name of the database
function MBCDatabase:PrintDatabase(_databaseName)
	local database = self:GetDatabase(_databaseName)

	if (database == nil) then
		return
	end

	for i, data in ipairs(database) do
		MBCUtils:Log("Row " .. i .. ":")
		for columnName, columnValue in pairs(data) do
			MBCUtils:Log("\t" .. columnName .. ": " .. tostring(columnValue))
		end
	end
end
System.AddCCommand(MBCMain.prefix .. 'PrintDatabase', 'MBCDatabase:PrintDatabase(%line)', "Print a database")