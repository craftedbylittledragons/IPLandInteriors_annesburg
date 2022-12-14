---------- Manual definitions ---  
local interiorsActive = false
local character_selected = false
Config = {}
Config.Commands = true  -- For testing set to false for live server
Config.TeleportME = true -- For testing set to false for live server

Config.Cabin = true 
Config.Fire = 1 -- 1 (no fire) or 2 (active fire) or 3 (fire burned out)
Config.CashBox = true 
Config.Wheel = true 

Config.Label = "House North of Valentine"
Config.x = -379.01 
Config.y = 917.94
Config.z = 118.59   

----------- turn on the cabin ------
function EnableResouresIMAP()  
    ------------------------House North of Valentine -441.4, 499.04, 98.94
    if Config.Cabin == true then 
        RequestImap(-338553155)   -- New Hanover -- Near Annesburg Mining Town -- Exterior House
        if Config.Fire == 1 then       	
            --## Farm House near Annesburg Mining Town -559 2686 319  ##-- 
            RequestImap(-1636879249)  -- New Hanover -- Near Annesburg Mining Town -- Normal Looking Interior
        elseif Config.Fire == 2 then       
            RequestImap(-323126593) -- New Hanover -- Near Annesburg Mining Town -- Burned Out Interior	    
            RequestImap(-889869458) -- New Hanover -- Near Annesburg Mining Town -- Debris        
            RequestImap(1590561203) -- New Hanover -- Near Annesburg Mining Town -- Flames
        elseif Config.Fire == 3 then       	
            RequestImap(-323126593) -- New Hanover -- Near Annesburg Mining Town -- Burned Out Interior     
            RequestImap(-889869458) -- New Hanover -- Near Annesburg Mining Town -- Debris                   
        else        	  
            RequestImap(-1636879249)  -- New Hanover -- Near Annesburg Mining Town -- Normal Looking Interior
        end  
    else 
    end  

    if Config.Wheel == true then 
        RequestImap(-1106668087)  -- New Hanover -- Near Annesburg Mining Town -- Adds Wagon Wheel near Front Door
    else 
    end 

    if Config.CashBox == true then 
        RequestImap(2028590076)   -- New Hanover -- Near Annesburg Mining Town -- Cash Box Interior   
    else 
    end  

end

function EnableResouresINTERIORS(x, y, z)  
    --[[
    local interior = GetInteriorAtCoords(x, y, z)  
    ActivateInteriorEntitySet(interior, "val_res_a_int")       
    --]]
end

----------- turn off the cabin ------
function DisableResourcesIMAPS()
    --## Farm House near Annesburg Mining Town -559 2686 319  ##--
    RemoveImap(-338553155)   -- New Hanover -- Near Annesburg Mining Town -- Exterior House
    RemoveImap(-1636879249)  -- New Hanover -- Near Annesburg Mining Town -- Normal Looking Interior
    
    RemoveImap(-323126593) -- New Hanover -- Near Annesburg Mining Town -- Burned Out Interior
    RemoveImap(-889869458) -- New Hanover -- Near Annesburg Mining Town -- Debris
    RemoveImap(1590561203) -- New Hanover -- Near Annesburg Mining Town -- Flames

    RemoveImap(-1106668087)  -- New Hanover -- Near Annesburg Mining Town -- Adds Wagon Wheel near Front Door
    RemoveImap(2028590076)   -- New Hanover -- Near Annesburg Mining Town -- Cash Box Interior   	
end

function DisableResourcesINTERIORS(x, y, z)  
    --[[
    local interior = GetInteriorAtCoords(x, y, z)  --- teleportme 1450.0452 372.4734 89.6804 
    DeactivateInteriorEntitySet(interior, "val_res_a_int")       
    ]]--
end    
 

-----------------------------------------------------
------ admin commands to control the cabin ----------
--- add admind perms later
-----------------------------------------------------
RegisterCommand("VNH:turnon_houseinterior", function(source, args)    
    if Config.Commands == true then   
        TriggerEvent( "VNH:turnon_houseinterior", "ok" ) 
    else 
        print("Turn On IMAP is disabled in script "..Config.Label)
    end
end)
RegisterNetEvent('VNH:turnon_houseinterior')
AddEventHandler('VNH:turnon_houseinterior', function(no_String)  
	EnableResouresIMAP() 
    EnableResouresINTERIORS(Config.x, Config.y, Config.z)
    Wait(800) 
end) 
  
RegisterCommand("VNH:turnoff_houseinterior", function(source, args)  
    if Config.Commands == true then       
        TriggerEvent( "VNH:turnoff_houseinterior", "ok" ) 
    else 
        print("Turn Off IMAP is disabled in script "..Config.Label)
    end
end)
RegisterNetEvent('VNH:turnoff_houseinterior')
AddEventHandler('VNH:turnoff_houseinterior', function(no_String)  
	DisableResourcesIMAPS()
    DisableResourcesINTERIORS(Config.x, Config.y, Config.z)
    Wait(800) 
end)  

-----------------------------------------------------
---remove all on resource stop---
-----------------------------------------------------
AddEventHandler('onResourceStop', function(resource) 
    if resource == GetCurrentResourceName() then     
        -- when resource stops disable them, admin is restarting the script
        DisableResourcesIMAPS() 
        DisableResourcesINTERIORS(Config.x, Config.y, Config.z)
    end
end)

-----------------------------------------------------
--- clear all on resource start ---
-----------------------------------------------------
AddEventHandler('onResourceStart', function(resource) 
    if resource == GetCurrentResourceName() then         
        Citizen.Wait(3000)
        -- interiors loads all of these, so we need to disable them 
        DisableResourcesIMAPS() 
        DisableResourcesINTERIORS(Config.x, Config.y, Config.z)
        Citizen.Wait(3000)        
        -- because the character is already logged in on resource "re"start
        character_selected = true
    end
end)
 

-----------------------------------------------------
-- Telport admin to the hosue location
-----------------------------------------------------
RegisterCommand("takemetovalcabin", function(source, args)    
    if args ~= nil then   
        local data =  source 
        local ped = PlayerPedId() 
        local coords = GetEntityCoords(ped)        
        if Config.TeleportME == true then 
            TriggerEvent( "VNH:scottybeammeup", Config.x, Config.y, Config.z )
        else 
            print("Teleport Me is disabled in "..Config.Label)
        end 
    end
end)

RegisterNetEvent('VNH:scottybeammeup')
AddEventHandler('VNH:scottybeammeup', function(x,y,z)  
    local player = PlayerPedId() 
    Wait(800)
    DoScreenFadeOut(5000) 
    Wait(10000)
    SetEntityCoords(player, x, y, z)
    DoScreenFadeIn(5000)      
end)
 

-----------------------------------------------------
-- Trigger when character is selected
-----------------------------------------------------
RegisterNetEvent("vorp:SelectedCharacter") -- NPC loads after selecting character
AddEventHandler("vorp:SelectedCharacter", function(charid) 
	character_selected = true
end)


-----------------------------------------------------
-- Main thread that controls the script
-----------------------------------------------------
Citizen.CreateThread(function()
    while character_selected == false do 
        Citizen.Wait(1000)
    end 
    if character_selected == true and interiorsActive == false then 
        -- basically run once after character has loadded in  
        EnableResouresIMAP() 
        EnableResouresINTERIORS(Config.x, Config.y, Config.z)
        interiorsActive = true
    end
end)