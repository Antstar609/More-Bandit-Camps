---@class ModQuest Quest manager
---@field npcPosition table Position of the NPC (x, y, z)
ModQuest = {
	npcPosition = { x = 983.452, y = 1554.807, z = 25.205 },
}

--- Start the quest
function ModQuest:InitQuest()
	if (System.GetEntityByName("marechal") == nil) then
		-- spawn npc
		ModSoul:SpawnMarechal(self.npcPosition, { x = 0, y = 0, z = 90 })
		-- reset and activate the quest
		QuestSystem.ResetQuest("q_morebanditcamps")
		--QuestSystem.ActivateQuest("q_morebanditcamps", false)
	else
		-- remove the old npc and spawn a new one to prevent the entity from being faded when the player is far away
		System.RemoveEntity(System.GetEntityByName("marechal").id)
		ModSoul:SpawnMarechal(self.npcPosition, { x = 0, y = 0, z = 90 })
	end

	-- if there already is a camp spawned, remove it and reset the quest to avoid the tagpoint not showing up
	if (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_destroycamp")) then
		if (System.GetEntityByName("TestCamp") ~= nil) then
			System.RemoveEntity(System.GetEntityByName("TestCamp").id)
		end
		-- TODO: Test to start the talk objective instead of restarting the quest
		QuestSystem.ResetQuest("q_morebanditcamps")
	end

	-- if the quest is not started, start it and start the objective talk
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
	end
end

--- Restart the quest
function ModQuest:RestartQuest()
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
function ModQuest:NCPInteract()
	-- self doesn't work here
	ModQuest:DialogueSequence()
end

function ModQuest:DialogueSequence()
	if (QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		if (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_talk")) then
			ModQuest:Talk()
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_destroycamp")) then
			ModUtils:LogOnScreen("Destroy the bandit camp first and then come back to me")
		elseif (QuestSystem.IsObjectiveStarted("q_morebanditcamps", "o_reward")) then
			ModQuest:Reward()
		end
	end
end

function ModQuest:QuestSequence()
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
System.AddCCommand(ModMain.prefix .. 'NextObjective', 'ModQuest:QuestSequence()', "Pass to the next objective of the quest")

--- Talk to the NPC sequence
function ModQuest:Talk()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_talk")) then

		ModCamps:SpawnCamp("TestCamp", "test", "easy")

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_talk", false)
		QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp", false)

		ModUtils:LogOnScreen("Here's the location of the bandit camp")
	end
end

--- Destroy the camp sequence
function ModQuest:DestroyCamp()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp", false)
		QuestSystem.StartObjective("q_morebanditcamps", "o_reward", false)

		ModUtils:LogOnScreen("You've destroyed the bandit camp")
	end
end

--- Reward sequence
function ModQuest:Reward()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_reward")) then

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward", false)

		ModQuest:RestartQuest()

		ModUtils:LogOnScreen("You've collected your reward")
	end
end