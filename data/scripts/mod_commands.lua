mod_commands = {}

function mod_commands:showText()
	message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand('showText', 'mod_commands:showText()', "Shows the intro banner from startup")

---------------------------------------------------------------------------------------------------

function mod_commands:printText()
	Game.SendInfoText("Ceci est un test !", false, nil, 5)
end
System.AddCCommand('printText', 'mod_commands:printText()', "Print text to the screen")

---------------------------------------------------------------------------------------------------

function mod_commands:listEntities()
	entities = System.GetEntities(player:GetWorldPos(), 2)
	for i, entity in ipairs(entities) do
		mod_main:Log("Name: " .. entity:GetName() .. " | Class: " .. entity.class)
	end
end
System.AddCCommand('listEntities', 'mod_commands:listEntities()', "List entities in a sphere")

---------------------------------------------------------------------------------------------------

function mod_commands:spawnEntity()
	local spawnParams = {}
	spawnParams.class = "NPC"
	spawnParams.name = "SpawnedEntity"
	spawnParams.position = player:GetWorldPos()
	spawnParams.orientation = { x = 0, y = 0, z = 0 }
	spawnParams.properties = {}
	spawnParams.properties.sharedSoulGuid = "4664d3f6-1aa0-ebea-25c8-9d131258deb9" --skalice guard

	local entity = System.SpawnEntity(spawnParams)
	-- now i can access entity stuff
	
	mod_main:Log("Spawned entity")
end
System.AddCCommand('spawnEntity', 'mod_commands:spawnEntity()', "Spawn an entity")