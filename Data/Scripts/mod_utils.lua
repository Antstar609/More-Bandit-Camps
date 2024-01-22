---@class ModUtils Utility functions
ModUtils = {}

--- Logs a message to the console
--- @param message string Message to log
function ModUtils:Log(message)
	System.LogAlways("$5[" .. ModMain.name .. "] " .. tostring(message))
end

--- Logs a message to the screen
--- @param message string Message to show
--- @param forceClear boolean Force clear the screen (default: false)
--- @param time number Time in seconds to show the message (default: 3)
function ModUtils:LogOnScreen(message, forceClear, time)
	Game.SendInfoText(tostring(message), forceClear or false, nil, time or 3)
end

--- Shows the intro banner from startup (temporary)
function ModUtils:ShowTextbox()
	local message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand(ModMain.prefix .. 'ShowText', 'ModUtils:ShowText()', "Shows the intro banner from startup")