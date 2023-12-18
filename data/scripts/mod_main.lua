System.LogAlways("////////// TESTMOD LOADED //////////")

modMain = {}
modMain.name = "TestMod"
modMain.version = "0.0.1"

modMain.temp = false

function modMain:Log(message)
	System.Warning(self.name .. " ~ " .. message)
end

-- Listener for the scene init event
function modMain:sceneInitListener(actionName, eventName, eventArgs)

	if eventArgs then
		--modMain:Log("eventArgs: " .. eventName)
	end

	if actionName == "sys_loadingimagescreen" and eventName == "OnEnd" then
		-- When the scene is loaded
		local testEntity = System.SpawnEntity({ class = "TestEntity", name = "TestEntity", position = { x = 0, y = 0, z = 0 } })
		local campEntity = System.SpawnEntity({ class = "CampEntity", name = "CampEntity", position = player:GetWorldPos() })
		--System.SpawnEntity({ class = "Fish", name = "Fish", position = player:GetWorldPos() })
		
		local subbrain = modSoul:GetSubbrainFromDatabase()
		for i, sb in ipairs(subbrain) do
			modMain:Log("Subbrain name: " .. sb.name .. " | Subbrain id: " .. sb.id .. " | Subbrain row: " .. sb.row)
		end
	end
end

-- Register the listener
UIAction.RegisterActionListener(modMain, "", "", "sceneInitListener")