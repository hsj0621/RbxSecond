local ServerStorage = game:GetService("ServerStorage")

local entityFolder = ServerStorage:WaitForChild("Entities")
local oreFolder = entityFolder:WaitForChild("Ores")

local ores = {
	Stone = {
		name = "Stone",
		model = oreFolder:WaitForChild("Stone"),
		hp = 10,
	} :: OreData,
}

export type OreData = {
	name: string,
	hp: number,
	model: Model,
}

return ores
