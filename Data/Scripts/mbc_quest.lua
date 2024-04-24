---@class MBCQuest Quest manager
---@field npcPosition table Position of the NPC (x, y, z)
MBCQuest = {
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
function MBCQuest:InitQuest()
	if (System.GetEntityByName("marechal") == nil) then
		-- spawn npc
		MBCSoul:SpawnMarechal(self.npcPosition, { x = 0, y = 0, z = 90 })
		-- reset and activate the quest
		QuestSystem.ResetQuest("q_morebanditcamps")
		--QuestSystem.ActivateQuest("q_morebanditcamps", false)
	else
		-- remove the old npc and spawn a new one to prevent the entity from being faded when the player is far away
		System.RemoveEntity(System.GetEntityIdByName("marechal"))
		MBCSoul:SpawnMarechal(self.npcPosition, { x = 0, y = 0, z = 90 })
	end

	-- if there already is a camp spawned, remove it and reset the quest to avoid the tagpoint not showing up
	if (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_destroycamp")) then
		if (System.GetEntityByName("MBCCamp") ~= nil) then

			-- Remove the old camp entity to prevent the tagpoint from being duplicated
			System.RemoveEntity(System.GetEntityIdByName("MBCCamp"))
			MBCUtils:Log("Camp removed")

			-- Spawn a new camp
			--TODO: Difficulty is not set correctly
			MBCCamps:SpawnCamp(self.spawnedCamp.name, self.spawnedCamp.difficulty, true)
		end
	end

	-- if the quest is not started, start it and start the objective talk
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
	end
end

--- Restart the quest
function MBCQuest:RestartQuest()
	-- reset and activate the quest, no need to spawn a new npc its already there
	QuestSystem.ResetQuest("q_morebanditcamps")
	--QuestSystem.ActivateQuest("q_morebanditcamps", false)

	-- if the quest is not started, start it and start the objective talk
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
	end
end

--- Interact with the NPC to progress the quest
function MBCQuest:NCPInteract()
	-- self doesn't work here
	MBCQuest:DialogueSequence()
end

function MBCQuest:DialogueSequence()
	if (QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		if (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_talk")) then
			MBCQuest:Talk()
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_destroycamp")) then
			MBCUtils:LogOnScreen("@ui_text_npc_waiting")
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_reward")) then
			MBCQuest:Reward()
		end
	end
end

function MBCQuest:QuestSequence()
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
System.AddCCommand(MBCMain.prefix .. 'NextObjective', 'MBCQuest:QuestSequence()', "Pass to the next objective of the quest")

--- Talk to the NPC sequence
function MBCQuest:Talk()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_talk")) then

		self.spawnedCamp.name, self.spawnedCamp.difficulty = MBCQuest:RandomCamp()

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_talk", false)
		QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp", false)

		MBCUtils:LogOnScreen("@ui_text_npc_location")
	end
end

--- Destroy the camp sequence
function MBCQuest:DestroyCamp()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp", false)
		QuestSystem.StartObjective("q_morebanditcamps", "o_reward", false)

		MBCUtils:LogOnScreen("@ui_text_npc_destroyed")
	end
end

--- Reward sequence
function MBCQuest:Reward()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_reward")) then

		local reward = self.difficultyRewards[self.spawnedCamp.difficulty] or 0
		AddMoneyToInventory(player, reward * 10)

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward", false)

		MBCQuest:RestartQuest()
	end
end

function MBCQuest:RandomCamp()

	-- Location
	local keys = {}
	for key in pairs(MBCCamps.locations) do
		table.insert(keys, key)
	end
	local location = keys[math.random(2, #keys)]

	-- Difficulty
	local difficulty = MBCCamps.difficulty[math.random(2, #MBCCamps.difficulty)]

	-- Spawn the camp
	MBCCamps:SpawnCamp(location, difficulty, false)

	return location, difficulty
end