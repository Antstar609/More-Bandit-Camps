---@class ModQuest Quest manager
---@field npcLocation table Location of the NPC
---@field isFirstTime boolean Is the first time the player talks to the NPC
ModQuest = {
	npcLocation = { x = 983.452, y = 1554.807, z = 25.205 },
	isFirstTime = true
}

--- Start the quest
function ModQuest:StartQuest()
	ModUtils:Log("Starting the quest")

	if (System.GetEntityByName("marechal") == nil) then
		ModSoul:SpawnMarechal(self.npcLocation, { x = 0, y = 0, z = 90 })
		ModUtils:Log("The marechal has been spawned")
	else
		ModUtils:Log("The marechal is already spawned")
	end

		QuestSystem.ResetQuest("q_morebanditcamps")
		QuestSystem.ActivateQuest("q_morebanditcamps")

		if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
			QuestSystem.StartQuest("q_morebanditcamps")

			if (self.isFirstTime == true) then
				QuestSystem.StartObjective("q_morebanditcamps", "o_initialtalk", false)
				ModUtils:LogOnScreen("Inital Talk started")
			else
				QuestSystem.StartObjective("q_morebanditcamps", "o_talk", false)
				ModUtils:LogOnScreen("Talk started")
			end
		end
	end

-- TODO: Add a description
function ModQuest:NCPInteract()
	-- self doesn't work here
	
	if (ModQuest.isFirstTime == true) then
		if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_initialtalk")) then
			-- if the initialtalk is not completed complete it and start the objective to destroy the camp
			
			ModCamps:SpawnCamp("TestCamp", "test", "easy")
			
			QuestSystem.CompleteObjective("q_morebanditcamps", "o_initialtalk")
			QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp")

			ModUtils:LogOnScreen("Here's the location of the bandit camp (initialtalk Completed)")
		elseif (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then
			-- if the destroycamp is not completed complete it and start the objective to collect the reward

			QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp")
			QuestSystem.StartObjective("q_morebanditcamps", "o_reward")

			ModUtils:LogOnScreen("You've destroyed the bandit camp (destroycamp Completed)")
		else
			-- else complete the reward and start the quest again
			
			QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward")
			ModQuest.isFirstTime = false
			ModQuest:StartQuest()
			ModUtils:LogOnScreen("You've collected your reward (reward Completed)")
		end
	else
		-- same here but with if its not the time the player has talked to the npc
		if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_talk")) then

			ModCamps:SpawnCamp("TestCamp", "test", "easy")

			QuestSystem.CompleteObjective("q_morebanditcamps", "o_talk")
			QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp")

			ModUtils:LogOnScreen("Here's the location of the bandit camp (talk Completed)")
		elseif (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then

			QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp")
			QuestSystem.StartObjective("q_morebanditcamps", "o_reward")

			ModUtils:LogOnScreen("You've destroyed the bandit camp (destroycamp Completed)")
		else
			QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward")
			ModQuest:StartQuest()
			ModUtils:LogOnScreen("You've collected your reward (reward Completed)")
		end
	end
end