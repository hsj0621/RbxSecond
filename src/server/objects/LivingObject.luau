local Debris = game:GetService("Debris")
local GameObject = require(script.Parent.GameObject)
local ObjectTypes = require(script.Parent.ObjectTypes)
local LivingObject = {}
LivingObject.__index = LivingObject
setmetatable(LivingObject, GameObject)

export type LivingObject = typeof(LivingObject) & GameObject.GameObject & {
	Humanoid: Humanoid,
}

function LivingObject.new(model: Model, type: ObjectTypes.ObjectType)
	local self = GameObject.new(model, type)
	setmetatable(self, LivingObject)
	local humanoid = self.model:FindFirstChild("Humanoid")
	if not humanoid then
		error("Humanoid not found for object with uuid: " .. self.uuid)
	end
	self.Humanoid = humanoid

	humanoid.Died:Once(function()
		self:onDeath()
		self:clear()
		Debris:AddItem(self.model, 3)
	end)
	return self
end

function LivingObject.onDeath(self: LivingObject)
	print("LivingObject" .. self.type .. " with uuid " .. self.uuid .. " has died.")
end

function LivingObject:takeDamage(amount: number)
	self.Humanoid:TakeDamage(amount)
end

function LivingObject:isAlive(): boolean
	return self.Humanoid.Health > 0
end

function LivingObject:getHealth(): number
	return self.Humanoid.Health
end

function LivingObject:getMaxHealth(): number
	return self.Humanoid.MaxHealth
end

function LivingObject:heal(amount: number)
	self.Humanoid.Health = math.min(self.Humanoid.Health + amount, self.Humanoid.MaxHealth)
end

function LivingObject:setHealth(amount: number)
	self.Humanoid.Health = math.clamp(amount, 0, self.Humanoid.MaxHealth)
end

function LivingObject:setMaxHealth(amount: number)
	self.Humanoid.MaxHealth = math.max(amount, 1) -- MaxHealth는 최소 1 이상이어야 합니다.
	self.Humanoid.Health = math.min(self.Humanoid.Health, self.Humanoid.MaxHealth) -- 현재 Health가 MaxHealth를 초과하지 않도록 조정
end

return LivingObject
