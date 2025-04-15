////////////////////////////////////////
//
// Stoneman's NPCs: Targeting Module
//
////////////////////////////////////////

function ENT:RhinoCanSee( target )

	return self:Visible( target )
	-- local WSC = target:WorldSpaceCenter()
	-- local EYES = target:EyePos()
	-- local POS = target:GetPos()
	-- local result = {}

	-- local tracedata = {}
	-- tracedata.start = self:EyePos()
	-- tracedata.endpos = WSC
	-- tracedata.filter = { self, target }
	-- tracedata.mask = MASK_BLOCKLOS_AND_NPCS + CONTENTS_TEAM3
	-- tracedata.output = result

	-- util.TraceLine( tracedata )
	-- if !result.Hit or result.HitPos == tracedata.endpos then return true end

	-- tracedata.endpos = EYES
	-- util.TraceLine( tracedata )
	-- if !result.Hit or result.HitPos == tracedata.endpos then return true end

	-- -- tracedata.endpos = POS
	-- -- util.TraceLine( tracedata )
	-- -- if result.HitPos and result.HitPos == tracedata.endpos then return true end
	-- return false

end

function ENT:ValidTarget(target, skip)
	if !skip then // Micro-optimisation
		if (!IsValid(target) or !target:Alive() or target:IsFlagSet(FL_NOTARGET)) then return false end		
	end
	
	// Only check vision if its not set to 0
	if self.MaxVisionRange > 0 then
    	local droidPos = self:GetPos()
    	local targetPos = target:GetPos()
		if droidPos:DistToSqr(targetPos) > self.MaxVisionRange then return false end
	end
    return self:Visible( target )
end
// DISABLED THIS AS JUST LOOPING THROUGH PVS FOR EACH SHOULD BE FASTER
-- GG_DROID_TARGETS = GG_DROID_TARGETS or {}
-- GG_DROID_TARGETS_COUNT = GG_DROID_TARGETS_COUNT or {}
-- function GG_DROID_PrepareTargets()
-- 	GG_DROID_TARGETS = {}
-- 	GG_DROID_TARGETS_POS = {}
-- 	for _, ply in ipairs(player.GetAll()) do
-- 		if !IsValid(ply) or !ply:Alive() or ply:IsFlagSet(FL_NOTARGET) then continue end
-- 		table.insert(GG_DROID_TARGETS, ply)
-- 	end
-- 	GG_DROID_TARGETS_COUNT = #GG_DROID_TARGETS // Micro Optimisation - Fractionaly better to lookup a var instead of looking up the count of a table each time
-- end

function ENT:FindTarget()
	-- // GLOBAL SHARED LOGIC
	-- if (GG_DROID_TICK != engine.TickCount()) then
	-- 	GG_DROID_PrepareTargets() // This function creates a cached list of targets that are alive/valid/not notargeted
	-- 	GG_DROID_TICK = engine.TickCount() // Update to the new current tick
	-- end

	local rf = RecipientFilter()
	rf:AddPVS(self:GetPos()) // Add all players in the pvs of the droids position
	local targets = rf:GetPlayers() // Retrieve table of all players in the pvs
	local targetsnum = #targets // micro opti store as var since reused
	if targetsnum < 1 then self:SetDroidTarget(nil) return end
	local startIndex = math.random(1, targetsnum)

	for i = 1, targetsnum do
		local index = (startIndex + i - 1) % targetsnum + 1
		local ent = targets[index]
		if self:ValidTarget(ent) then
			self:SetDroidTarget(ent)
			break
		end
	end
end