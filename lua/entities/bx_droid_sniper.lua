AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 210

ENT.DroidType = "sniper"
ENT.WeaponDamage = 90

ENT.VisionRange = 10000
ENT.IsFriendly = false

ENT.MDL = "models/servius/starwars/pm_bx_combined.mdl"
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5s_blaster.mdl"

ENT.FireRate = 4
ENT.MagazineSize = 30

ENT.WeaponSpread = Vector( 0, 0, 0 )
ENT.DroidTeam = "cis"

ENT.FireSound = "w/e5.wav"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "bx_droid_sniper", {
	Name = "BX Droid - Sniper",
	Class = "bx_droid_sniper",
	Category = "Stoneman's Droids"
} )
