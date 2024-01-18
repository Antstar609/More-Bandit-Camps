ModUtils = {}

function ModUtils:Log(message)
	System.LogAlways("$5" .. ModMain.name .. " ~ " .. tostring(message))
end

function ModUtils:LogOnScreen(message, forceClear, time)
	Game.SendInfoText(tostring(message), forceClear or false, nil, time or 3)
end

function ModUtils:ShowTextbox()
	local message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand(ModMain.prefix .. 'ShowText', 'ModUtils:ShowText()', "Shows the intro banner from startup")