local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ores = require(ReplicatedStorage.Shared.configs.Ores)
local LivingObject = require(script.Parent.LivingObject)
local ObjectTypes = require(script.Parent.ObjectTypes)
local OreObject = {}
OreObject.__index = OreObject
setmetatable(OreObject, LivingObject)

export type OreObject = typeof(OreObject) & LivingObject.LivingObject

function OreObject.spawn(oreData: Ores.OreData, position: Vector3): OreObject
	local model = oreData.model:Clone()
	model.Parent = workspace

	if not model.HumanoidRootPart then
		error("Ore model must have a HumanoidRootPart")
	end
	model.HumanoidRootPart.CFrame = CFrame.new(position)

	local self = LivingObject.new(model, ObjectTypes.Ore) :: OreObject
	setmetatable(self, OreObject)
	self:setMaxHealth(oreData.hp)
	self:setHealth(oreData.hp)
	return self
end

return OreObject
