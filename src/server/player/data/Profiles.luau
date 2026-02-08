local PlayerData = require(script.Parent.PlayerData)
local Profiles = {}

function Profiles.get(player: Player): PlayerData.PlayerData
	return Profiles[player.UserId].data
end

return Profiles
