local HttpService = game:GetService("HttpService")
local ObjectTypes = require(script.Parent.ObjectTypes)
local GameObject = {}

-- GameObject Manager
local GameObjects = {} :: { [string]: GameObject }

function GameObject.add(gameObject: GameObject)
	if GameObjects[gameObject.uuid] then
		error("GameObject with uuid " .. gameObject.uuid .. " already exists.")
	end
	GameObjects[gameObject.uuid] = gameObject
end

function GameObject.remove(uuid: string): GameObject?
	local gameObject = GameObjects[uuid]
	if gameObject then
		GameObjects[uuid] = nil
	end
	return gameObject
end

function GameObject.get(uuid: string): GameObject?
	return GameObjects[uuid]
end

function GameObject.getAll(): { GameObject }
	return GameObjects
end

-- GameObject Class
-- 최상위 클래스, Model과 연결되는 코드 단위에서 관리 가능한 객체
GameObject.__index = GameObject

export type GameObject = typeof(GameObject) & {
	model: Model,
	type: ObjectTypes.ObjectType,
	uuid: string,
}

function GameObject.new(model: Model, type: ObjectTypes.ObjectType)
	if not model.PrimaryPart then
		error("GameObject model must have a PrimaryPart - " .. model.Name)
	end

	local self = setmetatable({}, GameObject)
	self.model = model
	self.type = type
	self.uuid = HttpService:GenerateGUID(false)
	GameObject.add(self)
	print("GameObject created with uuid: " .. self.uuid .. " and type: " .. self.type)
	return self
end

function GameObject:destroy()
	self:clear()
	self.model:Destroy()
end

function GameObject:clear()
	GameObject.remove(self.uuid)
end

function GameObject:getPrimaryPart(): BasePart
	return self.model.PrimaryPart
end

function GameObject:getPosition(): Vector3
	return self.model.PrimaryPart.Position
end

function GameObject:isLiving(): boolean
	local humanoid = self.model:FindFirstChild("Humanoid")
	return humanoid and humanoid.Health > 0
end
return GameObject
