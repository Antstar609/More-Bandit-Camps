-- System.LogAlways("Hello World ///////////////////////////////////////////////// TestMod !")

local Entity = { x = 0, y = 0 }

for i = 1, 10, 1 do
	local Pos = {math.random(1, 100), math.random(1, 100)}
	table.insert(Entity, Pos)
	print("Entity[" .. i .. "] = {" .. Pos[1] .. ", " .. Pos[2] .. "}")
end