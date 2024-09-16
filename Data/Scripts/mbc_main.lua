--- @class MBC_Main The main mod class
--- @field name string Name of the mod
--- @field version string Version of the mod
--- @field prefix string Prefix for the console commands
MBC_Main = {
	name = "More Bandit Camps",
	version = "1.2.2",
	prefix = 'mbc_',
	debugLog = false
}

-- Listener for the scene init event
function MBC_Main:sceneInitListener(_actionName, _eventName, _eventArgs)
	if (_eventArgs) then
		--MBC_Utils:Log("eventArgs: " .. eventName)
	end

	if (_actionName == "sys_loadingimagescreen") and (_eventName == "OnEnd") then
		-- When the scene is loaded
		System.LogAlways("$5[" .. self.name .. "] " .. self.name .. " loaded " .. "(v" .. self.version .. ")")
		MBC_Main:Intro()
		MBC_Quest:InitQuest()
	end
end

-- Register the listener
UIAction.RegisterActionListener(MBC_Main, "", "", "sceneInitListener")

--- Shows the intro banner from startup
function MBC_Main:Intro()
	local message = "<font color='#ff8b00' size='28'>" .. MBC_Main.name .. "</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609" .. "\n"
			.. "v" .. MBC_Main.version .. "</font>"
			.. "\n\n<font size='18'>"
			.. "To remove the mod :\n"
			.. "<font color='#ff0000'>DO NOT delete it directly from the folder.\n</font>"
			.. "Instead, use the 'mbc_uninstall' command first to properly remove it."
			.. "</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand(MBC_Main.prefix .. 'intro', 'MBC_Main:Intro()', "Shows the intro banner from startup")

function MBC_Main:Uninstall()
	if (System.GetEntityByName("MBCCamp") ~= nil) then
		MBCCampEntity:DestroyCamp()
		System.RemoveEntity(System.GetEntityIdByName("MBCCamp"))
	end
	if (System.GetEntityByName("Tagpoint") ~= nil) then
		System.RemoveEntity(System.GetEntityIdByName("Tagpoint"))
	end
	System.RemoveEntity(System.GetEntityIdByName("QuestNPC"))
	QuestSystem.CancelQuest("q_morebanditcamps", 1)
	MBC_Utils:LogOnScreen(self.name .. " uninstalled")
end
System.AddCCommand(MBC_Main.prefix .. 'uninstall', 'MBC_Main:Uninstall()', "Uninstall the mod")