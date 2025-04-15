if SERVER then
    util.AddNetworkString("StonemanDroidBase:Setup")
    util.AddNetworkString("StonemanDroidBase:SetupAll")
    util.AddNetworkString("StonemanDroidBase:Spawned")
    util.AddNetworkString("StonemanDroidBase:GetSetup")
else
    StonemanDroidBaseMenu = {}
end

concommand.Add("stoneman_droids_gettable", function(ply, cmd, args)
    PrintTable(StonemanDroidBase)
end)

if CLIENT then
    // Make all client convars.
    CreateClientConVar("stoneman_droids_name", "Custom Droid", true, false)
    CreateClientConVar("stoneman_droids_unique_code", "stoneman_custom_droid", true, false)
    CreateClientConVar("stoneman_droids_type", "gunner_performance", true, false)
    CreateClientConVar("stoneman_droids_weapon", "models/weapons/gateway/e5_blaster.mdl")
    CreateClientConVar("stoneman_droids_model", "models/jazzmcfly/jka/younglings/jka_young_female.mdl", true, false)
    CreateClientConVar("stoneman_droids_hp", 125, true, false)
    CreateClientConVar("stoneman_droids_range", 6000, true, false)
    CreateClientConVar("stoneman_droids_damage", 19, true, false)
    CreateClientConVar("stoneman_droids_firerate", 0.176, true, false)
    CreateClientConVar("stoneman_droids_targeting", 0, true, false)
    CreateClientConVar("stoneman_droids_maxshots", 30, true, false)
    CreateClientConVar("stoneman_droids_isjetpack", 0, true, false)
    CreateClientConVar("stoneman_droids_spread", 0.08, true, false)
    CreateClientConVar("stoneman_droids_tracer", "rw_sw_laser_red", true, false)
end

local function SpawnMenu( panel )
    // Add controls to the panel
    panel:ClearControls()
    panel:Help( "Configure Custom Droids" )
    local dropdown = panel:ComboBox( "Select a Droid", "stoneman_droids_type" )
    dropdown:AddChoice( "Gunner Performance", "gunner_performance" )
    dropdown:AddChoice( "Explosive", "explosive" )
    dropdown:AddChoice( "Sniper", "sniper" )

    // Name!
    local name = panel:TextEntry( "Name", "stoneman_droids_name" )

    // Codename!
    panel:Help("Both the name and codename must be unique! And for the codename, you can only use letters, numbers, and underscores. LOWERCASE! (No spaces)")
    local codename = panel:TextEntry( "Unique Code", "stoneman_droids_unique_code" )

    // Model setter!
    local model = panel:TextEntry( "Model", "stoneman_droids_model" )
    panel:ControlHelp("Note: Playermodels only!")

    // Weapon setter!
    local weapon = panel:TextEntry( "Weapon", "stoneman_droids_weapon" )
    panel:ControlHelp("Note: This is the model of the weapon, not the class of the weapon.")

    // Tracer
    local tracer = panel:TextEntry( "Tracer", "stoneman_droids_tracer" )
    panel:ControlHelp("Default: rw_sw_laser_red")

    // Set HP
    local hp = panel:NumSlider( "Health", "stoneman_droids_hp", 1, 1000000, 0 )

    // Set Range
    local range = panel:NumSlider( "Range", "stoneman_droids_range", 1, 30000, 0 )
    panel:ControlHelp("Default: 6000")

    // Set Damage
    local damage = panel:NumSlider( "Damage", "stoneman_droids_damage", 1, 1000000, 0 )
    panel:ControlHelp("Default: 19")

    // Set Fire Rate
    local firerate = panel:NumSlider( "Fire Rate", "stoneman_droids_firerate", 0.01, 10, 2 )
    panel:ControlHelp("Default: 0.17")

    // Set max shots
    local maxshots = panel:NumSlider( "Max Shots", "stoneman_droids_maxshots", 1, 1000000, 0 )
    panel:ControlHelp("Default: 30")

    // Set Spread
    local spread = panel:NumSlider( "Spread", "stoneman_droids_spread", 0, 100, 2 )
    panel:ControlHelp("Default: 0.08")

    // Help
    panel:Help("Overrides the droid's targeting system, so they will target other droids.")
    // Set Targeting
    local targeting = panel:CheckBox( "Target Droids", "stoneman_droids_targeting" )

    // Is Jetpack
    panel:Help("Make them fly up in the air.")
    local isjetpack = panel:CheckBox( "Use Jetpack", "stoneman_droids_isjetpack" )

    local function DefaultValues()
        // Set default values for all the controls
        name:SetValue( "Custom Droid" )
        codename:SetValue( "stoneman_custom_droid" )
        model:SetValue( "models/jazzmcfly/jka/younglings/jka_young_female.mdl" )
        hp:SetValue( 125 )
        range:SetValue( 6000 )
        damage:SetValue( 19 )
        firerate:SetValue( 0.176 )
        maxshots:SetValue( 30 )
        weapon:SetValue( "models/weapons/gateway/e5_blaster.mdl" )
        tracer:SetValue( "rw_sw_laser_red" )
        targeting:SetValue( 0 )
        isjetpack:SetValue( 0 )
        spread:SetValue( 0.08 )
    end

    DefaultValues()

    // Reset button
    local reset = panel:Button( "Reset to default" )
    reset.DoClick = function()
        DefaultValues()

        // Reset all the convars
        RunConsoleCommand("stoneman_droids_name", "Custom Droid")
        RunConsoleCommand("stoneman_droids_unique_code", "stoneman_custom_droid")
        RunConsoleCommand("stoneman_droids_type", "gunner_performance")
        RunConsoleCommand("stoneman_droids_weapon", "models/weapons/gateway/e5_blaster.mdl")
        RunConsoleCommand("stoneman_droids_model", "models/jazzmcfly/jka/younglings/jka_young_female.mdl", true, false)
        RunConsoleCommand("stoneman_droids_hp", 125)
        RunConsoleCommand("stoneman_droids_range", 6000)
        RunConsoleCommand("stoneman_droids_damage", 19)
        RunConsoleCommand("stoneman_droids_firerate", 0.176)
        RunConsoleCommand("stoneman_droids_targeting", 0)
        RunConsoleCommand("stoneman_droids_maxshots", 30)
        RunConsoleCommand("stoneman_droids_isjetpack", 0)
        RunConsoleCommand("stoneman_droids_spread", 0.08)
        RunConsoleCommand("stoneman_droids_tracer", "rw_sw_laser_red")
    end

    // Add a button to save the droid
    local save = panel:Button( "Save Droid" )

    // Helper, saying a warning:
    panel:Help("WARNING: This will overwrite any droids with the same unique code!")
    panel:Help("If you press this button, it will cause a reload of the spawnmenu.")
    // When the button is pressed
    save.DoClick = function()
        // Make a table of all the data

        // Make codename lowercase
        local codename = string.lower(codename:GetValue())
        local class = string.lower(tostring(LocalPlayer():GetInfo("stoneman_droids_unique_code")))

        local tbl = {
            Name = tostring(LocalPlayer():GetInfo("stoneman_droids_name")),
            Class = class,
            Type = tostring(LocalPlayer():GetInfo("stoneman_droids_type")),
            Weapon = tostring(LocalPlayer():GetInfo("stoneman_droids_weapon")),
            Model = tostring(LocalPlayer():GetInfo("stoneman_droids_model")),
            HP = tonumber(LocalPlayer():GetInfo("stoneman_droids_hp")),
            Range = tonumber(LocalPlayer():GetInfo("stoneman_droids_range")),
            Damage = tonumber(LocalPlayer():GetInfo("stoneman_droids_damage")),
            FireRate = tonumber(LocalPlayer():GetInfo("stoneman_droids_firerate")),
            Targeting = tobool(LocalPlayer():GetInfo("stoneman_droids_targeting")),
            MaxShots = tonumber(LocalPlayer():GetInfo("stoneman_droids_maxshots")),
            IsJetpack = tobool(LocalPlayer():GetInfo("stoneman_droids_isjetpack")),
            Spread = tonumber(LocalPlayer():GetInfo("stoneman_droids_spread")),
            Tracer = tostring(LocalPlayer():GetInfo("stoneman_droids_tracer"))
        }

        // Send the data to the server
        net.Start("StonemanDroidBase:Setup")
            net.WriteTable( tbl )
        net.SendToServer()

        if not file.Exists("stoneman_droids", "DATA") then
            file.CreateDir("stoneman_droids")
        end

        // Add droid to player's data folder
        file.Write("stoneman_droids/" .. tbl.Class .. ".txt", util.TableToJSON(tbl))

        droid_list = {}
		SpawnMenu(panel)

        // Repopulate the list
        timer.Simple(0.1, function()
            StonemanDroidBaseMenu:DoPopulate(StonemanDroidBaseMenu)
            StonemanDroidBaseMenu:DoClick(StonemanDroidBaseMenu)
        end)
    end

    // Make a huge panel with list of all droids in the player's data folder
	local fileexplorer = vgui.Create("DListView")
	fileexplorer:SetSize(200, 300)
	fileexplorer:SetMultiSelect(false)
	fileexplorer:AddColumn("Currently existing droids!")
	if selected_line ~= nil then
		fileexplorer:SelectItem(selected_line)
	end

    local files = file.Find( "stoneman_droids/*.txt", "DATA" )
	local droid_list = {}
    // Add all file names into a table
	for k, v in pairs(files) do
		table.insert(droid_list, v)
	end
	// Populate the list with the file names
	for k, v in pairs(droid_list) do
		fileexplorer:AddLine(v)
	end
    panel:AddItem(fileexplorer)

    // If you right click, opens derma with option to delete the droid
    fileexplorer.OnRowSelected = function(__, rowindex, row)
        local menu = DermaMenu()
        menu:AddOption("Load", function()
            local tbl = util.JSONToTable(file.Read("stoneman_droids/" .. row:GetValue(1), "DATA"))
            if not istable(tbl) then MsgC(Color(255, 0, 0), "Error: Could not load droid data! File might be corrupted!\n") return end
            name:SetValue(tbl.Name)
            codename:SetValue(tbl.Class)
            model:SetValue(tbl.Model)
            weapon:SetValue(tbl.Weapon)
            hp:SetValue(tbl.HP)
            range:SetValue(tbl.Range)
            damage:SetValue(tbl.Damage)
            firerate:SetValue(tbl.FireRate)
            targeting:SetValue(tbl.Targeting)
            maxshots:SetValue(tbl.MaxShots)
            isjetpack:SetValue(tbl.IsJetpack)
            spread:SetValue(tbl.Spread)
            tracer:SetValue(tbl.Tracer)

            RunConsoleCommand("stoneman_droids_name", tbl.Name)
            RunConsoleCommand("stoneman_droids_unique_code", tbl.Class)
            RunConsoleCommand("stoneman_droids_type", tbl.Type)
            RunConsoleCommand("stoneman_droids_weapon", tbl.Weapon)
            RunConsoleCommand("stoneman_droids_model", tbl.Model)
            RunConsoleCommand("stoneman_droids_hp", tbl.HP)
            RunConsoleCommand("stoneman_droids_range", tbl.Range)
            RunConsoleCommand("stoneman_droids_damage", tbl.Damage)
            RunConsoleCommand("stoneman_droids_firerate", tbl.FireRate)
            RunConsoleCommand("stoneman_droids_targeting", tbl.Targeting)
            RunConsoleCommand("stoneman_droids_maxshots", tbl.MaxShots)
            RunConsoleCommand("stoneman_droids_isjetpack", tbl.IsJetpack)
            RunConsoleCommand("stoneman_droids_spread", tbl.Spread)
            RunConsoleCommand("stoneman_droids_tracer", tbl.Tracer)
        end)
        menu:AddOption("Delete", function()
            file.Delete("stoneman_droids/" .. row:GetValue(1))
            droid_list = {}
            SpawnMenu(panel)
        end)
        menu:Open()
    end

    // Reset / Refresh button!
	local button = vgui.Create("DButton")
	button:SetText("Empty / Refresh")
	button:SetSize(200, 30)
	button.DoClick = function()
		droid_list = {}
		SpawnMenu(panel)
        // Repopulate the list
        timer.Simple(0.1, function()
            StonemanDroidBaseMenu:DoPopulate(StonemanDroidBaseMenu)
            StonemanDroidBaseMenu:DoClick(StonemanDroidBaseMenu)
        end)
	end
    panel:AddItem(button)
end

hook.Add( "PopulateNPCs", "StonemanDroid:Populator", function( pnlContent, tree, node )
    // This is copied over from the base gamemode, but with the custom droids added. 
    StonemanDroidBaseMenu = tree:AddNode( "Stoneman's Droids - Custom", "icon16/brick.png" )

    -- When we click on the node - populate it using this function
    StonemanDroidBaseMenu.DoPopulate = function( self )
        -- If we've already populated it - remove it all and it again.
        if ( self.PropPanel ) then
            self.PropPanel:Clear()
            self.PropPanel = nil
        end

        -- Create the container panel
        self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
        self.PropPanel:SetVisible( false )
        self.PropPanel:SetTriggerSpawnlistChange( false )

        // Add the droids from the player's data folder
        local files, folders = file.Find("stoneman_droids/*.txt", "DATA")
        for k, v in pairs(files) do
            local tbl = util.JSONToTable(file.Read("stoneman_droids/" .. v, "DATA"))
            // Check if the file is a valid json
            if not istable(tbl) then continue end
            local icon = spawnmenu.CreateContentIcon("npc", self.PropPanel, {
                nicename = tbl.Name,
                spawnname = tbl.Class,
                material = "entities/npc.png",
            })

            icon.DoClick = function()
                surface.PlaySound( "ui/buttonclickrelease.wav" )

                if not StonemanDroidBase[tbl.Class] then
                    net.Start("StonemanDroidBase:Setup")
                        net.WriteTable(tbl)
                    net.SendToServer()
                end

                RunConsoleCommand( "gmod_spawnnpc", tbl.Class, "" )
            end

            icon.OpenMenu = function()
                local menu = DermaMenu()
                menu:AddOption( "Copy to Clipboard", function() SetClipboardText( tbl.Class ) end ):SetImage( "icon16/page_copy.png" )
                // See if we have EGS installed
                if GetConVar("egs_spawnmenu_incompatible") ~= nil then
                    menu:AddOption( "Spawn Group using EGS", function() RunConsoleCommand( "gmod_tool", "egs" ) RunConsoleCommand( "egs_spawnmenu_incompatible", "0" )  RunConsoleCommand( "egs_ent_type", "2" ) RunConsoleCommand( "egs_ent_name", tbl.Class ) end ):SetImage( "icon16/egs.png" )
                end
                menu:AddOption( "Spawn Using Toolgun", function()
                    if not StonemanDroidBase[tbl.Class] then
                        net.Start("StonemanDroidBase:Setup")
                            net.WriteTable(tbl)
                        net.SendToServer()
                    end
                    
                    RunConsoleCommand( "gmod_tool", "creator" )
                    RunConsoleCommand( "creator_type", "2" )
                    RunConsoleCommand( "creator_name", tbl.Class ) 
                end ):SetImage( "icon16/wand.png" )
                menu:Open()
            end
        end
    end
    
    StonemanDroidBaseMenu.DoClick = function( self )
        self:DoPopulate()
        pnlContent:SwitchPanel( self.PropPanel )
    end
end )

local function SetupNewDroid( name, data )
    local ENT = {}
    ENT.Base 			= "stoneman_npc_base"
    ENT.PrintName         = data.Name
    ENT.Spawnable		= true

    ENT.IsStonemanDroids = true

    ENT.MaxHP = data.HP

    ENT.DroidType = data.Type
    ENT.WeaponDamage = data.Damage

    ENT.VisionRange = data.Range
    ENT.IsFriendly = data.Targeting

    ENT.MDL = data.Model
    ENT.WeaponModel = data.Weapon

    ENT.FireRate = data.FireRate
    ENT.MagazineSize = data.MaxShots

    ENT.IsJetpack = data.IsJetpack
    ENT.WeaponSpread = Vector( data.Spread, data.Spread, data.Spread )

    ENT.WeaponTracer = data.Tracer

    ENT.DroidTeam = "cis"

    ENT.FireSound = "w/e5.wav"

    scripted_ents.Register( ENT, name )

    function ENT:SetupDataTables()
        self:BaseDataTBL()
    end

    list.Set( "NPC", name, {
        Name = data.Name,
        Class = name,
        Category = "Stoneman's Droids - Custom (Server)",
    } )
end

local function InitStonemanDroids()
    StonemanDroidBase = StonemanDroidBase or {}
    StonemanDroidBase.Droids = {}

    // Grab currently setup droids from the server
    net.Start("StonemanDroidBase:GetSetup")
    net.SendToServer()
end

local DisallowedUserGroup = {
    user = true,
    donator = true,
    trialmoderator = true
}

local AllowedHeadStaff = {
    headeventstaff = true,
    senioreventstaff = true,
    eventstaff = true,
    junioreventstaff = true,
    advisor = true,
    headadmin = true,
    chiefadvisor = true,
    juniormanager = true,
    servermanager = true,
    seniordeveloper = true,
    communityadvisor = true,
    communitymanager = true,
    coowner = true,
    superadmin = true,
    headdeveloper = true,
    communitydeveloper = true,
    developer = true
}

local AllowedPlayers = {
    "STEAM_0:0:89659362", --Stoneman
}

if SERVER then
    net.Receive("StonemanDroidBase:Setup", function(len, ply)
        local tbl = net.ReadTable()
        if not tbl then return end

        // Just block all non admins from exploiting
        if not ply:IsAdmin() then
            return
        end

        SetupNewDroid(tbl.Class, tbl)

        StonemanDroidBase[tbl.Class] = tbl

        net.Start("StonemanDroidBase:Setup")
            net.WriteTable(tbl)
        net.Broadcast()
    end)

    hook.Add("InitPostEntity", "StonemanDroid:InitServer", function()
        StonemanDroidBase = {}
    end)

    net.Receive("StonemanDroidBase:GetSetup", function(len, ply)
        net.Start("StonemanDroidBase:GetSetup")
            net.WriteTable(StonemanDroidBase)
        net.Send(ply)
    end)
else
    net.Receive("StonemanDroidBase:Setup", function(len)
        local tbl = net.ReadTable()
        if not tbl then return end
        
        SetupNewDroid(tbl.Class, tbl)
        
        StonemanDroidBase[tbl.Class] = tbl

        -- MsgC(Color(0, 255, 0), "[Stoneman's Droids] ", Color(255, 255, 255), "New droid setup: " .. tbl.Name .. ".\n")
    end)

    net.Receive("StonemanDroidBase:GetSetup", function(len)
        StonemanDroidBase = net.ReadTable()

        MsgC(Color(0, 255, 0), "[Stoneman's Droids] ", Color(255, 255, 255), "Received " .. table.Count(StonemanDroidBase) .. " droids from the server.\n")
        for k, v in pairs(StonemanDroidBase) do
            SetupNewDroid(k, v)
        end
    end)
end


// Hooks!

if SERVER then
    hook.Add("InitPostEntity", "StonemanDroid:InitServer", function() StonemanDroidBase = {} end)
else
    hook.Add("InitPostEntity", "StonemanDroid:Init", function() InitStonemanDroids() end)
end

hook.Add( "PopulateToolMenu", "StonemanDroid:Populator", function() spawnmenu.AddToolMenuOption( "Options", "Stoneman", "StonemanDroidsPopulator", "Configure Custom Droids", "", "", SpawnMenu, {} ) end ) 