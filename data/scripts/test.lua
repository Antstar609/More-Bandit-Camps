System.LogAlways("////////// TESTMOD LOADED //////////")

test_init = {}

function showText()
	message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true)
end

-- Listener for the scene init event
function test_init:sceneInitListener(actionName, eventName, eventArgs)
	System.LogAlways("actionName: " .. actionName)
	System.LogAlways("eventName: " .. eventName)

	if eventArgs then
		System.LogAlways("eventArgs: " .. tostring(eventName))
	end

	if actionName == "sys_loadingimagescreen" and eventName == "OnEnd" then
		-- When the scene is loaded
		showText()

		if (testEntity == nil) then
			testEntity = System.SpawnEntity({class = "TestEntity", name = "TestEntity", position = {x = 0, y = 0, z = 0}})
		end
	end
end

-- Register the listener
UIAction.RegisterActionListener(test_init, "", "", "sceneInitListener")

System.AddCCommand('showText', 'showText()', "Shows the intro banner from startup")

function printText()
	Game.SendInfoText("Ceci est un test !", false, nil, 5)
end

System.AddCCommand('printText', 'printText()', "Print text to the screen")