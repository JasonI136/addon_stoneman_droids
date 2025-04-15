AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 800

ENT.DroidType = "explosive"
ENT.WeaponDamage = 1

ENT.VisionRange = 10000
ENT.IsFriendly = false

ENT.MDL = "models/b2_co/pm_droid_b2_co.mdl"
ENT.WeaponModel = ""

ENT.FireRate = 2
ENT.MagazineSize = 1

ENT.WeaponSpread = Vector( 0, 0, 0 )
ENT.DroidTeam = "cis"

ENT.FireSound = "w/e5.wav"

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b2_droid_explosive", {
	Name = "B2 Droid - Explosive",
	Class = "b2_droid_explosive",
	Category = "Stoneman's Droids"
} )