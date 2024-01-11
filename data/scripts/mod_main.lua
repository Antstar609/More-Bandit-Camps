modMain = {
	name = "TestMod",
	version = "0.0.1",
	modPrefix = '',
}

function modMain:Log(message)
	System.LogAlways(self.name .. " ~ " .. message)
end

function modMain:LogOnScreen(message, forceClear, time)
	local _forceClear = forceClear or false
	local _time = time or 3
	
	Game.SendInfoText(message, _forceClear, nil, _time)
end

-- Listener for the scene init event
function modMain:sceneInitListener(actionName, eventName, eventArgs)

	if eventArgs then
		--modMain:Log("eventArgs: " .. eventName)
	end

	if actionName == "sys_loadingimagescreen" and eventName == "OnEnd" then
		-- When the scene is loaded
		System.LogAlways(self.name .. " loaded " .. "(v" .. self.version .. ")")
		local testEntity = System.SpawnEntity({ class = "TestEntity", name = "TestEntity", position = { x = 0, y = 0, z = 0 } })
		local campEntity = System.SpawnEntity({ class = "CampEntity", name = "CampEntity", position = player:GetWorldPos() })
	end
end

-- Register the listener
UIAction.RegisterActionListener(modMain, "", "", "sceneInitListener")