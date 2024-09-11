--- @class MBC_Main The main mod class
--- @field name string Name of the mod
--- @field version string Version of the mod
--- @field prefix string Prefix for the console commands
MBC_Main = {
	name = "More Bandit Camps",
	version = "1.0.2",
	prefix = 'mbc_',
	debug = true
}

-- Listener for the scene init event
function MBC_Main:sceneInitListener(_actionName, _eventName, _eventArgs)
	if (_eventArgs) then
		--MBC_Utils:Log("eventArgs: " .. eventName)
	end

	if (_actionName == "sys_loadingimagescreen") and (_eventName == "OnEnd") then
		-- When the scene is loaded
		MBC_Utils:Log(self.name .. " loaded " .. "(v" .. self.version .. ")")
		MBC_Utils:ShowTextbox()
		MBC_Quest:InitQuest()
	end
end

-- Register the listener
UIAction.RegisterActionListener(MBC_Main, "", "", "sceneInitListener")