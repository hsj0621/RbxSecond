local ServerScriptService = game:GetService("ServerScriptService")
local GameObject = require(ServerScriptService.Server.objects.GameObject)
local Module = require(script.Parent.Module)
local AnimatorModule = {}
AnimatorModule.__index = AnimatorModule
setmetatable(AnimatorModule, Module)

export type AnimatorModule = Module.Module & {
	tracks: { [Enum.AnimationPriority]: AnimationTrack },
	play: (
		self: AnimatorModule,
		animation: Animation,
		priority: Enum.AnimationPriority?,
		loop: boolean?,
		speed: number?
	) -> (),
}

function AnimatorModule.new(holder: GameObject.GameObject)
	local self = Module.new(holder)
	setmetatable(self, AnimatorModule)
	if not holder:isLiving() then
		error("AnimatorModule can only be added to LivingObjects.")
	end

	self.tracks = {} :: { [Enum.AnimationPriority]: AnimationTrack }
	return self
end

function AnimatorModule.play(
	self: AnimatorModule,
	animation: Animation,
	priority: Enum.AnimationPriority?,
	loop: boolean?,
	speed: number?
)
	local actor = self.holder

	if not actor.model:FindFirstChild("Humanoid") then
		error("AnimatorModule requires a Humanoid to play animations.")
	end
	local animator = actor.model.Humanoid:FindFirstChildOfClass("Animator") :: Animator
	if not animator then
		error("Animator not found on Humanoid for GameObject with uuid: " .. actor.uuid)
	end

	local track = animator:LoadAnimation(animation) :: AnimationTrack

	track.Priority = priority or Enum.AnimationPriority.Action2 :: Enum.AnimationPriority
	track.Looped = loop or false

	-- 기존 트랙이 있으면 중지
	if self.tracks[track.Priority] then
		self.tracks[track.Priority]:Stop(0.1)
	end
	self.tracks[track.Priority] = track
	track:Play(0.1, nil, speed or 1)
end

return AnimatorModule
