CampEntity = {
	Client = {},
	Server = {},
	Properties = {
		bSaved_by_game = 0,
		Saved_by_game = 0,
		bSerialize = 0
	},
	States = {},
	
	isSpawned = false
}

-- this is called when the player loads a save state - use this for restoring values when a game gets loaded
function CampEntity:OnLoad(tbl)
	--modMain:Log("CampEntity OnLoad")
end

-- this is called once, use this for initializing stuff
function CampEntity.Server:OnInit()
	modMain:Log("CampEntity spawned")

	if (not self.bInitialized) then
		self:OnReset()
		self.bInitialized = 1
	end
end

-- this is called once, use this for initializing stuff
function CampEntity:OnReset()
	--modMain:Log("CampEntity OnReset")

	self:Activate(1)
	self:LoadObject(0, "objects/props/campfire/campfire.cgf")
	-- self:SetCurrentSlot(0)
	-- self:PhysicalizeThis(0)
end

-- this is called every frame given the entity has been spawned
function CampEntity.Client:OnUpdate()
	--modMain:Log("CampEntity OnUpdate")

	local playerPos = player:GetWorldPos()
	local campPos = self:GetWorldPos()
	
	local distance = DistanceVectors(playerPos, campPos)
	if distance <= 5 and self.isSpawned == false then
		if modMain.temp then
			modSoul:spawnEntity("guard", campPos)
			self.isSpawned = true
		end
	end
end

-- this is called when the player saves or updates a save state - storing values for your entities
function CampEntity:OnPropertyChange()
	--modMain:Log("CampEntity opc")

	self:OnReset()
end

function CampEntity:OnAction(action, activation, value)
	--modMain:Log("CampEntity OnAction")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function CampEntity:OnSave(tbl)
	--modMain:Log("CampEntity OnSave")
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