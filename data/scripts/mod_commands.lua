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

System.AddCCommand('spawnEntity', 'modSoul:spawnEntity(%line)', "Spawn an entity")

---------------------------------------------------------------------------------------------------

function modCommands:enableCamp()
	Game.SendInfoText("Camp enabled", false, nil, 1)
	modMain.temp = true
end
System.AddCCommand('enableCamp', 'modCommands:enableCamp()', "Enable camp")