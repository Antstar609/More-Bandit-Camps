CampEntity = {
	Client = {},
	Server = {},
	Properties = {
		bSaved_by_game = 0,
		Saved_by_game = 0,
		bSerialize = 0,
	},
	States = {},

	difficulty = 0,
	isSpawned = false,
}

-- this is called when the player loads a save state - use this for restoring values when a game gets loaded
function CampEntity:OnLoad(tbl)
	--ModUtils:Log("CampEntity OnLoad")
end

-- this is called once, use this for initializing stuff
function CampEntity.Server:OnInit()
	if (not self.bInitialized) then
		self:OnReset()
		self.bInitialized = 1
	end
end

-- this is called once, use this for initializing stuff
function CampEntity:OnReset()
	--ModUtils:Log("CampEntity OnReset")
	
	self:LoadObject(0, "objects/props/crates/crate_short.cgf")
	self:Activate(1)
	-- self:SetCurrentSlot(0)
	-- self:PhysicalizeThis(0)
end

-- this is called every frame given the entity has been spawned
function CampEntity.Client:OnUpdate()
	--ModUtils:Log("CampEntity OnUpdate")

	local playerPos = player:GetWorldPos()
	local campPos = self:GetWorldPos()

	local distance = DistanceVectors(playerPos, campPos)
	if distance <= 5 and self.isSpawned == false then
		for i = 1, self.difficulty do
			local offsetX = math.random(-3, 3)
			local offsetY = math.random(-3, 3)
			local newPos = { x = campPos.x + offsetX, y = campPos.y + offsetY, z = campPos.z }
			ModSoul:SpawnEntityByType("bandit", newPos)
		end
		ModUtils:LogOnScreen("Guard spawned")
		self.isSpawned = true
	end
end

-- this is called when the player saves or updates a save state - storing values for your entities
function CampEntity:OnPropertyChange()
	--ModUtils:Log("CampEntity opc")
	self:OnReset()
end

function CampEntity:OnAction(action, activation, value)
	--ModUtils:Log("CampEntity OnAction")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function CampEntity:OnSave(tbl)
	--ModUtils:Log("CampEntity OnSave")
end

CampEntity.Server.TurnedOn = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOn")
	end,
	OnUpdate = function(self, dt)
		--[[ do something every frame, like rendering, ai, ..]]
	end,
	OnEndState = function(self)
	end
}

CampEntity.Server.TurnedOff = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOff")
	end,
	OnEndState = function(self)
	end
}

CampEntity.FlowEvents = {
	Inputs = {
		TurnOn = { CampEntity.Event_TurnOn, "bool" },
		TurnOff = { CampEntity.Event_TurnOff, "bool" },
	},
	Outputs = {
		TurnOn = "bool",
		TurnOff = "bool",
	}
}