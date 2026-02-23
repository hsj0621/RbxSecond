local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local registry

if RunService:IsServer() then
	registry = Instance.new("Folder")
	registry.Name = "Animations"
	registry.Parent = ReplicatedStorage:WaitForChild("Registry")
else
	registry = ReplicatedStorage:WaitForChild("Registry"):WaitForChild("Animations")
end

function CreateOrGet(name: string, animationID: string): Animation
	if RunService:IsServer() then
		local existing = registry:FindFirstChild(name)
		if existing then
			return existing
		end

		local newAnimation = Instance.new("Animation")
		newAnimation.Name = name
		newAnimation.AnimationId = "rbxassetid://" .. animationID
		newAnimation.Parent = registry
		return newAnimation
	else
		local existing = registry:WaitForChild(name)
		if existing then
			return existing
		end
		error("Animation not found on client: " .. name)
	end
end

local Animation = {
	PickaxeSwing = CreateOrGet("PickaxeSwing", "71568623864332"),
}

return Animation
