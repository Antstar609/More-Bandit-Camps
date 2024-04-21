--- @class MBCInventory Manages player inventory and items
MBCInventory = {
	inventory = {
		name = "",
		id = "",
	}
}

--- Dump the player's inventory to the log
function MBCInventory:DumpPlayerInventory()
	--local count = player.inventory:GetCount()
	--MBCUtils:Log("Inventory count: " .. count)

	Database.LoadTable("item")
	local tableData = Database.GetTableInfo("item")
	local rows = tableData.LineCount - 1

	for i = 0, rows do
		local lineInfo = Database.GetTableLine("item", i)
		local item = {
			name = lineInfo.item_name,
			id = lineInfo.item_id,
		}

		if (Utils.HasItem(player, item.id)) then
			table.insert(self.inventory, item)
		end
	end
end
System.AddCCommand(MBCMain.prefix .. 'DumpPlayerInventory', 'MBCInventory:DumpPlayerInventory()', "Dumps the player's inventory to the log")

--- Equip an item to the player
--- @param _itemID string The item ID
function MBCInventory:EquipItem(_itemID)
	-- ItemManager.CreateItem(_itemID, _health, _amount)
	local id = ItemManager.CreateItem(tostring(_itemID), 100, 1)
	player.inventory:AddItem(id)
	player.actor:EquipInventoryItem(id)
end
System.AddCCommand(MBCMain.prefix .. 'EquipItem', 'MBCInventory:EquipItem(%line)', "Equips an item to the player")

function MBCInventory:TestInventory()
	if (#self.inventory == 0) then
		MBCUtils:Log("Run DumpPlayerInventory first")
		return
	end
	
	MBCUtils:Log("Inventory count: " .. #self.inventory .. " / Count from player: " .. player.inventory:GetCount())
	for _, item in ipairs(self.inventory) do
		MBCUtils:Log("Item: " .. item.name .. " (" .. item.id .. ")")
	end
end
System.AddCCommand(MBCMain.prefix .. 'TestInventory', 'MBCInventory:TestInventory()', "Tests the inventory")