--- @class ModInventory Manages player inventory and items
ModInventory = {}

--- Dump the player's inventory to the log
function ModInventory:DumpPlayerInventory()
	local count = player.inventory:GetCount()
	ModUtils:Log("Inventory count: " .. count)
	
	Database.LoadTable("item")
	local tableData = Database.GetTableInfo("item")
	local rows = tableData.LineCount - 1
	
	for i = 0, rows do
		local lineInfo = Database.GetTableLine("item", i)
		local itemID = lineInfo.item_id
		--TODO: HasItem() doesn't work for some reason
		if (player.inventory.HasItem(itemID)) then
			ModUtils:Log("Item: " .. itemID .. " (" .. lineInfo.item_name .. ")")
		end
	end
end
System.AddCCommand(ModMain.prefix .. 'DumpPlayerInventory', 'ModInventory:DumpPlayerInventory()', "Dumps the player's inventory to the log")

--- Equip an item to the player
--- @param _itemID string The item ID
function ModInventory:EquipItem(_itemID)
	local id = ItemManager.CreateItem(tostring(_itemID), 100, 1)
	player.inventory:AddItem(id)
	player.actor:EquipInventoryItem(id)
end
System.AddCCommand(ModMain.prefix .. 'EquipItem', 'ModInventory:EquipItem(%line)', "Equips an item to the player")