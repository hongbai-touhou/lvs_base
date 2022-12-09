AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_func.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sh_func.lua")
include("sv_ai.lua")
include("sv_cppi.lua")
include("sv_driving.lua")
include("sv_engine.lua")
include("sv_physics.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent:StoreCPPI( ply )
	ent:SetPos( tr.HitPos + tr.HitNormal * 15 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	self:SetModel( self.MDL )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:AddFlags( FL_OBJECT )

	local PObj = self:GetPhysicsObject()

	if not IsValid( PObj ) then 
		self:Remove()

		print("LVS: missing model. Vehicle terminated.")

		return
	end

	PObj:SetMaterial( "default_silent" )
	PObj:EnableMotion( false )
	PObj:EnableDrag( false )

	self:OnSpawn( PObj )

	self:StartMotionController()

	PObj:EnableMotion( true )

	self:PhysWake()

	self:AutoAI()
end

function ENT:OnSpawn( PObj )
end

function ENT:Think()
	self:HandleActive()
	self:HandleStart()
	self:PhysicsThink()
	self:OnTick()

	self:NextThink( CurTime() )
	
	return true
end

function ENT:OnDriverChanged( Old, New, VehicleIsActive )
end

function ENT:OnGunnerChanged( Old, New )
end

function ENT:OnTick()
end

function ENT:OnRemove()
end

function ENT:Lock()
	if self:GetlvsLockedStatus() then return end

	self:SetlvsLockedStatus( true )
	self:EmitSound( "doors/latchlocked2.wav" )
end

function ENT:UnLock()
	if not self:GetlvsLockedStatus() then return end

	self:SetlvsLockedStatus( false )
	self:EmitSound( "doors/latchunlocked1.wav" )
end

function ENT:Use( ply )
	if not IsValid( ply ) then return end

	if self:GetlvsLockedStatus() then 

		self:EmitSound( "doors/default_locked.wav" )

		return
	end

	self:SetPassenger( ply )
end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

function ENT:UpdateTransmitState() 
	return TRANSMIT_ALWAYS
end

function ENT:GetMissileOffset()
	return self:OBBCenter()
end

function ENT:GetCrosshairFilterEnts()
	if not istable( self.CrosshairFilterEnts ) then
		self.CrosshairFilterEnts = {}

		for _, Entity in pairs( constraint.GetAllConstrainedEntities( self ) ) do
			if not IsValid( Entity ) then continue end

			table.insert( self.CrosshairFilterEnts , Entity )
		end

		for _, Parent in pairs( self.CrosshairFilterEnts ) do
			for _, Child in pairs( Parent:GetChildren() ) do
				if not IsValid( Child ) then continue end

				table.insert( self.CrosshairFilterEnts , Child )
			end
		end
	end

	return self.CrosshairFilterEnts
end