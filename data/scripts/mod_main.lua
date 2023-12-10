System.LogAlways("////////// TESTMOD LOADED //////////")

mod_main = {}
mod_main.name = "TestMod"
mod_main.version = "0.0.1"

function mod_main:Log(message)
	System.LogAlways(mod_main.name .. " ~ " .. message)
end

-- Listener for the scene init event
function mod_main:sceneInitListener(actionName, eventName, eventArgs)
	if eventArgs then
		--mod_main:Log("eventArgs: " .. tostring(eventName))
	end

	if actionName == "sys_loadingimagescreen" and eventName == "OnEnd" then
		-- When the scene is loaded
		mod_commands:showText()
		local testEntity = System.SpawnEntity({ class = "NPC", name = "TestEntity", position = player:GetWorldPos() })
	end
end

-- Register the listener
UIAction.RegisterActionListener(mod_main, "", "", "sceneInitListener")