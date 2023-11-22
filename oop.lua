local function ClassObject(name, pos)
	local self = {}
	self.name = name or "No name"
	self.pos = pos or { x = 0, y = 0 } 
	self.status = "Idle"

	self.Move = function()
		self.status = "Moving"
	end
	
	return self
end

print("ClassObject :")
local Object = ClassObject("Test", { x = 3, y = 6 })
print(Object.name)
print(Object.pos.x..", "..Object.pos.y)
print(Object.status)
Object:Move()
print(Object.status)

local function ClassPlayer(name, pos, hp, mana)
	local self = ClassObject(name, pos)
	self.hp = hp or 100
	self.mana = mana or 100

	self.Move = function()
		self.status = "Moving Fast"
	end
	
	self.Attack = function()
		self.status = "Attacking"
	end

	return self
end

local Player = ClassPlayer("Player", { x = 10, y = 10 })

print("\nClassPlayer :")
print(Player.name)
print(Player.pos.x..", "..Player.pos.y)
print(Player.status)
Player:Move()
print(Player.status)
print(Player.hp)
print(Player.mana)
Player:Attack()
print(Player.status)
