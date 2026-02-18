local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Utils = {}

local e = React.createElement

function Utils.CreateFrame(posAndSize: { number }?, children: { any }?, centered: boolean?, props: { [string]: any }?)
	local properties = {
		AnchorPoint = centered and Vector2.new(0.5, 0.5) or Vector2.new(0, 0),
		Position = posAndSize and UDim2.fromScale(posAndSize[1], posAndSize[2])
			or (centered and UDim2.fromScale(0.5, 0.5) or UDim2.fromScale(0, 0)),
		Size = posAndSize and UDim2.fromScale(posAndSize[3], posAndSize[4]) or UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}

	if props then
		for key, value in pairs(props) do
			properties[key] = value
		end
	end

	return e("Frame", properties, children)
end

return Utils
