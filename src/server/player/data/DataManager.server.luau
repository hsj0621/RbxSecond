local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerData = require(script.Parent.PlayerData)
local Profiles = require(script.Parent.Profiles)
local ProfileService = require(ServerScriptService.Packages.ProfileService)
local PlayerEvents = require(ServerScriptService.Server.events.PlayerEvents)
local Connections = require(ServerScriptService.Server.player.Connections)

local profileStore = ProfileService.GetProfileStore("PlayerData", PlayerData)

local function PlayerDataLoaded(player: Player, data: PlayerData.PlayerData)
	Connections[player.UserId] = {}

	PlayerEvents.LoginEvent:Fire(player, data)
	print("Player Loaded :", player.Name .. "(" .. player.UserId .. ")")
end

local function PlayerAdded(player: Player)
	local profile = profileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(Players) then
			Profiles[player] = profile
			Profiles[player.UserId] = {
				data = profile.Data,
			}
			PlayerDataLoaded(player, profile.Data)
		else
			profile:Release()
		end
	else
		player:Kick()
	end
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(function(player: Player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:Release()
	end

	if Connections[player.UserId] then
		for _, conn in pairs(Connections[player.UserId]) do
			conn:Disconnect()
		end
		Connections[player.UserId] = nil
	end
end)
