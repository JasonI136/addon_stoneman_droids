AddCSLuaFile()

// BASE NPC ENTITIES
ENT.Type            = "nextbot"
ENT.Base            = "base_nextbot"
ENT.PrintName = "StonemanNPCBaseEnt"
ENT.Author = "Stoneman"
ENT.Category = "Stoneman"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.AutomaticFrameAdvance = true
ENT.RenderGroup = RENDERGROUP_BOTH 

ENT.activity_stack = util.Stack()
ENT.activity_end_stack = util.Stack()

ENT.CollisionBounds = {Vector(-16,-16,0),Vector(16,16,72)}
ENT.CrouchCollisionBounds = {Vector(-16,-16,0),Vector(16,16,42)}

ENT.IsStonemanDroids = true

ENT.MDL = "models/tfa/comm/gg/pm_sw_droid_b1.mdl"

// Set up your variables here!
ENT.MaxHP = 125

ENT.DroidType = "gunner_performance"
ENT.WeaponDamage = 19

ENT.VisionRange = 6000
ENT.IsFriendly = false

ENT.MDL = "models/tfa/comm/gg/pm_sw_droid_b1.mdl"
ENT.WeaponModel = "models/weapons/gateway/e5_blaster.mdl"

ENT.WeaponFireRate = 2.5
ENT.MagazineSize = 30

ENT.WeaponSpread = Vector( 0.08, 0.08, 0.08 )
ENT.DroidTeam = "cis"

ENT.IsJetpack = false
ENT.FireSound = "w/e5.wav"

// Based off luna's DTs, pretty nifty, thanks Luna!
function ENT:AddDT( types, name, data )
	if not self.DataTBL then self.DataTBL = {} end

	if self.DataTBL[ types ] then
		self.DataTBL[ types ] = self.DataTBL[ types ] + 1
	else
		self.DataTBL[ types ] = 0
	end

	self:NetworkVar( types, self.DataTBL[ types ], name, data )
end

function ENT:BaseDataTBL()
    // Base Attack Data
	self:AddDT( "Entity", "DroidTarget")
	self:AddDT( "Vector", "AimingPosition")

	if SERVER then
		self:SetHealth( self.MaxHP )
		self:SetMaxHealth( self.MaxHP )

        self.MaxVisionRange = (self.VisionRange * self.VisionRange) or 0
        
        // Server variables!
        self.ShotsFired = 0
		self.ShouldFire = true
		self.NextFire = CurTime()
		self.NextFaceThink = CurTime()
	end

	self:OnSetupDataTables()
end

function ENT:GetActiveWeapon()
	return "gg_sw_dc15s"
end

function ENT:SetupCollisionBounds()
	local data = self.CollisionBounds
	
	self:SetCollisionBounds( data[1], data[2] )

	if self:PhysicsInitShadow( false, false ) then
		self:GetPhysicsObject():SetMass(85)
	end
end

function ENT:UpdatePhysicsObject()
	local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:SetAngles(angle_zero)

		phys:UpdateShadow(self:GetPos(),angle_zero,FrameTime())

		phys:SetPos( self:GetPos() )
	end
end

function ENT:PhysicsObjectCollide(data)
end

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

function ENT:OnSetupDataTables()
end

function ENT:CheckValidGround()
	// Check if the droid is standing on skybox texture.
	local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos() - Vector( 0, 0, 100 ),
		filter = self
	} )

	if tr.HitSky then
		return false
	end

	if tr.HitNoDraw then
		return false
	end

	return true
end

function ENT:GetHeadPosition()
	if self:LookupBone( "ValveBiped.Bip01_Head1" ) == nil then return self:GetPos() end

	local headpos = self:GetBonePosition( self:LookupBone( "ValveBiped.Bip01_Head1" ) )
	
	if headpos then
		return headpos
	else
		local bboxcenter = self:OBBCenter()
		return bboxcenter
	end
end

function ENT:GetHandPosition()
	if self:LookupBone( "ValveBiped.Bip01_R_Hand" ) == nil then
		local pos = self:GetPos() + self:GetForward() * 50 + self:GetUp() * 50
		return pos
	end

	local handpos = self:GetBonePosition( self:LookupBone( "ValveBiped.Bip01_R_Hand" ) )
	
	if handpos then
		return handpos
	else
		// Return the bounding box center if the bone doesn't exist.
		local bboxcenter = self:OBBCenter()
		return bboxcenter
	end
end

concommand.Add( "stoneman_droid_client_entity", function( ply, cmd, args )
	if SERVER then return end
	PrintTable( ents.GetAll())
end )