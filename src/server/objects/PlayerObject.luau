local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Animations = require(ReplicatedStorage.Shared.registry.Animations)
local DetectionUtil = require(ReplicatedStorage.Shared.utils.DetectionUtil)
local Profiles = require(ServerScriptService.Server.data.Profiles)
local AnimatorModule = require(ServerScriptService.Server.objects.modules.AnimatorModule)
local GameObject = require(script.Parent.GameObject)
local LivingObject = require(script.Parent.LivingObject)
local ObjectTypes = require(script.Parent.ObjectTypes)
local PlayerObject = {}
PlayerObject.__index = PlayerObject
setmetatable(PlayerObject, GameObject)

export type PlayerObject = GameObject.GameObject & {
	player: Player,
	data: PlayerData,
	characterConnections: { RBXScriptConnection },
	destroyConnection: RBXScriptConnection,
	animatorModule: AnimatorModule.AnimatorModule,
	attackCooltime: boolean,
} & typeof(PlayerObject)

-- Static Methods
local PlayerObjectMap = {} :: { [Player]: PlayerObject }

function PlayerObject.get(player: Player): PlayerObject
	return PlayerObjectMap[player]
end

function PlayerObject.remove(player: Player): PlayerObject?
	local playerObject = PlayerObjectMap[player]
	if playerObject then
		PlayerObjectMap[player] = nil
	end
	return playerObject
end

-- PlayerObject Class
function PlayerObject.new(player: Player)
	local self = GameObject.new(player.Character or player.CharacterAdded:Wait(), ObjectTypes.Player)
	setmetatable(self, PlayerObject)
	self.player = player
	self.data = Profiles.get(player)
	self.characterConnections = {}
	self.animatorModule = AnimatorModule.new(self)
	PlayerObjectMap[player] = self
	return self
end

function PlayerObject.getHumanoid(self: PlayerObject): Humanoid
	local humanoid = self.model:FindFirstChild("Humanoid")
	if not humanoid then
		error("Humanoid not found for player: " .. self.player.Name)
	end
	return humanoid
end

function PlayerObject.initialize(self: PlayerObject)
	self:getHumanoid().Died:Once(function()
		for _, conn in pairs(self.characterConnections) do
			conn:Disconnect()
		end
		self.characterConnections = {}
		self.player.CharacterAdded:Once(function(character: Model)
			self.model = character
			self:initialize()
		end)
	end)

	local tool = ServerStorage:FindFirstChild("Tools"):FindFirstChild("Pickaxe"):Clone()
	tool.Parent = self.model
	table.insert(
		self.characterConnections,
		tool.Activated:Connect(function()
			self:useTool()
		end)
	)

	print("PlayerObject Initialized for:", self.player.Name)
end

function PlayerObject.destroy(self: PlayerObject)
	GameObject.destroy(self)
	PlayerObject.remove(self.player)
	if self.destroyConnection then
		self.destroyConnection:Disconnect()
	end
	self.animatorModule:deactivate()
end

function PlayerObject.useTool(self: PlayerObject)
	if self.attackCooltime then
		return
	end
	self.animatorModule:play(Animations.PickaxeSwing)
	self.attackCooltime = true
	task.wait(0.3)
	local targets = DetectionUtil.GetNearObjectsAround(self, 10)
	for _, target in pairs(targets) do
		if target:isLiving() then
			local livingTarget = target :: LivingObject.LivingObject
			livingTarget:takeDamage(30)
			print(livingTarget.type .. "'s hp : " .. livingTarget:getHealth() .. " / " .. livingTarget:getMaxHealth())
		end
	end
	task.wait(0.25)
	self.attackCooltime = false
end

return PlayerObject
