local ServerScriptService = game:GetService("ServerScriptService")
local GameObject = require(ServerScriptService.Server.objects.GameObject)
local Module = {}
Module.__index = Module

export type Module = typeof(Module) & {
	holder: GameObject.GameObject,
}

function Module.new(holder: GameObject.GameObject)
	local self = setmetatable({}, Module)
	self.holder = holder
	return self
end

function Module:deactivate()
	print("Deactivating module for GameObject with uuid: " .. self.holder.uuid)
end

return Module
