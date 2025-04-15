AddCSLuaFile()
ENT.Base 			= "stoneman_npc_base"
ENT.Spawnable		= true

ENT.IsStonemanDroids = true

ENT.MaxHP = 125

ENT.DroidType = "flying"
ENT.WeaponDamage = 19

ENT.VisionRange = 6000
ENT.IsFriendly = false

ENT.MDL = "models/eng_lt/pm_droid_b1_eng_lt.mdl"
ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"

ENT.FireRate = 0.5
ENT.MagazineSize = 30

ENT.WeaponSpread = Vector( 0.05, 0.05, 0.05 )
ENT.DroidTeam = "cis"

ENT.IsJetpack = true
ENT.FireSound = "w/e5.wav"

-- ENT.BodygroupData = "backpack"
-- ENT.BodygroupID = 3

function ENT:SetupDataTables()
	self:BaseDataTBL()
end

list.Set( "NPC", "b1_droid_jetpack", {
	Name = "B1 Droid - Jetpack",
	Class = "b1_droid_jetpack",
	Category = "Stoneman's Droids"
} )
