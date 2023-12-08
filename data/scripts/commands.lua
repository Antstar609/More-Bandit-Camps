function printText()
	Game.SendInfoText("Ceci est un test !", false, nil, 5)
end
System.AddCCommand('printText', 'printText()', "Print text to the screen")

---------------------------------------------------------------------------------------------------

function listEntities()
	center = System.GetEntityByName("dude"):GetWorldPos()
	entities = System.GetEntities(center, 2)
	for i, entity in ipairs(entities) do
		System.LogAlways(entity:GetName())
	end
end
System.AddCCommand('listEntities', 'listEntities()', "List entities in a sphere")

---------------------------------------------------------------------------------------------------

function spawnEntity()
    local entityParams = {
        class = "NPC_Female",
        name = "MyEntity",
        position = System.GetEntityByName("dude"):GetWorldPos()
    }
    local newEntity = System.SpawnEntity(entityParams)
    if newEntity then
        System.LogAlways("Entity spawned: " .. newEntity:GetName())
    else  
        System.LogAlways("Failed to spawn entity")
    end
end
System.AddCCommand('spawnEntity', 'spawnEntity()', "Spawns an entity")