QuestEntity = {
	Client = {},
	Server = {},
	Properties = {
		bSaved_by_game = 0,
		Saved_by_game = 0,
		bSerialize = 0
	},
	States = {},
}

-- this is called when the player loads a save state - use this for restoring values when a game gets loaded
function QuestEntity:OnLoad(tbl)
	--ModUtils:Log("QuestEntity - OnLoad")
end

-- this is called once, use this for initializing stuff
function QuestEntity.Server:OnInit()
	ModUtils:Log("QuestEntity - Init")
	if (not self.bInitialized) then
		self:OnReset()
		self.bInitialized = 1
	end
end

-- this is called once, use this for initializing stuff
function QuestEntity:OnReset()
	ModUtils:Log("QuestEntity - OnReset")
	self:Activate(1)

	--TODO: This function is actually called every time there's a loading screen (reload save or player death) and i don't want to add or create a new camp to the list everytime
	ModCamps:SpawnCamp("TestCamp", "test", "easy")

	--TODO: make sure that it doesnt spawn an second time
	ModSoul:SpawnMarechal(ModCamps.locations.marechal, { x = 0, y = 0, z = 90 })
	
	QuestSystem.ResetQuest("quest_morebanditcamps")
	QuestSystem.ActivateQuest("quest_morebanditcamps")
	if (not QuestSystem.IsQuestStarted("quest_morebanditcamps")) then
		QuestSystem.StartQuest("quest_morebanditcamps")
		QuestSystem.StartObjective("quest_morebanditcamps", "firsttalk", false)
	end
end

-- this is called every frame given the entity has been spawned
function QuestEntity.Client:OnUpdate()
	--ModUtils:Log("QuestEntity - OnUpdate")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function QuestEntity:OnPropertyChange()
	self:OnReset()
	--ModUtils:Log("QuestEntity - opc")
end

function QuestEntity:OnAction(action, activation, value)
	--ModUtils:Log("QuestEntity - OnAction")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function QuestEntity:OnSave(tbl)
	--ModUtils:Log("QuestEntity - OnSave")
end

QuestEntity.Server.TurnedOn = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOn")
	end,
	OnUpdate = function(self, dt)
		--[[ do something every frame, like rendering, ai, ..]]
	end,
	OnEndState = function(self)
	end
}

QuestEntity.Server.TurnedOff = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOff")
	end,
	OnEndState = function(self)
	end
}

QuestEntity.FlowEvents = {
	Inputs = {
		TurnOn = { QuestEntity.Event_TurnOn, "bool" },
		TurnOff = { QuestEntity.Event_TurnOff, "bool" },
	},
	Outputs = {
		TurnOn = "bool",
		TurnOff = "bool",
	}
}