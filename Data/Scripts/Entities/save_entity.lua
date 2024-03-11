SaveEntity = {
	Client = {},
	Server = {},
	Properties = {
		bSaved_by_game = 1,
		Saved_by_game = 0,
		bSerialize = 0
	},
	States = {},

	isFirstTalk = false
}

-- this is called when the player loads a save state - use this for restoring values when a game gets loaded
function SaveEntity:OnLoad(tbl)
	self.isFirstTalk = tbl.isFirstTalk
end

-- this is called once, use this for initializing stuff
function SaveEntity.Server:OnInit()
	--ModUtils:Log("SaveEntity - OnInit")
	if (not self.bInitialized) then
		self:OnReset()
		self.bInitialized = 1
	end
end

-- this is called once, use this for initializing stuff
function SaveEntity:OnReset()
	--ModUtils:Log("SaveEntity - OnReset")
	self:Activate(0)
end

-- this is called every frame given the entity has been spawned
function SaveEntity.Client:OnUpdate()
	--ModUtils:Log("SaveEntity - OnUpdate")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function SaveEntity:OnPropertyChange()
	self:OnReset()
	--ModUtils:Log("SaveEntity - opc")
end

function SaveEntity:OnAction(action, activation, value)
	--ModUtils:Log("SaveEntity - OnAction")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function SaveEntity:OnSave(tbl)
	tbl.isFirstTalk = self.isFirstTalk
end

SaveEntity.Server.TurnedOn = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOn")
	end,
	OnUpdate = function(self, dt)
		--[[ do something every frame, like rendering, ai, ..]]
	end,
	OnEndState = function(self)
	end
}

SaveEntity.Server.TurnedOff = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOff")
	end,
	OnEndState = function(self)
	end
}

SaveEntity.FlowEvents = {
	Inputs = {
		TurnOn = { SaveEntity.Event_TurnOn, "bool" },
		TurnOff = { SaveEntity.Event_TurnOff, "bool" },
	},
	Outputs = {
		TurnOn = "bool",
		TurnOff = "bool",
	}
}