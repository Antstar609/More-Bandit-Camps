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
		local item = {
			name = lineInfo.item_name,
			id = lineInfo.item_id,
		}
		-- TODO: Find a way to get the player's items list or to check if the player has a specific item
		--if (player.inventory:HasItem(ItemManager.GetItem(item.id))) then
		--	ModUtils:Log("Item: " .. itemID .. " (" .. lineInfo.item_name .. ")")
		--end
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