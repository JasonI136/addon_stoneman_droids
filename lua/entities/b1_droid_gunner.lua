AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 125

ENT.DroidType = "gunner_performance"
ENT.WeaponDamage = 12

ENT.VisionRange = 5000
ENT.IsFriendly = false

ENT.MDL = "models/aussiwozzi/cgi/b1droids/b1_battledroid_heavy.mdl"
ENT.WeaponModel = "models/kraken/cgi/v_cgi_e5c.mdl"

ENT.FireRate = 3
ENT.MagazineSize = 50

ENT.WeaponSpread = Vector( 0.05, 0.01, 0 )
ENT.DroidTeam = "cis"

ENT.FireSound = "w/e5.wav"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b1_droid_gunner", {
	Name = "B1 Droid - Gunner",
	Class = "b1_droid_gunner",
	Category = "Stoneman's Droids"
} )
