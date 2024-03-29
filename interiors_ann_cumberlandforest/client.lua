---------- Manual definitions ---  
local interiorsActive = false
local character_selected = false 

----------- turn on the bar ------
function EnableResouresYMAPS()            
    if Config.Cumberland == true then
	--## Cumberland Forest ##--
	    RequestImap(604668055)    -- New Hanover -- Cumberland Forest -- Tree Logs -- Debris Near Road
    	RequestImap(1672215059)    -- New Hanover -- Cumberland Forest -- Tree Logs -- Debris on the Road
	    RequestImap(23211744)   -- New Hanover -- Cumberland Forest -- Tree Logs -- Same as Above 1672215059
	    RequestImap(-528294019)    -- New Hanover -- Cumberland Forest -- Tree Logs -- TNT Line Leading Towards Road
    end  
end

function EnableResouresINTERIORS(x, y, z)  
    local interior = GetInteriorAtCoords(x, y, z)  
    --[[
    ActivateInteriorEntitySet(interior, "val_saloon2_int")       
    if Config.Unknow1 == true then  
        ActivateInteriorEntitySet(interior, "l_00260edcej")         
    end       
    --]]

end

-- currently there are two hitching posts. 

----------- turn off the bar ------
function DisableResourcesYMAPS() 	
    --## Cumberland Forest ##--
	RemoveImap(604668055)    -- New Hanover -- Cumberland Forest -- Tree Logs -- Debris Near Road
	RemoveImap(1672215059)    -- New Hanover -- Cumberland Forest -- Tree Logs -- Debris on the Road
	RemoveImap(23211744)   -- New Hanover -- Cumberland Forest -- Tree Logs -- Same as Above 1672215059
	RemoveImap(-528294019)    -- New Hanover -- Cumberland Forest -- Tree Logs -- TNT Line Leading Towards Road
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
        DisableResourcesYMAPS() 
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
        DisableResourcesYMAPS() 
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
        DisableResourcesYMAPS() 
        DisableResourcesINTERIORS(Config.x, Config.y, Config.z)

        -- basically run once after character has loadded in  
        EnableResouresYMAPS() 
        EnableResouresINTERIORS(Config.x, Config.y, Config.z)
        interiorsActive = true
        unlockDoors()  
    end
end)

 