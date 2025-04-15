////////////////////////////////////////
//
// Stoneman's NPCs: Targeting Module
//
////////////////////////////////////////

function ENT:Think()
    if not IsValid(self) then return end

    local target = self:GetDroidTarget()
    if IsValid(target) then
        local target_pos = target:GetPos()
        if isvector(target_pos) then
            local target_angle = (target_pos - self:GetPos()):Angle()
            self:SetAngles(Angle(0, target_angle.yaw, 0))
        end
    end

    if self:Health() <= 0 then
        if not IsValid(self.npc_weapon) then return end
        self.npc_weapon:SetNoDraw(true)
    end
end

function ENT:Draw()
    self:DrawModel()

    if not IsValid(self.npc_weapon) then return end
    if self.npc_weapon:GetModel() == "models/weapons/w_pistol.mdl" then return end

    // If the droid is too far away, don't draw the weapon. Use DistToSqr
    if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 1500000 then
        self.npc_weapon:SetNoDraw(true)
    else
        self.npc_weapon:SetNoDraw(false)
    end
end

local function RenderSniper(ent)
    local target = ent:GetDroidTarget()

    local target_pos = ent:GetHeadPosition() + ent:GetAngles():Forward() * 100
    // Draw a laser
    local dir = (target_pos - ent:GetPos()):GetNormalized()

    // If we are dead, don't draw the laser
    if ent:Health() <= 0 then return end
    
    if target ~= nil and target:IsValid() then
        local distance = ent:GetPos():Distance(target:GetPos())
        local trace = util.QuickTrace(ent:GetHandPosition(), dir * distance, ent)
        // Search for the target's head bone
        local bone = target:LookupBone("ValveBiped.Bip01_Head1")
        local bonepos = target:GetBonePosition(bone)

        render.DrawBeam(ent:GetHandPosition(), bonepos, 1, 0, 0, Color(255, 0, 0, 50))
    end
end

local function RenderExplosives(ent)
    if ent:GetAimingPosition() ~= Vector(0,0,0) then
        local target = ent:GetDroidTarget()
        // If you are in a vehicle, don't
        local pos = ent:GetAimingPosition()
        local entpos = ent:GetHandPosition()
        local ang = (pos - entpos):Angle()
        local dist = entpos:Distance(pos)

        if ent:Health() <= 0 then return end
    
        if LocalPlayer():InVehicle() then return end
        render.DrawSphere(pos, 175, 64, 64, Color(255, 0, 0, 25))
        render.DrawBeam(entpos, pos, 1, 0, dist/100, Color(255, 0, 0, 175))
        for i = 1, 64 do
            local circle1 = pos + Vector(math.sin( ( i / 64 ) * math.pi *2 ) * 175, math.cos( ( i / 64 ) * math.pi * 2) * 175 ,0)
            local circle2 = pos + Vector(math.sin( ( ( i + 1 ) / 64 ) * math.pi * 2) * 175, math.cos( ( ( i + 1 ) / 64 ) * math.pi * 2) * 175 ,0)
            render.DrawBeam(circle1, circle2, 1, 0, 1, Color(255,0,0,100))
        end

        // Position of the text is right above the aiming pos!
        local pos = pos + Vector(0,0,75)
        local view = LocalPlayer():GetAngles()
        local ang = Angle(0, view.y-90, 90-view.p)
        cam.Start3D2D(pos, ang, 1)
            surface.SetTextColor(255, 0, 0, 255)
            surface.SetTextPos(0, 0)
            surface.SetFont("DermaLarge")
            surface.DrawText("!")
        cam.End3D2D()
    end
end
stoneman_droids_explosive = stoneman_droids_explosive or {}
stoneman_droids_sniper = stoneman_droids_sniper or {}
hook.Add("PostDrawTranslucentRenderables", "StonemanDroids_Renderer", function()
    for i, droid in pairs( stoneman_droids_explosive ) do
        RenderExplosives(droid)
    end
    for i, droid in pairs( stoneman_droids_sniper ) do
        RenderSniper(droid)
    end
end)

function ENT:ClientCleanup()
    if IsValid(self.npc_weapon) then
        self.npc_weapon:Remove()
    end
end
