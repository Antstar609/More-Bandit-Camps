---@class MBC_Quest Quest manager
---@field npcPosition table Position of the NPC (x, y, z)
MBC_Quest = {
	npcPosition = { x = 983.452, y = 1554.807, z = 25.205 },
	spawnedCamp = {
		name = "",
		difficulty = 0
	},
	difficultyRewards = {
		0, -- none
		1000, -- easy
		2000, -- medium
		3000 -- hard
	}
}

--- Start the quest
function MBC_Quest:InitQuest()
	--Remove the old entity to maintain compatibility with the previous version
	if (System.GetEntityByName("marechal") ~= nil) then
		System.RemoveEntity(System.GetEntityIdByName("marechal"))
	end

	-- if the quest is not started, spawn the npc and start the quest
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		MBC_Utils:Log("Quest not started")
		
		MBC_Soul:SpawnQuestNPC(self.npcPosition, { x = 0, y = 0, z = 90 })
		
		-- reset the quest to remove it from the failed quest if the user used the mbc_uninstall command
		QuestSystem.ResetQuest("q_morebanditcamps")
		
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
	else
		-- if the quest is already started
		MBC_Utils:Log("Quest already started")
		
		-- if there is a camp spawned respawn the models
		if (System.GetEntityByName("MBCCamp")) then
			MBC_Camps:SpawnModels(self.spawnedCamp.name, MBC_Camps.locations[self.spawnedCamp.name])
			MBC_Utils:Log("Camp models respawned")
		end
		
		-- if the QuestNPC is not present spawn it
		if (System.GetEntityByName("QuestNPC") == nil) then
			MBC_Soul:SpawnQuestNPC(self.npcPosition, { x = 0, y = 0, z = 90 })
			MBC_Utils:Log("NPC missing, spawned")
		end

		-- if  the QuestNPC is dead remove it and respawn it
		if (System.GetEntityByName("QuestNPC"):IsDead()) then
			System.RemoveEntity(System.GetEntityIdByName("QuestNPC"))
			MBC_Soul:SpawnQuestNPC(self.npcPosition, { x = 0, y = 0, z = 90 })
			MBC_Utils:Log("NPC is dead, respawned")
		end

		-- set the attributes of the npc
		MBC_Soul:SetQuestNPCAttributes(System.GetEntityByName("QuestNPC"))
	end
end

--- Restart the quest
function MBC_Quest:RestartQuest()
	-- reset and activate the quest, no need to spawn a new npc its already there
	QuestSystem.ResetQuest("q_morebanditcamps")
	--QuestSystem.ActivateQuest("q_morebanditcamps", false)

	-- if the quest is not started, start it and start the objective talk
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
	end
end
System.AddCCommand(MBC_Main.prefix .. 'reset', 'MBC_Quest:RestartQuest()', "Reset the quest")

--- Interact with the NPC to progress the quest
function MBC_Quest:NCPInteract()
	-- self doesn't work here
	MBC_Quest:DialogueSequence()
end

function MBC_Quest:DialogueSequence()
	if (QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		if (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_talk")) then
			MBC_Quest:Talk()
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_destroycamp")) then
			MBC_Utils:LogOnScreen("@ui_text_npc_waiting")
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_reward")) then
			MBC_Quest:Reward()
		end
	end
end

function MBC_Quest:QuestSequence()
	if (QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		if (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_talk")) then
			self:Talk()
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_destroycamp")) then
			self:DestroyCamp()
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_reward")) then
			self:Reward()
		end
	end
end
System.AddCCommand(MBC_Main.prefix .. 'nextObjective', 'MBC_Quest:QuestSequence()', "Pass to the next objective of the quest")

--- Talk to the NPC sequence
function MBC_Quest:Talk()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_talk")) then

		self.spawnedCamp.name, self.spawnedCamp.difficulty = MBC_Quest:RandomCamp()

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_talk", false)
		QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp", false)

		MBC_Utils:LogOnScreen("@ui_text_npc_location")
	end
end

--- Destroy the camp sequence
function MBC_Quest:DestroyCamp()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp", false)
		QuestSystem.StartObjective("q_morebanditcamps", "o_reward", false)

		MBC_Utils:LogOnScreen("@ui_text_npc_destroyed")
	end
end

--- Reward sequence
function MBC_Quest:Reward()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_reward")) then

		local reward = self.difficultyRewards[self.spawnedCamp.difficulty] or 0
		AddMoneyToInventory(player, reward * 10)

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward", false)

		MBC_Quest:RestartQuest()
	end
end

function MBC_Quest:RandomCamp()

	-- Location
	local keys = {}
	for key in pairs(MBC_Camps.locations) do
		table.insert(keys, key)
	end
	local location = keys[math.random(2, #keys)]

	-- Difficulty
	local difficulty = MBC_Camps.difficulty[math.random(2, #MBC_Camps.difficulty)]

	-- Spawn the camp
	MBC_Camps:SpawnCamp(location, difficulty)

	return location, difficulty
end