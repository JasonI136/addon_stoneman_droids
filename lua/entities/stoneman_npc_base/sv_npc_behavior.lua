////////////////////////////////////////
//
// Stoneman's NPCs: Nextbot Behavior Module
//
////////////////////////////////////////

function ENT:RunBehaviour()
	coroutine.yield() // In case this gets called just stop the coroutine
end

function ENT:BehaveStart()
	self:StartSpecial()
	return // NOT USING COROUTINES AS THEY CANNOT BE PROFILED
end

function ENT:BehaveUpdate( fInterval )
	return // NOT USING COROUTINES AS THEY CANNOT BE PROFILED
end

ENT.LastFindTarget = 0
ENT.FindTargetInterval = 0.6
GG_DROID_TICK = GG_DROID_TICK or 0 // Global shared by all bots
GG_DROID_TARGETS = GG_DROID_TARGETS or {}
GG_DROID_TARGETS_POS = GG_DROID_TARGETS_POS or {}
function ENT:Think()
	if (GG_DROID_TICK != engine.TickCount()) then
		GG_DROID_TARGETS_POS = {} // Reset cached position list for shooting.
		GG_DROID_TICK = engine.TickCount() // Update to the new current tick
	end
	
	// TARGET AQUISITION LOGIC
	if (self.LastFindTarget + self.FindTargetInterval <= CurTime()) then 
		self.LastFindTarget = CurTime()
		// Check if existing target is valid and find new one if it is not
		local vt = self:ValidTarget(self:GetDroidTarget())
		if (!vt) then
			self:SetDroidTarget(nil)
			self:FindTarget()
		end
	end
	
	// FIRING LOGIC
	if (IsValid(self:GetDroidTarget()) and self.ShouldFire and self.LastShotTime + self.FireRate <= CurTime()) then
		self:ShootTarget() // Run the shooting logic
		self.LastShotTime = CurTime()
	end

	// Any Other Logic
	self:SpecialThink()
end

function ENT:DroidAnimations()
	if self.IsJetpack then
		return ACT_HL2MP_SWIM_IDLE_SMG1
	else
		return ACT_HL2MP_IDLE_SMG1
	end
end

function ENT:PlaySequence( name, speed )
	local len = self:SetSequence( self:LookupSequence( name ) )

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed or 1 )
end

function ENT:ChaseTarget( options )
	local options = options or {}
	options.tolerance = options.tolerance or 100
	
	if self:GetRangeTo( self:GetDroidTarget() ) <= options.tolerance then return "ok" end

	local walkanim = ACT_HL2MP_WALK_SMG1
	local runanim = ACT_HL2MP_RUN_SMG1

	local path = Path( "Chase" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance )
	
	-- sometimes the inital computed path is a little weird.
	-- calling "chase" before "compute" seemed to help, but only a little...?
	path:Chase( self, self:GetDroidTarget() )
	path:Compute( self, self:GetDroidTarget():GetPos() )
	
	if ( !path:IsValid() ) then return "failed" end
	
	-- set the initial animation and speed.
	local len = path:GetLength()
	if len > 375 then
		self:PushActivity( runanim )
		self.loco:SetDesiredSpeed( 200 )
	else
		self:PushActivity( walkanim )
		self.loco:SetDesiredSpeed( 75 )
	end
	
	while ( path:IsValid() and self:GetDroidTarget() ) do
		if not timer.Exists( "StonemanDroid_ShootLaserEntity"..self:EntIndex()) then
			coroutine.yield()
			return "ok"
		end
		local cur_act = self.activity_stack:Top()

		if ( path:GetAge() > 0.333 ) then
			path:Compute( self, self:GetDroidTarget():GetPos() )

			-- update the animation and speed as needed.
			local len = path:GetLength()
			
			if cur_act == walkanim then
				if len > 500 then
					self:PopActivity()
					self:PushActivity( runanim )
					self.loco:SetDesiredSpeed( 200 )
					cur_act = runanim
				end
			elseif cur_act == runanim then
				if len < 250 then
					self:PopActivity()
					self:PushActivity( walkanim )
					self.loco:SetDesiredSpeed( 75 )
					cur_act = walkanim
				end
			end
		end
		
		-- only move when the animation is a movement type.
		if cur_act == walkanim or cur_act == runanim then
			path:Chase( self, self:GetDroidTarget() )
		end

		if ( options.draw ) then path:Draw() end
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			self:PopActivity()
			return "stuck"
		end

		coroutine.yield()
	end
	
	self:PopActivity()
	return "ok"
end

function ENT:OnInjured( dmginfo )
end

function ENT:KnockDownNPC()
	local prev_seq = self:GetSequence()
	self:DisableAttack()
	self:PlaySequence("zombie_slump_idle_02")
	timer.Simple(1, function()
		if self:IsValid() then
			// Play zombie get up animation
			self:PlaySequence("zombie_slump_rise_02_fast")
		end
	end)

	// Return to normal
	timer.Simple(2, function()
		if self:IsValid() then
			self:StartActivity(ACT_HL2MP_IDLE_SMG1)
			self:EnableAttack()
		end
	end)
end

function ENT:PushActivity( act, duration )
	self:StartActivity( act )
	self.activity_stack:Push( act )
	if not duration then
		self.activity_end_stack:Push( -1 )
	else
		self.activity_end_stack:Push( CurTime() + duration )
	end
end

function ENT:PopActivity()
	if self.activity_stack:Size() > 0 then
		self.activity_stack:Pop()
		self.activity_end_stack:Pop()

		if isValid(self.Anim) or self.Anim == "" then
			self:StartActivity( ACT_HL2MP_IDLE_SMG1 )
		else
			self:StartActivity(self.Anim)
		end
	end
end

///////////////////////////////////////////////////////
// Special Droid Behavior!
///////////////////////////////////////////////////////

function ENT:StartSpecial()
	if self.IsJetpack then
		self:ActivateJetpack()
	end
end

function ENT:NPCBehaviorThink()
end

function ENT:SpecialThink()
	// Now we do flyingself.StonemanDroidData.Type behavior!
	if self.IsJetpack then
		// Only set velocity when we're up to the end.
		local bob = math.sin( CurTime() * 2 ) * 25
		local bob2 = math.cos( CurTime() * 2 ) * 25
		local bob3 = bob + bob2

		if self.StonemanFinishedFly then
			self.loco:SetVelocity( Vector( bob, bob2, bob3) )
		else
			self.loco:SetVelocity( Vector( bob, bob2, 200) )
		end
		self.loco:SetGravity(0)
	end
end

function ENT:ActivateJetpack()
	self:SetPos(self:GetPos() + Vector(0,0,30))

	timer.Simple(3, function()
		self.StonemanFinishedFly = true
	end)
end
