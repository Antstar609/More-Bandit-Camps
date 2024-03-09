ModQuest = {
	isNPCSpawned = false,
	isFirstTime = false
}

function ModQuest:StartQuest()
	ModUtils:Log("Starting the quest")

	if (self.isNPCSpawned == false) then
		ModSoul:SpawnMarechal(ModCamps.locations.marechal, { x = 0, y = 0, z = 90 })
		ModUtils:LogOnScreen("The marechal has been spawned (StartQuest)")
		self.isNPCSpawned = true
	end

	QuestSystem.ResetQuest("q_morebanditcamps")
	QuestSystem.ActivateQuest("q_morebanditcamps")
	if (not QuestSystem.IsQuestStarted("q_morebanditcamps")) then
		QuestSystem.StartQuest("q_morebanditcamps")
		if (isFirstTime == false) then
			QuestSystem.StartObjective("q_morebanditcamps", "o_initialtalk", false)
			self.isFirstTime = true
		end
		QuestSystem.StartObjective("q_morebanditcamps", "o_temp", false)
	end
end

function ModQuest:NCPInteract()
	if (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_initialtalk")) then
		ModCamps:SpawnCamp("TestCamp", "test", "easy")
		QuestSystem.CompleteObjective("q_morebanditcamps", "o_initialtalk")
		QuestSystem.StartObjective("q_morebanditcamps", "o_destroycamp")
		ModUtils:LogOnScreen("Here's the location of the bandit camp (initialtalk Completed)")
	elseif (not QuestSystem.IsObjectiveCompleted("q_morebanditcamps", "o_destroycamp")) then
		QuestSystem.CompleteObjective("q_morebanditcamps", "o_destroycamp")
		QuestSystem.StartObjective("q_morebanditcamps", "o_reward")
		ModUtils:LogOnScreen("You've destroyed the bandit camp (destroycamp Completed)")
	else
		QuestSystem.CompleteObjective("q_morebanditcamps", "o_reward")
		-- self doesn't work here
		ModQuest:StartQuest()
		ModUtils:LogOnScreen("You've collected your reward (reward Completed) - Need to restart the quest")
	end
end