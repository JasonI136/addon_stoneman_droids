////////////////////////////////////////
//
// Stoneman's NPCs: Weapon Module
//
////////////////////////////////////////
ENT.LastShotTime = 0
function ENT:ShootTarget()
    local target = self:GetDroidTarget()
    if self.DroidType == "sniper" then
        self:ShootSniper(target)
    elseif self.DroidType == "explosive" then
        self:ShootExplosive(target)
    else
        self:ShootLaser(target)
    end
end

function ENT:ReloadWeapon()
    self.ShouldFire = false

    self.ShotsFired = 0

    self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_SMG1 )

    timer.Simple( 2.5, function()
        if self:IsValid() then
            self.ShouldFire = true
        end
    end )
end

local function UpdatePosition(ply)
    // Cache position so we dont have to do vehicle checks etc if multiple droids are targeting same person
    if ply:InVehicle() then
        GG_DROID_TARGETS_POS[ply] = ply:GetVehicle():GetPos() // Position of vehicle
    else
        GG_DROID_TARGETS_POS[ply] = ply:LocalToWorld(ply:OBBCenter()) // Center of player
    end
    return GG_DROID_TARGETS_POS[ply]
end

function ENT:ShootLaser( target )
    if self.ShotsFired >= self.MagazineSize then
        self:ReloadWeapon()
        return
    end
    
    // Cache the results of our position checks so any other droid targetting the same person in this tick is faster
    // First part is just making sure old positions have been invalidated, second part uses caching if the position hasnt be evaluated this tick
    local target_pos = (GG_DROID_TICK == engine.TickCount()) and GG_DROID_TARGETS_POS[target] or UpdatePosition(target)

    local dir = (target_pos - self:GetHeadPosition()):GetNormalized()

    local bullet = {}
    bullet.Num = self.NumShots or 1
    bullet.Src = self:GetHeadPosition()
    bullet.Dir = dir
    bullet.Spread = self.WeaponSpread or Vector( 0.08, 0.08, 0 )
    bullet.Tracer = 1
    bullet.TracerName = self.WeaponTracer or "rw_sw_laser_red"
    bullet.Force = 0
    bullet.Damage = self.WeaponDamage
    bullet.AmmoType = "ar2"
    bullet.Callback = function(attacker, tr, dmginfo)
        if not tr.Entity:IsValid() then return end

        if not tr.Entity.IsStonemanDroids then return end

        if not attacker.IsStonemanDroids then return end

        if not tr.Entity.IsFriendly and not attacker.IsFriendly then
            dmginfo:SetDamage(0)
        end

    end

    self:EmitSound( self.FireSound or "w/e5.wav" )

    self:FireBullets( bullet )

    self.ShotsFired = self.ShotsFired + 1
end

////////////////////////////////////////
//
// Stoneman's NPCs: Snipers!
//
////////////////////////////////////////

function ENT:ShootSniper( target )
    if self.ShotsFired >= self.MagazineSize then
        self:ReloadWeapon()
        return
    end

    // Cache the results of our position checks so any other droid targetting the same person in this tick is faster
    // First part is just making sure old positions have been invalidated, second part uses caching if the position hasnt be evaluated this tick
    local target_pos = (GG_DROID_TICK == engine.TickCount()) and GG_DROID_TARGETS_POS[target] or UpdatePosition(target)

    local dir = (target_pos - self:GetHeadPosition()):GetNormalized()

    local bullet = {}
    bullet.Num = 1
    bullet.Src = self:GetHeadPosition()
    bullet.Dir = dir
    bullet.Spread = self.WeaponSpread or Vector( 0.08, 0.08, 0 )
    bullet.Tracer = 1
    bullet.TracerName = self.WeaponTracer or "rw_sw_laser_red"
    bullet.Force = 0
    bullet.Damage = self.WeaponDamage
    bullet.AmmoType = "ar2"
    bullet.Callback = function(attacker, tr, dmginfo)
        if not tr.Entity:IsValid() then return end

        if not tr.Entity.IsStonemanDroids then return end
        
        if not tr.Entity.IsFriendly and not attacker.IsFriendly then
            dmginfo:SetDamage(0)
        end

    end

    
    // Why timers???
    timer.Simple( self.FireDelay or 0.25, function()
        if self:IsValid() then
            self:EmitSound( self.FireSound or "w/e5.wav" )
            self:FireBullets( bullet )
        end
    end )

    self.ShotsFired = self.ShotsFired + 1
end

////////////////////////////////////////
//
// Stoneman's NPCs: Explosive
//
////////////////////////////////////////

function ENT:ShootExplosive( target )
    if self.ShotsFired >= self.MagazineSize then
        self:ReloadWeapon()
        return
    end

    // Cache the results of our position checks so any other droid targetting the same person in this tick is faster
    // First part is just making sure old positions have been invalidated, second part uses caching if the position hasnt be evaluated this tick
    local target_pos = (GG_DROID_TICK == engine.TickCount()) and GG_DROID_TARGETS_POS[target] or UpdatePosition(target)

    self:SetAimingPosition( target_pos )
    // Why timers???
    timer.Simple( self.FireRate, function() 
        if not self:IsValid() or self:Health() <= 0 then return end

        if self:GetAimingPosition() == Vector(0, 0, 0) then return end

        self.ShotsFired = self.ShotsFired + 1

        local rocket = ents.Create("stoneman_rockets")
        rocket:SetPos(self:GetHandPosition())
        rocket:SetAngles((self:GetAimingPosition() - self:GetHandPosition()):Angle())
        rocket.DroidOwner = self
        rocket:Spawn()
        rocket:Activate()
        
        if IsValid(target) and target:IsPlayer() then
            if target:InVehicle() then
                rocket.trackingmode = "track"
                rocket.trackedent = target:GetVehicle()
                // Only tracks for four seconds.
                timer.Simple(3, function()
                    if rocket:IsValid() then
                        rocket.trackedent = nil
                    end
                end)
            end
        end

        self:SetAimingPosition( Vector(0, 0, 0) )
    end)
end

function ENT:ShootShotgun(target)

                    end
