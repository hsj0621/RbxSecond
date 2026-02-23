local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Ores = require(ReplicatedStorage.Shared.configs.Ores)
local OreObject = require(ServerScriptService.Server.objects.OreObject)

OreObject.spawn(Ores.Stone, Vector3.new(38, 13, -123))
