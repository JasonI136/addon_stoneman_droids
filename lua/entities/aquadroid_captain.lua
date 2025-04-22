AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 900

ENT.DroidType = "gunner_performance"
ENT.WeaponDamage = 16

ENT.VisionRange = 8000
ENT.IsFriendly = false

ENT.MDL = "models/aqua_elite/pm_droid_aqua_elite.mdl"
ENT.WeaponModel = ""
ENT.Anim = ACT_HL2MP_IDLE_PISTOL

ENT.FireRate = 0.4
ENT.MagazineSize = 30

ENT.WeaponSpread = Vector( 0.08, 0.08, 0.08 )
ENT.DroidTeam = "cis"

ENT.FireSound = "weapons/1misc_guns/wpn_btldroid_laser_dbl_shoot_01.ogg"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b2_droid", {
	Name = "Aquadroids Captain - Performance",
	Class = "aqua_droid",
	Category = "Stoneman's Droids"
} )
