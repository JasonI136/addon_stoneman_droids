AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 125

ENT.DroidType = "gunner_performance"
ENT.WeaponDamage = 12

ENT.VisionRange = 5000
ENT.IsFriendly = false

ENT.MDL = "models/b1/pm_droid_cis_b1.mdl"
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"

ENT.FireRate = 0.5
ENT.MagazineSize = 30

ENT.WeaponSpread = Vector( 0.05, 0.01, 0 )
ENT.DroidTeam = "cis"

ENT.FireSound = "w/e5.wav"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b1_droid", {
	Name = "B1 Droid - Performance",
	Class = "b1_droid",
	Category = "Stoneman's Droids"
} )
