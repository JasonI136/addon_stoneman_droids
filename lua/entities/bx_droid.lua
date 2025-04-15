AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 210

ENT.DroidType = "gunner_performance"
ENT.WeaponDamage = 19

ENT.VisionRange = 4000
ENT.IsFriendly = false

ENT.MDL = "models/servius/starwars/pm_bx_combined.mdl"
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"

ENT.FireRate = 0.2
ENT.MagazineSize = 30

ENT.WeaponSpread = Vector( 0.05, 0.05, 0.05 )
ENT.DroidTeam = "cis"

ENT.FireSound = "w/e5.wav"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "bx_droid", {
	Name = "BX Droid - Performance",
	Class = "bx_droid",
	Category = "Stoneman's Droids"
} )
