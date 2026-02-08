local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Packets = require(ReplicatedStorage.Shared.network.Packets)
local TableUtils = require(ReplicatedStorage.Shared.utils.TableUtils)
local Admins = require(script.Parent.Admins)
local PlayerEvents = require(ServerScriptService.Server.events.PlayerEvents)
local Connections = require(ServerScriptService.Server.player.Connections)
local Profiles = require(ServerScriptService.Server.player.data.Profiles)

local function log(player: Player, message: string)
	Packets.SendLogPacket:FireClient(player, message)
end

local function warning(player: Player, message: string)
	Packets.SendWarningPacket:FireClient(player, message)
end

local generalCommands = {
	data = function(player: Player)
		log(player, "Your Player Data:")
		local data = Profiles.get(player)
		log(player, data)
	end,
}

local playerCommands = {
	data = function(player: Player, target: Player)
		log(player, "Target Player Data: " .. target.Name)
		local data = Profiles.get(target)
		log(player, data)
	end,
}

PlayerEvents.LoginEvent.Event:Connect(function(player: Player)
	local conn = player.Chatted:Connect(function(message: string)
		if message:sub(1, 1) ~= "/" then
			return
		end
		if not Admins.isAdmin(player.UserId) then
			warn("Unauthorized command attempt by " .. player.Name .. " (" .. player.UserId .. ")")
			warning(player, "You do not have permission to use commands.")
			return
		end

		local args = message:sub(2):split(" ") :: { string }

		local label = args[1]:lower()

		local hasGeneral = generalCommands[label] ~= nil

		if playerCommands[label] then
			if #args < 2 then
				if hasGeneral then
					generalCommands[label](player, {})
					return
				end
				warning(player, "Usage: /" .. label .. " <player>")
				return
			end

			local targetName = args[2]
			local targetPlayer = game.Players:FindFirstChild(targetName)
			if targetPlayer == nil then
				warning(player, "Player not found: " .. targetName)
				return
			end

			playerCommands[label](player, targetPlayer, TableUtils.sub(args, 3))
			return
		end

		if hasGeneral then
			generalCommands[label](player, TableUtils.sub(args, 2))
		else
			Packets.SendWarningPacket:FireClient(player, "Unknown command: " .. args[1])
		end
	end)
	table.insert(Connections[player.UserId], conn)
end)
