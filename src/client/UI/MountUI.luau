local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local RootUI = require(script.Parent.RootUI)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

return function()
	local container = Instance.new("ScreenGui")
	local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
	container.Name = "React"
	container.ResetOnSpawn = false
	container.Parent = playerGui
	container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	container.ClipToDeviceSafeArea = false

	local root = ReactRoblox.createRoot(container)
	root:render(React.createElement(RootUI))
end
