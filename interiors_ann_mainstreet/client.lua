---------- Manual definitions ---  
local interiorsActive = false
local character_selected = false 
 
function EnableResouresIMAP()          
    if Config.FastTravel == true then
        RequestImap(582879672)  -- New Hanover -- Annesburg -- Fast Travel 
    end    
    if Config.LogFence == true then
        RequestImap(429527177)  -- New Hanover -- Annesburg -- log fencing parts and dec
    end     
    if Config.Debris == true then 
        RequestImap(-1584316325)-- New Hanover -- Annesburg -- Crates, Barrels and Wagons #01
        RequestImap(-537740003) -- New Hanover -- Annesburg -- Crates, Barrels and Wagons #02
    end 
    if Config.Rope == true then 
        RequestImap(-1984145124)-- New Hanover -- Annesburg -- Rope on water
    end     
    if Config.Docks == true then
        RequestImap(-1315256079)-- New Hanover -- Annesburg -- Unknown Imap at Docks #01 
    end     
    	--## Annesburg ##--  
	RequestImap(-687164887) -- New Hanover -- Annesburg -- Model LOD do not remove  
end

function EnableResouresINTERIORS(x, y, z)  
    local interior = GetInteriorAtCoords(x, y, z)  
    --[[ 
    ActivateInteriorEntitySet(interior, "val_saloon2_int")       
    if Config.Unknow == true then  
        ActivateInteriorEntitySet(interior, "l_00260edcej")         
    end       
    --]]

end

-- currently there are two hitching posts. 

----------- turn off the bar ------
function DisableResourcesIMAPS() 
	--## Annesburg ##-- 
	RemoveImap(582879672)  -- New Hanover -- Annesburg -- Fast Travel 
	RemoveImap(-687164887) -- New Hanover -- Annesburg -- Model LOD do not remove
	RemoveImap(429527177)  -- New Hanover -- Annesburg -- log fencing parts and dec
	RemoveImap(-1584316325)-- New Hanover -- Annesburg -- Crates, Barrels and Wagons #01
	RemoveImap(-537740003) -- New Hanover -- Annesburg -- Crates, Barrels and Wagons #02
	RemoveImap(-1984145124)-- New Hanover -- Annesburg -- Rope on water
	RemoveImap(-1315256079)-- New Hanover -- Annesburg -- Unknown Imap at Docks #01 
end

function DisableResourcesINTERIORS(x, y, z)  
    local interior = GetInteriorAtCoords(x, y, z)    
    --[[ 
    DeactivateInteriorEntitySet(interior, "val_saloon2_int")     
    DeactivateInteriorEntitySet(interior, "l_00260edcej")        
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

 