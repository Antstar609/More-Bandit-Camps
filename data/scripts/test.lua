System.LogAlways("////////// TESTMOD LOADED //////////")

test_init = {}

-- Listener for the scene init event
function test_init:sceneInitListener(actionName, eventName, eventArgs)
	System.LogAlways("actionName: " .. actionName)
	System.LogAlways("eventName: " .. eventName)

	if eventArgs then
		System.LogAlways("eventArgs: " .. tostring(eventName))
	end

	if actionName == "sys_loadingimagescreen" and eventName == "OnEnd" then
		-- When the scene is loaded
		if (testEntity == nil) then
			testEntity = System.SpawnEntity({ class = "TestEntity", name = "TestEntity", position = { x = 0, y = 0, z = 0 } })
		else
			System.LogAlways("TestEntity not spawned")
		end
	end
end

-- Register the listener
UIAction.RegisterActionListener(test_init, "", "", "sceneInitListener")