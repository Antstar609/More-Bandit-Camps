TestEntity = {
	Client = {},
	Server = {},
	Properties = {
		bSaved_by_game = 0,
		Saved_by_game = 0,
		bSerialize = 0
	},
	States = {}
}

-- this is called when the player loads a save state - use this for restoring values when a game gets loaded
function TestEntity:OnLoad(tbl)
	--modMain:Log("TestEntity OnLoad")

end

-- this is called once, use this for initializing stuff
function TestEntity.Server:OnInit()
	modMain:Log("TestEntity spawned (does nothing)")
	if (not self.bInitialized) then
		self:OnReset()
		self.bInitialized = 1
	end
end

-- this is called once, use this for initializing stuff
function TestEntity:OnReset()
	--modMain:Log("TestEntity OnReset")
	self:Activate(1)
	modCommands:ShowText()
	-- self:SetCurrentSlot(0)
	-- self:PhysicalizeThis(0)
end

-- this is called every frame given the entity has been spawned
function TestEntity.Client:OnUpdate()
	--modMain:Log("TestEntity OnUpdate")
	--Game.SendInfoText("Entity Pos\n X: " .. TestEntity.position.x .. " Y: " .. TestEntity.position.y .. " Z: " .. TestEntity.position.z, false, nil, 1)
end

-- this is called when the player saves or updates a save state - storing values for your entities
function TestEntity:OnPropertyChange()
	self:OnReset()
	--modMain:Log("TestEntity opc")
end

function TestEntity:OnAction(action, activation, value)
	--modMain:Log("TestEntity OnAction")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function TestEntity:OnSave(tbl)
	--modMain:Log("TestEntity OnSave")
end

TestEntity.Server.TurnedOn = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOn")
	end,
	OnUpdate = function(self, dt)
		--[[ do something every frame, like rendering, ai, ..]]
	end,
	OnEndState = function(self)
	end
}

TestEntity.Server.TurnedOff = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOff")
	end,
	OnEndState = function(self)
	end
}

TestEntity.FlowEvents = {
	Inputs = {
		TurnOn = { TestEntity.Event_TurnOn, "bool" },
		TurnOff = { TestEntity.Event_TurnOff, "bool" },
	},
	Outputs = {
		TurnOn = "bool",
		TurnOff = "bool",
	}
}