local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RootUI = require(script.Parent.RootUI)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

return function(container)
	local root = ReactRoblox.createRoot(container)
	root:render(RootUI())
	return function()
		root:unmount()
	end
end
