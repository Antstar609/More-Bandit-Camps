CampEntity = {
	Client = {},
	Server = {},
	Properties = {
		bSaved_by_game = 0,
		Saved_by_game = 0,
		bSerialize = 0,
	},
	States = {},

	bandits = {},
	name = "",
	difficulty = 0,
	spawnRadius = 5,
	despawnRadius = 20,
	isFirstSpawn = false,
	isSpawned = false,
	isDestroyed = false,
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
	if not self.isSpawned then
		self:CreateCamp()
	else
		if not self.isDestroyed then
			self:CheckCampStatus()
			self:DespawnEntites()
		end
	end
end

function CampEntity:CreateCamp()
	local playerPos = player:GetWorldPos()
	local campPos = self:GetWorldPos()

	local distance = DistanceVectors(playerPos, campPos)
	if distance <= self.spawnRadius then
		if not self.isFirstSpawn then
			self.bandits = ModSoul:SpawnEntityByType("bandit", campPos, self.difficulty, 3)
			self.isFirstSpawn = true
			ModUtils:LogOnScreen("INITIAL SPAWN: " .. self.name .. " spawned with " .. self.difficulty .. " bandits")
		else
			for i, bandit in pairs(self.bandits) do
				-- Does not work
				System.SpawnEntity(bandit)
			end
			ModUtils:LogOnScreen(self.name .. " spawned with " .. #self.bandits .. " bandits")
		end
		self.isSpawned = true
	end
end

function CampEntity:CheckCampStatus()
	for i, bandit in pairs(self.bandits) do
		if bandit:IsDead() then
			table.remove(self.bandits, i)
		end
	end

	if next(self.bandits) == nil then
		self.isDestroyed = true
		ModUtils:LogOnScreen(self.name .. " destroyed")
	end
end

function CampEntity:DespawnEntites()
	local playerPos = player:GetWorldPos()
	local campPos = self:GetWorldPos()

	local distance = DistanceVectors(playerPos, campPos)
	if distance >= self.despawnRadius then
		for i, bandit in pairs(self.bandits) do
			if not bandit:IsDead() then
				System.RemoveEntity(bandit.id)
			end
		end
		ModUtils:LogOnScreen(self.name .. " despawned")
		self.isSpawned = false
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