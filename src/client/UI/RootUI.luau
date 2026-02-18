local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local UIUtils = require(ReplicatedStorage.Shared.utils.UIUtils)

local e = React.createElement

local bgTr = 0.5
return function()
	local children = {}

	local main = UIUtils.CreateFrame({ 0, 0, 0, 0 }, children, false, {
		BackgroundTransparency = bgTr,
	})
	return main
end
