
local icon_load_version = Material("gui/html/refresh")
local bgMat = Material( "lvs_controlpanel_bg.png" )
local adminMat = Material( "icon16/shield.png" )

local FrameSizeX = 600
local FrameSizeY = 400

local function ClientSettings( Canvas )
end

local function ClientControls( Canvas )
end

local function ServerSettings( Canvas )
end

function LVS:OpenClientSettings()
	if not IsValid( LVS.Frame ) then return end

	local BasePanel = LVS.Frame:CreatePanel()

	local DPanel = vgui.Create( "DPanel", BasePanel )
	DPanel.Paint = function(self, w, h ) end
	DPanel:DockMargin( 0, 0, 0, 0 )
	DPanel:SetSize( FrameSizeX, 25 )
	DPanel:Dock( TOP )

	local TabPanel = vgui.Create( "DPanel", BasePanel )
	TabPanel.Paint = function(self, w, h ) end
	TabPanel:DockMargin( 0, 0, 0, 0 )
	TabPanel:SetSize( FrameSizeX, 25 )
	TabPanel:Dock( TOP )

	local SettingsPanel = vgui.Create( "DPanel", TabPanel )
	SettingsPanel:DockMargin( 0, 0, 0, 0 )
	SettingsPanel:SetSize( FrameSizeX * 0.5, 32 )
	SettingsPanel:Dock( LEFT )
	SettingsPanel.Paint = function(self, w, h ) 
		draw.DrawText( "SETTINGS", "LVS_FONT", w * 0.5, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local DButton = vgui.Create( "DButton", TabPanel )
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:SetText( "" )
	DButton:SetSize( FrameSizeX * 0.5, 32 )
	DButton:Dock( RIGHT )
	DButton.DoClick = function()
		surface.PlaySound( "buttons/button14.wav" )
		LVS:OpenClientControls()
	end
	DButton.Paint = function(self, w, h ) 
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)

		local Hovered = self:IsHovered()

		if Hovered then
			surface.SetDrawColor( 120, 120, 120, 255 )
		else
			surface.SetDrawColor( 80, 80, 80, 255 )
		end

		surface.DrawRect(1, 0, w-2, h-1)

		local Col = Hovered and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
		draw.DrawText( "CONTROLS", "LVS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local DButton = vgui.Create( "DButton", DPanel )
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:SetText( "" )
	DButton:SetSize( FrameSizeX * 0.5, 32 )
	DButton:Dock( RIGHT )
	DButton.DoClick = function()
		if LocalPlayer():IsSuperAdmin() then
			surface.PlaySound( "buttons/button14.wav" )
			LVS:OpenServerMenu()
		else
			surface.PlaySound( "buttons/button11.wav" )
		end
	end
	DButton.Paint = function(self, w, h ) 
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)

		local Hovered = self:IsHovered()

		if Hovered then
			draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 120, 120, 120, 255 ) )
		else
			draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 80, 80, 80, 255 ) )
		end

		surface.SetDrawColor( 255, 255, 255, Hovered and 255 or 50 )
		surface.SetMaterial( adminMat )
		surface.DrawTexturedRect( 3, 2, 16, 16 )

		local Col = Hovered and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
		draw.DrawText( "SERVER", "LVS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local ClientPanel = vgui.Create( "DPanel", DPanel )
	ClientPanel.Paint = function(self, w, h ) end
	ClientPanel:DockMargin( 0, 0, 0, 0 )
	ClientPanel:SetSize( FrameSizeX * 0.5, 32 )
	ClientPanel:Dock( LEFT )
	ClientPanel.Paint = function(self, w, h ) 
		draw.DrawText( "CLIENT", "LVS_FONT", w * 0.5, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local Canvas = vgui.Create( "DPanel", BasePanel )
	Canvas.Paint = function(self, w, h ) end
	Canvas:DockMargin( 0, 0, 0, 0 )
	Canvas:SetSize( FrameSizeX, 25 )
	Canvas:Dock( FILL )

	ClientSettings( Canvas )
end

function LVS:OpenClientControls()
	if not IsValid( LVS.Frame ) then return end

	local BasePanel = LVS.Frame:CreatePanel()

	local DPanel = vgui.Create( "DPanel", BasePanel )
	DPanel.Paint = function(self, w, h ) end
	DPanel:DockMargin( 0, 0, 0, 0 )
	DPanel:SetSize( FrameSizeX, 25 )
	DPanel:Dock( TOP )

	local TabPanel = vgui.Create( "DPanel", BasePanel )
	TabPanel.Paint = function(self, w, h ) end
	TabPanel:DockMargin( 0, 0, 0, 0 )
	TabPanel:SetSize( FrameSizeX, 25 )
	TabPanel:Dock( TOP )

	local SettingsPanel = vgui.Create( "DPanel", TabPanel )
	SettingsPanel:DockMargin( 0, 0, 0, 0 )
	SettingsPanel:SetSize( FrameSizeX * 0.5, 32 )
	SettingsPanel:Dock( RIGHT )
	SettingsPanel.Paint = function(self, w, h ) 
		draw.DrawText( "CONTROLS", "LVS_FONT", w * 0.5, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local DButton = vgui.Create( "DButton", TabPanel )
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:SetText( "" )
	DButton:SetSize( FrameSizeX * 0.5, 32 )
	DButton:Dock( LEFT )
	DButton.DoClick = function()
		surface.PlaySound( "buttons/button14.wav" )
		LVS:OpenClientSettings()
	end
	DButton.Paint = function(self, w, h ) 
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)

		local Hovered = self:IsHovered()

		if Hovered then
			surface.SetDrawColor( 120, 120, 120, 255 )
		else
			surface.SetDrawColor( 80, 80, 80, 255 )
		end

		surface.DrawRect(1, 1, w-2, h-2)

		local Col = Hovered and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
		draw.DrawText( "SETTINGS", "LVS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local DButton = vgui.Create( "DButton", DPanel )
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:SetText( "" )
	DButton:SetSize( FrameSizeX * 0.5, 32 )
	DButton:Dock( RIGHT )
	DButton.DoClick = function()
		if LocalPlayer():IsSuperAdmin() then
			surface.PlaySound( "buttons/button14.wav" )
			LVS:OpenServerMenu()
		else
			surface.PlaySound( "buttons/button11.wav" )
		end
	end
	DButton.Paint = function(self, w, h ) 
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)

		local Hovered = self:IsHovered()

		if Hovered then
			draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 120, 120, 120, 255 ) )
		else
			draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 80, 80, 80, 255 ) )
		end

		surface.SetDrawColor( 255, 255, 255, Hovered and 255 or 50 )
		surface.SetMaterial( adminMat )
		surface.DrawTexturedRect( 3, 2, 16, 16 )

		local Col = Hovered and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
		draw.DrawText( "SERVER", "LVS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local ClientPanel = vgui.Create( "DPanel", DPanel )
	ClientPanel.Paint = function(self, w, h ) end
	ClientPanel:DockMargin( 0, 0, 0, 0 )
	ClientPanel:SetSize( FrameSizeX * 0.5, 32 )
	ClientPanel:Dock( LEFT )
	ClientPanel.Paint = function(self, w, h ) 
		draw.DrawText( "CLIENT", "LVS_FONT", w * 0.5, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local Canvas = vgui.Create( "DPanel", BasePanel )
	Canvas.Paint = function(self, w, h ) end
	Canvas:DockMargin( 0, 0, 0, 0 )
	Canvas:SetSize( FrameSizeX, 25 )
	Canvas:Dock( FILL )

	ClientControls( Canvas )
end

function LVS:OpenServerMenu()
	if not IsValid( LVS.Frame ) then return end

	local BasePanel = LVS.Frame:CreatePanel()

	local DPanel = vgui.Create( "DPanel", BasePanel )
	DPanel.Paint = function(self, w, h ) end
	DPanel:DockMargin( 0, 0, 0, 0 )
	DPanel:SetSize( FrameSizeX, 25 )
	DPanel:Dock( TOP )

	local ServerPanel = vgui.Create( "DPanel", DPanel )
	ServerPanel.Paint = function(self, w, h ) end
	ServerPanel:DockMargin( 0, 0, 0, 0 )
	ServerPanel:SetSize( FrameSizeX * 0.5, 32 )
	ServerPanel:Dock( RIGHT )
	ServerPanel.Paint = function(self, w, h ) 
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( adminMat )
		surface.DrawTexturedRect( 3, 2, 16, 16 )
		draw.DrawText( "SERVER", "LVS_FONT", w * 0.5, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local DButton = vgui.Create( "DButton", DPanel )
	DButton:DockMargin( 0, 0, 0, 0 )
	DButton:SetText( "" )
	DButton:SetSize( FrameSizeX * 0.5, 32 )
	DButton:Dock( LEFT )
	DButton.DoClick = function()
		surface.PlaySound( "buttons/button14.wav" )
		LVS:OpenClientSettings()
	end
	DButton.Paint = function(self, w, h ) 
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)

		local Hovered = self:IsHovered()

		if Hovered then
			draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 120, 120, 120, 255 ) )
		else
			draw.RoundedBox( 4, 1, 1, w-2, h-2, Color( 80, 80, 80, 255 ) )
		end

		local Col = Hovered and Color( 255, 255, 255, 255 ) or Color( 150, 150, 150, 255 )
		draw.DrawText( "CLIENT", "LVS_FONT", w * 0.5, 0, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end

	local Canvas = vgui.Create( "DPanel", BasePanel )
	Canvas.Paint = function(self, w, h ) end
	Canvas:DockMargin( 0, 0, 0, 0 )
	Canvas:SetSize( FrameSizeX, 25 )
	Canvas:Dock( FILL )

	ServerSettings( Canvas )
end

function LVS:OpenMenu()
	if IsValid( LVS.Frame ) then
		LVS.Frame:Close()
		LVS.Frame = nil
	end

	LVS.Frame = vgui.Create( "DFrame" )
	LVS.Frame:SetSize( FrameSizeX, FrameSizeY )
	LVS.Frame:SetTitle( "" )
	LVS.Frame:SetDraggable( true )
	LVS.Frame:SetScreenLock( true )
	LVS.Frame:MakePopup()
	LVS.Frame:Center()
	LVS.Frame.Paint = function(self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 0, 0, 0, 255 ) )
		draw.RoundedBoxEx( 8, 1, 26, w-2, h-27, Color( 120, 120, 120, 255 ), false, false, true, true )
		draw.RoundedBoxEx( 8, 0, 0, w, 25, LVS.ThemeColor, true, true )

		draw.SimpleText( "[LVS] - Control Panel ", "LVS_FONT", 5, 11, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( 255, 255, 255, 50 )
		surface.SetMaterial( bgMat )
		surface.DrawTexturedRect( 0, -50, w, w )
	end
	LVS.Frame.CreatePanel = function( self )

		if IsValid( self.OldPanel ) then
			self.OldPanel:Remove()
			self.OldPanel = nil
		end

		local DPanel = vgui.Create( "DPanel", LVS.Frame )
		DPanel:SetPos( 0, 25 )
		DPanel:SetSize( FrameSizeX, FrameSizeY - 25 )
		DPanel.Paint = function(self, w, h )
			local Col = Color( 255, 191, 0, 255 ) 

			if LVS.VERSION_GITHUB == 0 then
				surface.SetMaterial( icon_load_version )
				surface.SetDrawColor( Col )
				surface.DrawTexturedRectRotated( w - 14, h - 14, 16, 16, -CurTime() * 200 )

				draw.SimpleText( "v"..LVS:GetVersion()..LVS.VERSION_TYPE, "LVS_VERSION", w - 23, h - 14, Col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			else
				local Current = LVS:GetVersion()
				local Latest = LVS.VERSION_GITHUB

				local Pref = "v"

				if Current >= Latest then
					Col = Color(0,255,0,255)
				else
					Col = Color(255,0,0,255)
					Pref = "OUTDATED v"
				end

				draw.SimpleText( Pref..LVS:GetVersion()..LVS.VERSION_TYPE, "LVS_VERSION", w - 7, h - 14, Col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
		end

		self.OldPanel = DPanel

		return DPanel
	end

	LVS:OpenClientSettings()
end

list.Set( "DesktopWindows", "LVSMenu", {
	title = "[LVS] Settings",
	icon = "icon64/iconlvs.png",
	init = function( icon, window )
		LVS:OpenMenu()
	end
} )

concommand.Add( "lvs_openmenu", function( ply, cmd, args ) LVS:OpenMenu() end )