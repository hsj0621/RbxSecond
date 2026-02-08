local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtils = require(ReplicatedStorage.Shared.utils.TableUtils)
local Admins = {
	192608758, -- Rukon0621
}

function Admins.isAdmin(id: number): boolean
	return TableUtils.contains(Admins, id)
end

return Admins
