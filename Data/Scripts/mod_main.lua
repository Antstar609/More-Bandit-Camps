--- @class ModMain The main mod class
--- @field name string Name of the mod
--- @field version string Version of the mod
--- @field prefix string Prefix for the console commands
ModMain = {
	name = "MoreBanditCamps",
	version = "0.0.1",
	prefix = '',
}

-- Listener for the scene init event
function ModMain:sceneInitListener(_actionName, _eventName, _eventArgs)
	if (_eventArgs) then
		--ModUtils:Log("eventArgs: " .. eventName)
	end

	if (_actionName == "sys_loadingimagescreen") and (_eventName == "OnEnd") then
		-- When the scene is loaded
		ModUtils:Log(self.name .. " loaded " .. "(v" .. self.version .. ")")

		--System.SpawnEntity({name = "LocEntity", class = "TestEntity", position = {x = 0, y = 0, z = 0}})
		
		System.SpawnEntity({name = "QuestEntity", class = "QuestEntity", position = {x = 0, y = 0, z = 0}})
	end
end

-- Register the listener
UIAction.RegisterActionListener(ModMain, "", "", "sceneInitListener")