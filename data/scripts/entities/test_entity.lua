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
	--mod_main:Log("TestEntity OnLoad")
end

-- this is called once, use this for initializing stuff
function TestEntity.Server:OnInit()
	--mod_main:Log("TestEntity OnInit")
	if (not self.bInitialized) then
		self:OnReset()
		self.bInitialized = 1
	end
end

-- this is called once, use this for initializing stuff
function TestEntity:OnReset()
	--mod_main:Log("TestEntity OnReset")
	self:Activate(1)
	-- self:SetCurrentSlot(0)
	-- self:PhysicalizeThis(0)
end

-- this is called every frame given the entity has been spawned
function TestEntity.Client:OnUpdate()
	local pos = player:GetWorldPos() -- Returns a 3d vector
	Game.SendInfoText("Player Pos\nX: " .. pos.x .. " Y: " .. pos.y .. " Z: " .. pos.z, false, nil, 1)
end

-- this is called when the player saves or updates a save state - storing values for your entities
function TestEntity:OnPropertyChange()
	self:OnReset()
	--mod_main:Log("TestEntity opc")
end

function TestEntity:OnAction(action, activation, value)
	--mod_main:Log("TestEntity OnAction")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function TestEntity:OnSave(tbl)
	--mod_main:Log("TestEntity OnSave")
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