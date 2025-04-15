AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_npc_animator.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sv_npc_behavior.lua")
include("sv_npc_target.lua")
include("sv_npc_weapon.lua")

function ENT:Initialize()
    self:SetModel( self.MDL )
    if self.BodygroupData then
        self:SetBodygroup( self:FindBodygroupByName( self.BodygroupData or "none" ), self.BodygroupID )
    end
    self:StartActivity( self:DroidAnimations() )
    self:SetupCollisionBounds()
end

function ENT:OnRemove()
end