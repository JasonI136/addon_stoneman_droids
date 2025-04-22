AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 125

ENT.DroidType = "gunner_performance"
ENT.WeaponDamage = 10

ENT.VisionRange = 5000
ENT.IsFriendly = false

ENT.MDL = "models/aussiwozzi/cgi/b1droids/b1_battledroid_heavy.mdl"
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5c_blaster.mdl"

ENT.FireRate = 0.1
ENT.MagazineSize = 60

ENT.WeaponSpread = Vector( 0.1, 0.1, 0 )
ENT.DroidTeam = "cis"

ENT.FireSound = "kraken/cgi/e5/e5c.wav"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b1_droid_gunner", {
	Name = "B1 Droid - Gunner",
	Class = "b1_droid_gunner",
	Category = "Stoneman's Droids"
} )
