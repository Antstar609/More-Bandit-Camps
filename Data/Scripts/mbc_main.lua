--- @class MBC_Main The main mod class
--- @field name string Name of the mod
--- @field version string Version of the mod
--- @field prefix string Prefix for the console commands
MBC_Main = {
	name = "More Bandit Camps",
	version = "1.3.2",
	prefix = 'mbc_',
	debugLog = true
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
			.. "Instead, use the <font color='#0000ff'>'mbc_uninstall'</font> command first to properly remove it."
			.. "\n\nIf you have any issue with the mod, use <font color='#0000ff'>'mbc_runModDiagnostic'</font>\nto check if the mod is working fine."
			.. "</font>"

	Game.ShowTutorial(message, 20, false, true);
end
System.AddCCommand(MBC_Main.prefix .. 'intro', 'MBC_Main:Intro()', "Shows the intro banner from startup")

--- Uninstalls the mod
function MBC_Main:Uninstall()
	MBC_Utils:Log("Uninstalling mod")

	local allEntities = System.GetEntities()

	for i, entity in ipairs(allEntities) do
		-- remove all entities with the name 'MBCCamp'
		if (entity:GetName() == "MBCCamp") then
			MBCCampEntity:DestroyCamp()
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("MBCCamp removed")
		end
		-- remove all tagpoints
		if (entity:GetName() == "Tagpoint") then
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("Tagpoint removed")
		end
		-- remove all quest npcs
		if (entity:GetName() == "QuestNPC") then
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("QuestNPC removed")
		end
		-- remove all entities with the prefix 'mbc_' (new bandits)
		if (string.find(entity:GetName(), "mbc_")) then
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("Entity removed: " .. entity:GetName())
		end
		-- remove all entities with the prefix 'event_spawn_bandit' (old bandits)
		if (string.find(entity:GetName(), "event_spawn_bandit")) then
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("Entity removed: " .. entity:GetName())
		end
		-- remove all entities with the prefix 'bandit_' (old bandits)
		if (string.sub(entity:GetName(), 1, 7) == "bandit_" and entity:GetName() ~= "bandit_all") then
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("Entity removed: " .. entity:GetName())
		end
	end

	QuestSystem.CancelQuest("q_morebanditcamps", 1)
	MBC_Utils:LogOnScreen(self.name .. " uninstalled, you can now safely remove the mod from the folder")
end
System.AddCCommand(MBC_Main.prefix .. 'uninstall', 'MBC_Main:Uninstall()', "Uninstalls the mod")

--- Cleans the entities and repair the mod
function MBC_Main:Repair()
	MBC_Utils:Log("Cleaning entities and repairing the mod")

	local allEntities = System.GetEntities()
	local hasRepairedSomething = false
	local tagpointCount = 0
	local campCount = 0
	local npcCount = 0

	for i, entity in ipairs(allEntities) do
		if (entity:GetName() == "MBCCamp") then
			campCount = campCount + 1
			if (campCount > 1) then
				hasRepairedSomething = true
				System.RemoveEntity(allEntities[i].id)
				MBC_Utils:Log("Entity removed: " .. entity:GetName())
			end
		end
		if (entity:GetName() == "Tagpoint") then
			tagpointCount = tagpointCount + 1
			if (tagpointCount > 1) then
				hasRepairedSomething = true
				System.RemoveEntity(allEntities[i].id)
				MBC_Utils:Log("Entity removed: " .. entity:GetName())
			end
		end
		if (entity:GetName() == "QuestNPC") then
			npcCount = npcCount + 1
			if (npcCount > 1) then
				hasRepairedSomething = true
				System.RemoveEntity(allEntities[i].id)
				MBC_Utils:Log("Entity removed: " .. entity:GetName())
			end
		end
		if (string.find(entity:GetName(), "event_spawn_bandit") and not string.find(entity:GetName(), "mbc_")) then
			hasRepairedSomething = true
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("Entity removed: " .. entity:GetName())
		end
		if (string.sub(entity:GetName(), 1, 7) == "bandit_" and entity:GetName() ~= "bandit_all") then
			hasRepairedSomething = true
			System.RemoveEntity(allEntities[i].id)
			MBC_Utils:Log("Entity removed: " .. entity:GetName())
		end
	end

	if (hasRepairedSomething == true) then
		MBC_Utils:LogOnScreen("Entities cleaned, mod repaired")
	else
		MBC_Utils:LogOnScreen("Nothing to repair")
	end
end
System.AddCCommand(MBC_Main.prefix .. 'repair', 'MBC_Main:Repair()', "Cleans the entities and repair the mod")

--- Runs a diagnostic to check if the mod is working fine
function MBC_Main:RunModDiagnostic()
	MBC_Utils:Log("Running diagnostics")

	local allEntities = System.GetEntities()
	local tagpointCount = 0
	local campCount = 0
	local npcCount = 0
	local banditSpawned = false
	local oldEntities = false

	for _, entity in ipairs(allEntities) do
		local pos = entity:GetWorldPos()
		if (entity:GetName() == "MBCCamp") then
			campCount = campCount + 1
			MBC_Utils:Log("Camp : " .. Vec2Str(pos))
		end
		if (entity:GetName() == "Tagpoint") then
			tagpointCount = tagpointCount + 1
			MBC_Utils:Log("Tagpoint : " .. Vec2Str(pos))
		end
		if (entity:GetName() == "QuestNPC") then
			npcCount = npcCount + 1
			MBC_Utils:Log("QuestNPC : " .. Vec2Str(pos))
		end
		if (string.find(entity:GetName(), "mbc_")) then
			banditSpawned = true
			local banditsStatus = ""
			if (entity:IsDead()) then
				banditsStatus = " (dead)"
			else
				banditsStatus = " (alive)"
			end
			MBC_Utils:Log("Entity : " .. entity:GetName() .. banditsStatus .. " : " .. Vec2Str(pos))
		end
		if (string.find(entity:GetName(), "event_spawn_bandit") and not string.find(entity:GetName(), "mbc_")) then
			oldEntities = true
			MBC_Utils:Log("Old Entity : " .. entity:GetName() .. " : " .. Vec2Str(pos))
		end
		if (string.sub(entity:GetName(), 1, 7) == "bandit_" and entity:GetName() ~= "bandit_all") then
			oldEntities = true
			MBC_Utils:Log("Old Entity : " .. entity:GetName() .. " : " .. Vec2Str(pos))
		end
	end

	if (campCount > 1 or tagpointCount > 1 or npcCount > 1 or oldEntities == true) then
		MBC_Utils:LogOnScreen("Something went wrong with the mod, please use the `mbc_repair` command, save and reload the save", true, 10)
	elseif (campCount <= 0 and tagpointCount <= 0 and npcCount <= 0 and oldEntities == false and banditSpawned == false) then
		MBC_Utils:LogOnScreen("Mod uninstalled", true, 5)
	else
		MBC_Utils:LogOnScreen("Mod is working fine", true, 5)
	end
end
System.AddCCommand(MBC_Main.prefix .. 'runModDiagnostic', 'MBC_Main:RunModDiagnostic()', "Runs a diagnostic to check if the mod is working fine")