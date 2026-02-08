local ServerScriptService = game:GetService("ServerScriptService")
local Admins = require(script.Parent.Admins)
local PlayerEvents = require(ServerScriptService.Server.events.PlayerEvents)
local Connections = require(ServerScriptService.Server.player.Connections)
local Profiles = require(ServerScriptService.Server.player.data.Profiles)

PlayerEvents.LoginEvent.Event:Connect(function(player: Player)
	local conn = player.Chatted:Connect(function(message: string)
		if message:sub(1, 1) ~= "!" then
			return
		end
		if not Admins.isAdmin(player.UserId) then
			return
		end

		local args = message:sub(2):split(" ") :: { string }

		if args[1] == "data" then
			local target

			if #args == 1 then
				target = player
			elseif args[2] == "*" then
				print(Profiles)
				return
			else
				target = game.Players:FindFirstChild(args[2])
			end
			if not target then
				warn("Target player not found for " .. args[2])
			end
			print("Data of " .. target.Name .. ":")
			print(Profiles.get(target))
		else
			print("Unknown command")
		end
	end)
	table.insert(Connections[player.UserId], conn)
end)
