---------- Manual definitions ---  
local interiorsActive = false
local character_selected = false 

----------- turn on the bar ------
function EnableResouresIMAP()         
    if Config.Unknow == true then
        --RequestImap(________________) -- Something relating to BizTemplate        
    end            
    if Config.BountyBoard1 == true then       
	    RequestImap(1570947227) -- New Hanover -- Annesburg -- Sheriff office -- Bounty Board
    end            
    if Config.BountyBoard2 == true then     
    	RequestImap(227456234)    -- New Hanover -- Annesburg -- Sheriff office -- Bounty Board
    end            
    if Config.Parts == true then     
    	RequestImap(-1011647266)-- New Hanover -- Annesburg -- Sheriff office -- Parts    
    end         
end

function EnableResouresINTERIORS(x, y, z) 
    if Config.Jail == true then 
        local interior = GetInteriorAtCoords(x, y, z)   
        ActivateInteriorEntitySet(interior, "ann_jail_int")        -- main
        --ActivateInteriorEntitySet(interior, "________________")        -- main
        --ActivateInteriorEntitySet(interior, "________________")        -- main
        --ActivateInteriorEntitySet(interior, "________________")        -- main
        --ActivateInteriorEntitySet(interior, "________________")        -- sub
    end    
end
 
----------- turn off the bar ------
function DisableResourcesIMAPS() 
    --RemoveImap(________________) -- Something relating to BizTemplate    
	RemoveImap(1570947227) -- New Hanover -- Annesburg -- Sheriff office -- Bounty Board
	RemoveImap(227456234)    -- New Hanover -- Annesburg -- Sheriff office -- Bounty Board
	RemoveImap(-1011647266)-- New Hanover -- Annesburg -- Sheriff office -- Parts
end

function DisableResourcesINTERIORS(x, y, z)  -- DeactivateInteriorEntitySet
    local interior = GetInteriorAtCoords(x, y, z)    
    DeactivateInteriorEntitySet(interior, "ann_jail_int") 
    --DeactivateInteriorEntitySet(interior, "________________")     
    --DeactivateInteriorEntitySet(interior, "________________")             
end    
 
 
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
        --- cleanup any previous scripts loading content
        DisableResourcesIMAPS() 
        DisableResourcesINTERIORS(Config.x, Config.y, Config.z)

        -- basically run once after character has loadded in  
        EnableResouresIMAP() 
        EnableResouresINTERIORS(Config.x, Config.y, Config.z)
        interiorsActive = true
        unlockDoors()  
    end
end)

 