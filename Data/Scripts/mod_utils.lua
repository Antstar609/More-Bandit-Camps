--- @class ModUtils Utility functions
ModUtils = {}

--- Logs a message to the console
--- @param _message string Message to log
function ModUtils:Log(_message)
	System.LogAlways("$5[" .. ModMain.name .. "] " .. tostring(_message))
end

--- Logs a message to the screen
--- @param _message string Message to show
--- @param _forceClear boolean Force clear the screen (default: false)
--- @param _time number Time in seconds to show the message (default: 3)
function ModUtils:LogOnScreen(_message, _forceClear, _time)
	Game.SendInfoText(tostring(_message), _forceClear or false, nil, _time or 3)
end

--- Prints the player's location to the console and the screen
function ModUtils:PrintLoc()
	local pos = player:GetWorldPos()
	self:Log(Vec2Str(pos))
	self:LogOnScreen(Vec2Str(pos), true, 10)
end
System.AddCCommand(ModMain.prefix .. 'Loc', 'ModUtils:PrintLoc()', "Prints the player's location")

--- Shows the intro banner from startup (temporary)
function ModUtils:ShowTextbox()
	local message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand(ModMain.prefix .. 'ShowText', 'ModUtils:ShowText()', "Shows the intro banner from startup")