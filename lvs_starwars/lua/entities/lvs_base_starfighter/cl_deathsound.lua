
function ENT:OnDestroyed()
	if not self.DeathSound then return end

	if self:GetVelocity():Length() <= self.MaxVelocity * 0.5 then return end

	local snd = CreateSound( self, self.DeathSound )
	snd:SetSoundLevel( 125 )
	snd:PlayEx( 1, 50 + 50 * self:CalcDoppler( LocalPlayer() ) )

	LVS.DeathSounds[ self:EntIndex() ] = snd
end

function ENT:StopDeathSound()
	local ply = LocalPlayer()

	if not IsValid( ply ) then return end

	local ViewEnt = ply:GetViewEntity()

	if not IsValid( ViewEnt ) then
		ViewEnt = ply
	end

	local ID = self:EntIndex()

	if not LVS.DeathSounds[ ID ] then return end

	local delay = (self:GetPos() - ViewEnt:GetPos()):Length() / 13503.9

	timer.Simple( delay, function()
		LVS.DeathSounds[ ID ]:Stop()
		LVS.DeathSounds[ ID ] = nil
	end )
end

