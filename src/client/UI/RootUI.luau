local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local UIUtils = require(ReplicatedStorage.Shared.utils.UIUtils)

local e = React.createElement

local bgTr = 0.5
return function()
	local children = {}
	local main = e("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {})
	return main
end
