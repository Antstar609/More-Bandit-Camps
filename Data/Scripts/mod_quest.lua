---@class ModQuest Quest manager
---@field npcPosition table Position of the NPC (x, y, z)
---@field isFirstTime boolean Is the first time the player talks to the NPC
ModQuest = {
	npcPosition = { x = 983.452, y = 1554.807, z = 25.205 },
	isFirstTime = true
}

--- Start the quest
function ModQuest:StartQuest()
	ModUtils:Log("Starting the quest")
	
	if (System.GetEntityByName("marechal") == nil) then
		-- spawn npc
		ModSoul:SpawnMarechal(self.npcPosition, { x = 0, y = 0, z = 90 })
		-- reset and activate the quest
		QuestSystem.ResetQuest("q_morebanditcamps")
		QuestSystem.ActivateQuest("q_morebanditcamps")
		ModUtils:Log("The marechal has been spawned")
	else
		-- the entity has been cleared i have to set the attributes again
		ModSoul:SetMarechalAttributes(System.GetEntityByName("marechal"))
		-- the state of the quest is saved in the entity
		
		-- TODO: save the state of isFirstTime
		
		self.isFirstTime = System.GetEntityByName("marechal").questState
		ModUtils:Log("isFirstTime value : " .. tostring(self.isFirstTime))
		ModUtils:Log("The marechal is already spawned")
	end

	-- if the quest is not started, start it and start the objective initialtalk
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_initialtalk", false)
		ModUtils:LogOnScreen("Inital Talk started")
	end
end

--- Restart the quest
function ModQuest:RestartQuest()
	ModUtils:Log("Restarting the quest")
	self.isFirstTime = false
	System.GetEntityByName("marechal").questState = self.isFirstTime

	-- reset and activate the quest, no need to spawn a new npc its already there
	QuestSystem.ResetQuest("q_morebanditcamps")
	QuestSystem.ActivateQuest("q_morebanditcamps")

	-- if the quest is not started, start it and start the objective talk
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
		ModUtils:LogOnScreen("Talk started")
	end
end

--- Interact with the NPC to progress the quest
function ModQuest:NCPInteract()
	-- self doesn't work here
	if (ModQuest.isFirstTime == true) then
		ModQuest:QuestSequenceFirstTime()
	else
		ModQuest:QuestSequence()
	end
end

function ModQuest:QuestSequenceFirstTime()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_initialtalk")) then
		-- if the initialtalk is not completed complete it and start the objective to destroy the camp

		ModCamps:SpawnCamp("TestCamp", "test", "easy")

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_initialtalk")
		QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp")

		ModUtils:LogOnScreen("Here's the location of the bandit camp (Initial Talk Completed)")
	elseif (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then
		-- if the destroycamp is not completed complete it and start the objective to collect the reward

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp")
		QuestSystem.StartObjective("q_morebanditcamps", "o_reward")

		ModUtils:LogOnScreen("You've destroyed the bandit camp (Destroy Camp Completed)")
	else
		-- else complete the reward and start the quest again

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward")

		ModQuest:RestartQuest()

		ModUtils:LogOnScreen("You've collected your reward (Reward Completed)")
	end
end

function ModQuest:QuestSequence()
	-- same here but with if its not the time the player has talked to the npc
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_talk")) then

		ModCamps:SpawnCamp("TestCamp", "test", "easy")

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_talk")
		QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp")

		ModUtils:LogOnScreen("Here's the location of the bandit camp (Talk Completed)")
	elseif (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then

		QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp")
		QuestSystem.StartObjective("q_morebanditcamps", "o_reward")

		ModUtils:LogOnScreen("You've destroyed the bandit camp (Destroy Camp Completed)")
	else
		QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward")

		ModQuest:RestartQuest()

		ModUtils:LogOnScreen("You've collected your reward (Reward Completed)")
	end
end