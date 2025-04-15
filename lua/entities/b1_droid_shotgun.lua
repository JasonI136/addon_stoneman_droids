AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 125

ENT.DroidType = "gunner_shotgun"
ENT.WeaponDamage = 10

ENT.VisionRange = 1024
ENT.IsFriendly = false

ENT.MDL = "models/b1_marine_co/pm_droid_b1_marine_co.mdl"
ENT.WeaponModel = "models/swbf3/weapons/cisshotgun.mdl"

ENT.FireRate = 0.8
ENT.MagazineSize = 30

ENT.NumShots = 8
ENT.WeaponSpread = Vector( 0.05, 0.05, 0 )
ENT.DroidTeam = "cis"

ENT.FireSound = "w/e5.wav"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b1_droid_shotgun", {
	Name = "B1 Droid - Shotgun",
	Class = "b1_droid_shotgun",
	Category = "Stoneman's Droids"
} )
