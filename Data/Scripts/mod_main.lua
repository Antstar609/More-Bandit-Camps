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
		
		--TODO: This function is actually called every time there's a loading screen (reload save or player death) and i don't want to add or create a new camp to the list everytime
		ModCamps:SpawnCamp("TestCamp", "test", "easy")
	end
end

-- Register the listener
UIAction.RegisterActionListener(ModMain, "", "", "sceneInitListener")