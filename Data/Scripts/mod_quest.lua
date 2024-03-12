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
		QuestSystem.ActivateQuest("q_morebanditcamps")
	else
		-- the entity has been cleared, have to set the attributes again
		ModSoul:SetMarechalAttributes(System.GetEntityByName("marechal"))
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
	QuestSystem.ActivateQuest("q_morebanditcamps")

	-- if the quest is not started, start it and start the objective talk
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
	end
end

--- Interact with the NPC to progress the quest
function ModQuest:NCPInteract()
	-- self doesn't work here
	ModQuest:QuestSequence()
end

--- Manage the quest sequence
function ModQuest:QuestSequence()
	-- same here but with if its not the time the player has talked to the npc
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_talk")) then

		ModCamps:SpawnCamp("TestCamp", "test", "easy")

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_talk")
		QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp")

		ModUtils:LogOnScreen("Here's the location of the bandit camp")
	elseif (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp")
		QuestSystem.StartObjective("q_morebanditcamps", "o_reward")

		ModUtils:LogOnScreen("You've destroyed the bandit camp")
	else
		QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward")

		ModQuest:RestartQuest()

		ModUtils:LogOnScreen("You've collected your reward")
	end
end

--- Command to debug the quest
function ModQuest:DebugQuest()
	self:QuestSequence()
end
System.AddCCommand(ModMain.prefix .. 'NextObjective', 'ModQuest:DebugQuest()', "Next objective of the quest")