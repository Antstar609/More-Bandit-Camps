--- @class MBCCampEntity Custom entity for spawning a camp with bandits
--- @field bandits table List of bandit entities
--- @field name string Name of the camp
--- @field difficulty number Difficulty of the camp
--- @field spawnRadius number Radius around the camp to spawn entities when the player is within
--- @field despawnRadius number Radius around the camp to despawn entities when the player is outside
--- @field isFirstEntitiesSpawning boolean True if the camp has been spawned at least once
--- @field isEntitiesSpawned boolean True if the camp is spawned
--- @field isDefeated boolean True if the camp is defeated
MBCCampEntity = {
	Client = {},
	Server = {},
	Properties = {
		bSaved_by_game = 1,
		Saved_by_game = 1,
		bSerialize = 1,
	},
	States = {},

	bandits = {},
	name = "",
	difficulty = 0,

	spawnRadius = 60,
	despawnRadius = 100,

	meshes = {},
	tagpoint = nil,

	isFirstEntitiesSpawning = false,
	isEntitiesSpawned = false,

	-- to be saved
	isDefeated = false,
}

-- this is called when the player loads a save state - use this for restoring values when a game gets loaded
function MBCCampEntity:OnLoad(tbl)
	--MBC_Utils:Log("MBCCampEntity - OnLoad")

	-- Retrieve the camp name and difficulty from the save state
	MBC_Quest.spawnedCamp.name = tbl.name
	MBC_Quest.spawnedCamp.difficulty = tbl.difficulty
end

-- this is called once, use this for initializing stuff
function MBCCampEntity.Server:OnInit()
	if (not self.bInitialized) then
		self:OnReset()
		self.bInitialized = 1
	end
end

-- this is called once, use this for initializing stuff
function MBCCampEntity:OnReset()
	--MBC_Utils:Log("MBCCampEntity - OnReset")
	self:Activate(1)
end

-- this is called every frame given the entity has been spawned
function MBCCampEntity.Client:OnUpdate()
	--MBC_Utils:Log("MBCCampEntity - OnUpdate")
	local distance = player:GetDistance(self.id)

	if (not self.isEntitiesSpawned) then
		if (distance <= self.spawnRadius) then
			self:CreateCamp()
		end
	else
		if (not self.isDefeated) then
			-- check if the player is outside the despawn radius then despawn the camp
			if (distance >= self.despawnRadius) then
				self:DespawnEntities()
			end
			-- check if the camp is defeated
			self:CheckCampStatus()
		end
	end

	if (self.isDefeated == true) then
		-- validate the quest sequence
		MBC_Quest:DestroyCamp()
		-- check if the player is outside the despawn radius then destroy the camp
		if (distance >= self.despawnRadius) then
			self:DestroyCamp()
		end
	end
end

--- Spawn entities around the camp
function MBCCampEntity:CreateCamp()
	-- check if the player is within the spawn radius
	if (not self.isFirstEntitiesSpawning) then
		self.bandits = MBC_Soul:SpawnEntityByType("event_spawn_bandit", self:GetWorldPos(), self.difficulty, 3)
		self.isFirstEntitiesSpawning = true
		--MBC_Utils:LogOnScreen("INITIAL SPAWN: " .. self.name .. " spawned with " .. self.difficulty .. " bandits")
	else
		self:RespawnEntities(self:GetWorldPos())
	end
	self.isEntitiesSpawned = true
end

--- Check entities around the camp and remove them if they are dead or despawn the camp if all entities are dead
function MBCCampEntity:CheckCampStatus()
	for i, bandit in pairs(self.bandits) do
		if (bandit:IsDead()) then
			table.remove(self.bandits, i)
		end
	end

	if (next(self.bandits) == nil) then
		self.isDefeated = true
		--MBC_Utils:LogOnScreen(self.name .. " defeated")
	end
end

--- Respawn remaining entities around the camp if the player is within the spawn radius
--- @param _position table Position of the camp (x, y, z)
function MBCCampEntity:RespawnEntities(_position)
	-- use the previous bandit entities to spawn new ones with the same attributes
	for i, bandit in pairs(self.bandits) do
		-- spawn the new entity at a random position around the camp
		local offsetX = math.random(-3, 3)
		local offsetY = math.random(-3, 3)
		local newPos = { x = _position.x + offsetX, y = _position.y + offsetY, z = _position.z }

		local spawnParams = {
			class = bandit.class,
			name = "bandit_" .. i,
			position = newPos,
			orientation = _position,
			properties = {
				sharedSoulGuid = bandit.Properties.sharedSoulGuid,
				bSaved_by_game = 0,
			},
		}
		local entity = System.SpawnEntity(spawnParams)
		entity.AI.invulnerable = true
		entity.lootIsLegal = true

		-- replace the old entity with the new one
		self.bandits[i] = entity
	end
	--MBC_Utils:LogOnScreen(self.name .. " spawned with " .. #self.bandits .. " bandits")
end

--- Despawn the camp if the player is outside the despawn radius
function MBCCampEntity:DespawnEntities()
	for _, bandit in pairs(self.bandits) do
		if (not bandit:IsDead()) then
			System.RemoveEntity(bandit.id)
		end
	end
	--MBC_Utils:LogOnScreen(self.name .. " despawned")
	self.isEntitiesSpawned = false
end

function MBCCampEntity:DestroyCamp()
	for _, bandit in pairs(self.bandits) do
		System.RemoveEntity(bandit.id)
	end
	for _, mesh in pairs(self.meshes) do
		System.RemoveEntity(mesh.id)
	end
	if (self.tagpoint ~= nil) then
		System.RemoveEntity(self.tagpoint.id)
	end
	System.RemoveEntity(self.id)
	--MBC_Utils:LogOnScreen(self.name .. " destroyed")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function MBCCampEntity:OnPropertyChange()
	--MBC_Utils:Log("MBCCampEntity - opc ")
	self:OnReset()
end

function MBCCampEntity:OnAction(action, activation, value)
	--MBC_Utils:Log("MBCCampEntity - OnAction ")
end

-- this is called when the player saves or updates a save state - storing values for your entities
function MBCCampEntity:OnSave(tbl)
	--MBC_Utils:Log("MBCCampEntity - OnSave ")
	tbl.name = self.name
	tbl.difficulty = self.difficulty
end

MBCCampEntity.Server.TurnedOn = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOn")
	end,
	OnUpdate = function(self, dt)
		--[[ do something every frame, like rendering, ai, ..]]
	end,
	OnEndState = function(self)
	end
}

MBCCampEntity.Server.TurnedOff = {
	OnBeginState = function(self)
		BroadcastEvent(self, "TurnOff")
	end,
	OnEndState = function(self)
	end
}

MBCCampEntity.FlowEvents = {
	Inputs = {
		TurnOn = { MBCCampEntity.Event_TurnOn, "bool" },
		TurnOff = { MBCCampEntity.Event_TurnOff, "bool" },
	},
	Outputs = {
		TurnOn = "bool",
		TurnOff = "bool",
	}
}