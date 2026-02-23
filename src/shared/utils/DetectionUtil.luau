local ServerScriptService = game:GetService("ServerScriptService")
local GameObject = require(ServerScriptService.Server.objects.GameObject)
local Util = {}

function Util.GetAngleBetweenVectors(v1: Vector3, v2: Vector3): number
	local dotProduct = v1.Unit:Dot(v2.Unit)
	return math.deg(math.acos(dotProduct)) -- return angle in degrees (acos  *180/pi)
end

function Util.detectPlayerNearby(origin: Vector3, radius: number): { Player }
	local nearbyPlayers = {}
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - origin).Magnitude
			if distance <= radius then
				table.insert(nearbyPlayers, player)
			end
		end
	end
	return nearbyPlayers
end

function Util.detectObjectNearby(
	origin: Vector3,
	radius: number,
	limit: number?,
	predicate: ((GameObject.GameObject) -> boolean)?
): { GameObject.GameObject }
	local nearbyObjects = {}
	local count = 0
	for _, obj in pairs(GameObject.getAll()) do
		if obj.model and obj:getPrimaryPart() then
			local distance = (obj:getPrimaryPart().Position - origin).Magnitude
			if distance <= radius then
				if not predicate or predicate(obj) then
					table.insert(nearbyObjects, obj)
					count = count + 1
					if limit and count >= limit then
						break
					end
				end
			end
		end
	end

	return nearbyObjects
end

function Util.GetEntitysInAngle(
	origin: Vector3,
	unitDirection: Vector3,
	radius: number,
	angleDegrees: number,
	limit: number?,
	predicate: ((GameObject.GameObject) -> boolean)?
): { GameObject.GameObject }
	local dectectedEntities: { GameObject.GameObject } = {}

	local count = 0
	for _, entity in pairs(GameObject.getAll()) do
		if predicate then
			if not predicate(entity) then
				continue
			end
		end

		local entityPosition = entity:getPosition()
		local toEntity = (entityPosition - origin)
		local distance = toEntity.Magnitude

		-- Check Distance
		if distance > radius then
			continue
		end

		-- Check Angle
		local angleBetween = Util.GetAngleBetweenVectors(unitDirection, toEntity)
		if angleBetween > angleDegrees then
			continue
		end

		-- insert + limit check
		table.insert(dectectedEntities, entity)
		count = count + 1
		if limit and count >= limit then
			break
		end
	end

	return dectectedEntities
end

function Util.GetNearObjectsAround(
	source: GameObject.GameObject,
	radius: number,
	limit: number?,
	predicate: ((GameObject.GameObject) -> boolean)?
): { GameObject.GameObject }
	return Util.detectObjectNearby(source:getPosition(), radius, limit, function(obj): boolean
		if predicate and not predicate(obj) then
			return false
		end
		return obj.uuid ~= source.uuid -- Exclude self
	end)
end

function Util.GetInAngleObjectsAround(
	source: GameObject.GameObject,
	radius: number,
	angleDegrees: number,
	limit: number?,
	predicate: ((GameObject.GameObject) -> boolean)?
): { GameObject.GameObject }
	if not source.model.PrimaryPart then
		error("Source GameObject must have a PrimaryPart for angle detection.")
	end
	local forwardVector = source.model.PrimaryPart.CFrame.LookVector :: Vector3
	return Util.GetEntitysInAngle(
		source:getPosition(),
		forwardVector,
		radius,
		angleDegrees,
		limit,
		function(obj): boolean
			if predicate and not predicate(obj) then
				return false
			end
			return obj.uuid ~= source.uuid -- Exclude self
		end
	)
end

return Util
