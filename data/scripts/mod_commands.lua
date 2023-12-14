modCommands = {}

function modCommands:showText()
	message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand('showText', 'modCommands:showText()', "Shows the intro banner from startup")

---------------------------------------------------------------------------------------------------

function modCommands:printText()
	Game.SendInfoText("Ceci est un test !", false, nil, 5)
end
System.AddCCommand('printText', 'modCommands:printText()', "Print text to the screen")

---------------------------------------------------------------------------------------------------

function modCommands:listEntities()
	entities = System.GetEntities(player:GetWorldPos(), 2)
	for i, entity in ipairs(entities) do
		modMain:Log("Name: " .. entity:GetName() .. " | Class: " .. entity.class)
	end
end
System.AddCCommand('listEntities', 'modCommands:listEntities()', "List entities in a sphere")

---------------------------------------------------------------------------------------------------

function modCommands:spawnEntity()

	local souls = modSoul:GetSoulsFromDatabase("soldier")
	local randomNumber = math.random(1, #souls)

	local spawnParams = {}
	spawnParams.class = "NPC"
	spawnParams.name = souls[randomNumber].name
	spawnParams.position = player:GetWorldPos()
	spawnParams.orientation = player:GetWorldPos()
	spawnParams.properties = {}
	spawnParams.properties.sharedSoulGuid = souls[randomNumber].id

	local entity = System.SpawnEntity(spawnParams)
	entity.AI.invulnerable = true

	modMain:Log("Name : " .. entity:GetName() .. " | ID : " .. spawnParams.properties.sharedSoulGuid) --can't access to the ID on the entity
end
System.AddCCommand('spawnEntity', 'modCommands:spawnEntity()', "Spawn an entity")