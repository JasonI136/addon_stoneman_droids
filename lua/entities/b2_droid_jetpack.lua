AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 1000

ENT.DroidType = "flying"
ENT.WeaponDamage = 16

ENT.VisionRange = 7000
ENT.IsFriendly = false

ENT.MDL = "models/b2_elite/pm_droid_b2_elite.mdl"
ENT.WeaponModel = ""

ENT.FireRate = 0.3
ENT.MagazineSize = 30

ENT.WeaponSpread = Vector( 0.05, 0.05, 0.05 )
ENT.DroidTeam = "cis"

ENT.IsJetpack = true
ENT.FireSound = "weapons/1misc_guns/wpn_btldroid_laser_dbl_shoot_01.ogg"

-- ENT.BodygroupData = "backpack"
-- ENT.BodygroupID = 3

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b2_droid_jetpack", {
	Name = "B2 Droid - Jetpack",
	Class = "b2_droid_jetpack",
	Category = "Stoneman's Droids"
} )
