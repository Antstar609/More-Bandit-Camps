modCommands = {}

function modCommands:ShowText()

	message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand('ShowText', 'modCommands:ShowText()', "Shows the intro banner from startup")

---------------------------------------------------------------------------------------------------

function modCommands:PrintText()

	Game.SendInfoText("Ceci est un test !", false, nil, 5)
end
System.AddCCommand('PrintText', 'modCommands:PrintText()', "Print text to the screen")

---------------------------------------------------------------------------------------------------

function modCommands:ListEntities()

	entities = System.GetEntities(player:GetWorldPos(), 2)
	for i, entity in ipairs(entities) do
		modMain:Log("Name: " .. entity:GetName() .. " | Class: " .. entity.class)
	end
end
System.AddCCommand('ListEntities', 'modCommands:ListEntities()', "List entities in a sphere")

---------------------------------------------------------------------------------------------------

