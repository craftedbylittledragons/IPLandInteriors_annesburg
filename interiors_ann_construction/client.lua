---------- Manual definitions ---  
local interiorsActive = false
local character_selected = false 

----------- turn on the bar ------
function EnableResouresIMAP()          
    if Config.Construction == 1 then
        RequestImap(1517736440)   -- New Hanover -- Annesburg -- Building Construction Part #01
    elseif Config.Construction == 2 then
        RequestImap(-693132475)   -- New Hanover -- Annesburg -- Building Construction Part #02
    elseif Config.Construction == 3 then
        RequestImap(-1509154451)-- New Hanover -- Annesburg -- Building Construction Completed (Walls) #01
        RequestImap(-87516051)  -- New Hanover -- Annesburg -- Building Construction Completed (Roof) #02
    end    
    if Config.Unknown1 == true then
        RequestImap(1912921446) -- New Hanover -- Annesburg -- Unknown Imap at Building Construction #01 	
    end       
    if Config.Unknown2 == true then 
        RequestImap(555501256)  -- New Hanover -- Annesburg -- Unknown Imap at Building Construction #02 	
    end      
    if Config.Unknown3 == true then 
        RequestImap(934782463)  -- New Hanover -- Annesburg -- Unknown Imap at Building Construction #03	
    end         
end

function EnableResouresINTERIORS(x, y, z)  
    if Config.Unknown == true then
        --[[  
        local interior = GetInteriorAtCoords(x, y, z)   
        ActivateInteriorEntitySet(interior, "________________")       
        if Config.Unknow == true then  
            ActivateInteriorEntitySet(interior, "________________")         
        end      
        --]]    
    end   
end

-- currently there are two hitching posts. 

----------- turn off the bar ------
function DisableResourcesIMAPS() 
	RemoveImap(1517736440)   -- New Hanover -- Annesburg -- Building Construction Part #01
	RemoveImap(-693132475)   -- New Hanover -- Annesburg -- Building Construction Part #02
	RemoveImap(-1509154451)-- New Hanover -- Annesburg -- Building Construction Completed (Walls) #01
	RemoveImap(-87516051)  -- New Hanover -- Annesburg -- Building Construction Completed (Roof) #02
	RemoveImap(1912921446) -- New Hanover -- Annesburg -- Unknown Imap at Building Construction #01
	RemoveImap(555501256)  -- New Hanover -- Annesburg -- Unknown Imap at Building Construction #02
	RemoveImap(934782463)  -- New Hanover -- Annesburg -- Unknown Imap at Building Construction #03 
end

function DisableResourcesINTERIORS(x, y, z)  
    --[[  
    local interior = GetInteriorAtCoords(x, y, z)    
    DeactivateInteriorEntitySet(interior, "________________")     
    DeactivateInteriorEntitySet(interior, "________________")     
    --]]    
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

 