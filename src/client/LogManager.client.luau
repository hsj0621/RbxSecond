local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packets = require(ReplicatedStorage.Shared.network.Packets)

Packets.SendLogPacket.OnClientEvent:Connect(function(msg: any)
	print(msg)
end)

Packets.SendWarningPacket.OnClientEvent:Connect(function(msg: any)
	warn(msg)
end)
