local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local networkFolder = ReplicatedStorage:WaitForChild("Network")

local packetsFolder
if RunService:IsServer() then
	packetsFolder = Instance.new("Folder")
	packetsFolder.Name = "Packets"
	packetsFolder.Parent = networkFolder
else
	packetsFolder = networkFolder:WaitForChild("Packets")
end

local function getPacket(name: string): RemoteEvent
	if RunService:IsServer() then
		local found = packetsFolder:FindFirstChild(name)
		if found then
			return found
		end
		local packet = Instance.new("RemoteEvent")
		packet.Name = name
		packet.Parent = packetsFolder
		return packet
	else
		return packetsFolder:WaitForChild(name)
	end
end

local Packets = {
	-- Logging
	SendLogPacket = getPacket("SendLogPacket"),
	SendWarningPacket = getPacket("SendWarningPacket"),
	SendErrorPacket = getPacket("SendErrorPacket"),
}

return Packets
