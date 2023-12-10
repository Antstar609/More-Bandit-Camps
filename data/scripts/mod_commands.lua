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
		mod_main:Log(entity:GetName())
	end
end
System.AddCCommand('listEntities', 'mod_commands:listEntities()', "List entities in a sphere")

---------------------------------------------------------------------------------------------------

