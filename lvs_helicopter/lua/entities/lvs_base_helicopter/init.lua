AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_camera.lua" )
AddCSLuaFile( "sh_camera_eyetrace.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_flyby.lua" )
include("shared.lua")
include("sv_ai.lua")
include("sv_engine.lua")
include("sh_camera_eyetrace.lua")

function ENT:OnCreateAI()
	self:StartEngine()
	self.COL_GROUP_OLD = self:GetCollisionGroup()
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
end

function ENT:OnRemoveAI()
	self:StopEngine()
	self:SetCollisionGroup( self.COL_GROUP_OLD or COLLISION_GROUP_NONE )
end

function ENT:ApproachTargetAngle( TargetAngle, OverridePitch, OverrideYaw, OverrideRoll, FreeMovement )
	local LocalAngles = self:WorldToLocalAngles( TargetAngle )

	if self:GetAI() then self:SetAIAimVector( LocalAngles:Forward() ) end

	local LocalAngPitch = LocalAngles.p
	local LocalAngYaw = LocalAngles.y
	local LocalAngRoll = LocalAngles.r

	local TargetForward = TargetAngle:Forward()
	local Forward = self:GetForward()

	local AngDiff = math.deg( math.acos( math.Clamp( Forward:Dot( TargetForward ) ,-1,1) ) )

	local WingFinFadeOut = math.max( (90 - AngDiff ) / 90, 0 )
	local RudderFadeOut = math.min( math.max( (120 - AngDiff ) / 120, 0 ) * 3, 1 )

	local AngVel = self:GetPhysicsObject():GetAngleVelocity()

	local SmoothPitch = math.Clamp( math.Clamp(AngVel.y / 50,-0.25,0.25) / math.abs( LocalAngPitch ), -1, 1 )
	local SmoothYaw = math.Clamp( math.Clamp(AngVel.z / 50,-0.25,0.25) / math.abs( LocalAngYaw ), -1, 1 )

	local VelL = self:WorldToLocal( self:GetPos() + self:GetVelocity() )
	local Pitch = math.Clamp(-LocalAngPitch / 10 + SmoothPitch,-1,1)
	local Yaw = math.Clamp(-LocalAngYaw + SmoothYaw,-1,1)
	local Roll = math.Clamp( (math.Clamp(VelL.y / self.MaxVelocity,-1,1) * 90 - self:GetAngles().r) / 90 ,-1 , 1 )

	if FreeMovement then
		Roll = math.Clamp( -LocalAngYaw * WingFinFadeOut / 180 , -1 , 1 )
	end

	if OverridePitch and OverridePitch ~= 0 then
		Pitch = OverridePitch
	end

	if OverrideYaw and OverrideYaw ~= 0 then
		Yaw = OverrideYaw
	end
	
	if OverrideRoll and OverrideRoll ~= 0 then
		Roll = OverrideRoll
	end

	self:SetSteer( Vector( math.Clamp(Roll * 1.25,-1,1), math.Clamp(-Pitch * 1.25,-1,1), -Yaw) )
end

function ENT:OnSkyCollide( data, PhysObj )

	local NewVelocity = self:VectorSubtractNormal( data.HitNormal, data.OurOldVelocity ) - data.HitNormal * 400

	PhysObj:SetVelocityInstantaneous( NewVelocity )
	PhysObj:SetAngleVelocityInstantaneous( data.OurOldAngularVelocity )

	return true
end

function ENT:PhysicsSimulate( phys, deltatime )
	phys:Wake()

	local WorldGravity = self:GetWorldGravity()
	local WorldUp = self:GetWorldUp()

	local Up = self:GetUp()
	local Left = -self:GetRight()

	local Mul = self:GetThrottle()

	local Steer = self:GetSteer()

	local Vel = phys:GetVelocity()
	local VelL = phys:WorldToLocal( phys:GetPos() + Vel )

	local YawPull = (math.deg( math.acos( math.Clamp( WorldUp:Dot( Left ) ,-1,1) ) ) - 90) /  90

	local GravityYaw = math.abs( YawPull ) ^ 1.25 * self:Sign( YawPull ) * (WorldGravity / 100) * (math.min( Vector(VelL.x,VelL.y,0):Length() / self.MaxVelocity,1) ^ 2)

	local Pitch = math.Clamp(Steer.y,-1,1) * self.TurnRatePitch
	local Yaw = math.Clamp(Steer.z + GravityYaw,-1,1) * self.TurnRateYaw * 60
	local Roll = math.Clamp(Steer.x,-1,1) * 1.5 * self.TurnRateRoll

	local Ang = self:GetAngles()

	local InputThrust = math.min( self:GetThrust() , 0 ) * self.ThrustDown + math.max( self:GetThrust(), 0 ) * self.ThrustUp

	local FadeMul = (1 - math.max( (45 - self:AngleBetweenNormal( WorldUp, Up )) / 45,0)) ^ 2
	local ThrustMul = math.Clamp( 1 - (Vel:Length() / self.MaxVelocity) * FadeMul, 0, 1 )

	local Thrust = self:LocalToWorldAngles( Angle(Pitch,0,Roll) ):Up() * (WorldGravity + InputThrust * 500 * ThrustMul)

	local Force, ForceAng = phys:CalculateForceOffset( Thrust, phys:LocalToWorld( phys:GetMassCenter() ) + self:GetUp() * 1000 )

	local ForceLinear = (Force - Vel * 0.15 * self.ForceLinearDampingMultiplier) * Mul
	local ForceAngle = (ForceAng + (Vector(0,0,Yaw) - phys:GetAngleVelocity() * 1.5 * self.ForceAngleDampingMultiplier) * deltatime * 250) * Mul

	return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
end
