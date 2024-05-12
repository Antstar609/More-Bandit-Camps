--- @class MBCMain The main mod class
--- @field name string Name of the mod
--- @field version string Version of the mod
--- @field prefix string Prefix for the console commands
MBCMain = {
	name = "MoreBanditCamps",
	version = "0.1",
	prefix = '',
}

-- Listener for the scene init event
function MBCMain:sceneInitListener(_actionName, _eventName, _eventArgs)
	if (_eventArgs) then
		--MBCUtils:Log("eventArgs: " .. eventName)
	end

	if (_actionName == "sys_loadingimagescreen") and (_eventName == "OnEnd") then
		-- When the scene is loaded
		MBCUtils:Log(self.name .. " loaded " .. "(v" .. self.version .. ")")
		MBCUtils:ShowTextbox()
		MBCQuest:InitQuest()

		--for locationName in pairs(MBCCamps.locations) do
		--	MBCCamps:SpawnCamp(locationName, "none", false)
		--end
	end
end

-- Register the listener
UIAction.RegisterActionListener(MBCMain, "", "", "sceneInitListener")