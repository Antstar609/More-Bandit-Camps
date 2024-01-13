ModUtils = {}

function ModUtils:Log(message)
	System.LogAlways(ModMain.name .. " ~ " .. message)
end

function ModUtils:LogOnScreen(message, forceClear, time)
	local _forceClear = forceClear or false
	local _time = time or 3

	Game.SendInfoText(message, _forceClear, nil, _time)
end

---------------------------------------------------------------------------------------------------

function ModUtils:ShowTextbox()
	local message = "<font color='#ff8b00' size='28'>TestMod</font>" .. "\n"
			.. "<font color='#333333' size='20'>Antstar609</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand(ModMain.prefix .. 'ShowText', 'ModUtils:ShowText()', "Shows the intro banner from startup")

function ModUtils:ListEntities()
	local entities = System.GetEntities(player:GetWorldPos(), 2)
	for i, entity in ipairs(entities) do
		ModUtils:Log("Name: " .. entity:GetName() .. " | Class: " .. entity.class)
	end
end
System.AddCCommand(ModMain.prefix .. 'ListEntities', 'ModUtils:ListEntities()', "List entities in a sphere")