include("shared.lua")
include("cl_npc_animator.lua")

stoneman_droids_explosive = stoneman_droids_explosive or {}
stoneman_droids_sniper = stoneman_droids_sniper or {}

function ENT:Initialize()
    self.npc_weapon = ClientsideModel("models/weapons/w_pistol.mdl", RENDERGROUP_OPAQUE)

    local handpos = self:GetHandPosition()

    self.npc_weapon:SetPos(handpos)

    self.npc_weapon:SetAngles(self:GetAngles())
        
    self.npc_weapon:SetParent(self)

    if self.WeaponModel ~= "" then 
        self.npc_weapon:SetModel(tostring(self.WeaponModel)) 
    else
        self.npc_weapon:SetModel("models/weapons/w_pistol.mdl")
        //self.npc_weapon:SetNoDraw(true)
    end

    // Garbage collection
    self:CallOnRemove("DroidClientCleanup", function()
        if IsValid(self.npc_weapon) then
            self.npc_weapon:Remove()
        end
    end)

    if self.DroidType == "sniper" then
        self.CachedTablePos = table.insert(stoneman_droids_sniper, self)
    elseif self.DroidType == "explosive" then
        self.CachedTablePos = table.insert(stoneman_droids_explosive, self)
    end
end

function ENT:OnRemove()
    if self.CachedTablePos then
        if self.DroidType == "sniper" then
            stoneman_droids_sniper[ self.CachedTablePos ] = nil // Free up table spot/stop processing
        elseif self.DroidType == "explosive" then
            stoneman_droids_explosive[ self.CachedTablePos ] = nil // Free up table spot/stop processing
        end
    end

    self:ClientCleanup()
end
