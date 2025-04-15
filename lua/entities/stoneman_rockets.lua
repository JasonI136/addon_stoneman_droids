ENT.Type 				= "anim"  
ENT.PrintName			= "StarWars Reworked Rocket" 
ENT.Author				= "ChanceSphere574 & Stoneman (But mostly Chance.)"  
ENT.Spawnable			= false
ENT.AdminSpawnable		= false

local GlowBit 			= Material("particle/particle_glow_04_additive")

if SERVER then
	AddCSLuaFile( "stoneman_rockets.lua" )
	
	function ENT:Initialize()
		self:SetModel("models/hunter/plates/plate.mdl")
		--self:EmitSound("Missile.Accelerate", 75, 100)	
		self:EmitSound("w/rocket/rocket_mouv.wav", 75, 100)	
		self:SetNWBool("smoke", true)
		self:SetNWString("trackingmode", self.trackingmode or "")
		self:SetNWEntity("Owner", self.Owner)

		if self:GetNWString("trackingmode") == "point" then
			self:SetSkin(0)
		elseif self:GetNWString("trackingmode") == "track" then
			self:SetSkin(2)
		elseif self:GetNWString("trackingmode") == "control" then
			self:SetSkin(1)
		else
			self:SetSkin(4)
		end

		self.DieTime = CurTime() + 5

		self:PhysicsInit( SOLID_VPHYSICS ) 	
		self:SetSolid( SOLID_VPHYSICS ) 
		self:SetMoveType( MOVETYPE_VPHYSICS )

		local phys = self:GetPhysicsObject()
		phys:EnableGravity( false )
		phys:EnableDrag(false)
		phys:Wake()
	end

	function ENT:PhysicsCollide(data, physobj)
		// If the rocket hits an the owner, do no damage
		if data.HitEntity == self.DroidOwner then return end
		self:Remove()
	end

	function ENT:Explosion()

		local rocket_damage = 150
		local rocket_blast_damage = 50
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetPos())
		effectdata:SetEntity(self)
		effectdata:SetScale(2)
		effectdata:SetMagnitude(18)

		util.Effect( "rw_rocket_explosion", effectdata )
		util.Decal("Scorch", self:GetPos(), self:GetPos())

		// If the explosion hit an LFS vehicle, do extra damage
		// Find all entities within a radius of 175
		local entities = ents.FindInSphere( self:GetPos(), 175 )
		for _, ent in pairs( entities ) do
			if ent.LFS or ent.LVS then
				ent:SetHP( ent:GetHP() - rocket_damage )
			end

			if ent == self.DroidOwner then continue end
			
			if ent:IsPlayer() or ent:IsNextBot() then
				local dmginfo = DamageInfo()
				dmginfo:SetDamage( rocket_blast_damage )
				dmginfo:SetAttacker( self )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamageType( DMG_BLAST )
				ent:TakeDamageInfo( dmginfo )
			end
		end

		self:EmitSound("BaseExplosionEffect.Sound", 500, 100)
		--self:StopSound("Missile.Accelerate")
		self:StopSound("w/rocket/rocket_mouv.wav")
		local shake = ents.Create("env_shake")

		shake:SetPos(self:GetPos())
		shake:SetKeyValue("amplitude", "2000")
		shake:SetKeyValue("radius", "900")
		shake:SetKeyValue("duration", "2.5")
		shake:SetKeyValue("frequency", "1225")
		shake:SetKeyValue("spawnflags", "4")
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)

		local ar2Explo = ents.Create("env_fire")

		ar2Explo:SetPos(self:GetPos())
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire("Explode", "", 0)
	end
	
	function ENT:OnRemove()
		self:Explosion()
	end

	function ENT:Think()
		local phys = self:GetPhysicsObject()
		if not IsValid(phys) then return end
		local mode = self.trackingmode
		if mode == "point" then
			phys:SetVelocity(self:GetForward() * 3000)
			local ang = ( self.Owner:GetEyeTrace().HitPos-self:GetPos()):Angle()
			self:SetAngles( ang )
		elseif mode == "track" then
			if not IsValid(self.trackedent) then return end
			phys:SetVelocity(self:GetForward() * 3750)
			local ang = ( self.trackedent:GetPos() - self:GetPos()):Angle()
			self:SetAngles( ang )
		elseif mode == "control" then
			phys:SetVelocity(self:GetForward() * 5250)
			self:SetAngles(self.Owner:EyeAngles())
		else 
			phys:SetVelocity(self:GetForward() * 3000)
		end

		if self.DieTime <= CurTime() then
			self:Remove()
		end

		self:NextThink(CurTime())
		return true
	end
end

if CLIENT then
	function ENT:Draw()
		local CurGlowPos = (self:GetForward()*-10)+(self:GetUp()*1.5)
		self:DrawModel()
		local lColor
		if self:GetNWString("trackingmode") == "point" then
			lColor = Color(255, 20, 30)
		elseif self:GetNWString("trackingmode") == "track" then
			lColor = Color(100, 255, 30)
		elseif self:GetNWString("trackingmode") == "control" then
			lColor = Color(0, 100, 255)
		else
			lColor = Color(255, 100, 0)
		end
		render.SetMaterial(GlowBit)
		render.DrawSprite(self:GetPos()+CurGlowPos, 15, 15, lColor)
		render.SetMaterial(GlowBit)
		render.DrawSprite(self:GetPos()+CurGlowPos, 15, 15, lColor)
		render.SetMaterial(GlowBit)
		render.DrawSprite(self:GetPos()+CurGlowPos, 15, 15, lColor)
		render.SetMaterial(GlowBit)
		render.DrawSprite(self:GetPos()+CurGlowPos, 15, 15, lColor)
		render.SetMaterial(GlowBit)
		render.DrawSprite(self:GetPos()+CurGlowPos, 120, 15, lColor)
	end

	function ENT:Initialize()
		pos = self:GetPos()
		self.emitter = ParticleEmitter( pos )
	end
	 
	function ENT:Think()
		if (self:GetNWBool("smoke")) then
			pos = self:GetPos()
			for i=1, (5) do
				local particle = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + (self:GetForward() * 0 * i))

				if (particle) then
					particle:SetVelocity((self:GetForward() * -45)+(VectorRand()* 45) )
					particle:SetDieTime( math.Rand( 1.1, 1.9 ) )
					particle:SetStartAlpha( math.Rand( 15, 30 ) )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.Rand( 15, 15 ) )
					particle:SetEndSize( math.Rand( 0.01, 0.02 ) )
					particle:SetRoll( math.Rand(0, 360) )
					particle:SetRollDelta( math.Rand(-1, 1) )
					particle:SetColor( 85 , 85 , 85 ) 
					particle:SetAirResistance( 200 ) 
					particle:SetGravity( Vector( 0, 0, 0 ) ) 	
				end

			end
		end
	end

	function ENT:OnRemove()
		if self.Owner == LocalPlayer() and self:GetNWString("trackingmode") == "control" then
			hook.Remove("CalcView", "Joe_CalcView")
		end
	end
	
end
