---------- Manual definitions --- 
--## Missing cabin  <- case/ticket
--## Melvins house on fire  <- case/ticket
--## teleportme -2374.759 -1589.142 155.0542  
local interiorsActive = false
local character_selected = false
Config = {}
Config.Commands = true   -- For testing set to false for live server
Config.TeleportME = true   -- For testing set to false for live server

----------- turn on the house ------
function EnableResouresIMAP() 
    -- House on Fire  --
	RequestImap(-1387511711)   -- shell of cabin  
	RequestImap(1901132483)   --- interior of cabin
end

----------- turn off the house ------
function DisableResourcesIMAPS()
    --------- ### Problem IPLs ### 
	RemoveImap(-1387511711)   -- shell of cabin 
	RemoveImap(1901132483)   --- interior of cabin
end
   
----------- turn on the fires  ------
function EnableBlazeFIREIMAP()  
	RequestImap(-2082345587)   -- onfire -- blazing   
end 
function EnableSmallFIREIMAP()   
	RequestImap(77337110)		-- secondary smaller fire
end 
   
----------- turn off the fires  ------
function DisableBlazeFIREIMAPS()  
	RemoveImap(-2082345587)   -- onfire  -- blazing   
end 
function DisableSmallFIREIMAPS()   
	RemoveImap(77337110)		-- secondary smaller fire
end 
    
-----------------------------------------------------
---- admin commands to control the fires ------------
--- add admind perms later
-----------------------------------------------------
RegisterCommand("turnonfire", function(source, args)    
    if Config.Commands == true then   
        TriggerEvent( "HF:turnonfire", "ok" ) 
    else 
        print("Turn On Fire is disabled in script House Fire.")
    end
end)
RegisterNetEvent('HF:turnonfire')
AddEventHandler('HF:turnonfire', function(no_String)  
	EnableFIREIMAP()
    Wait(800) 
end) 
  
RegisterCommand("turnofffire", function(source, args)  
    if Config.Commands == true then       
        TriggerEvent( "HF:turnofffire", "ok" ) 
    else 
        print("Turn Off Fire is disabled in script House Fire.")
    end
end)
RegisterNetEvent('HF:turnofffire')
AddEventHandler('HF:turnofffire', function(no_String)  
	DisableFIREIMAPS()
    Wait(800) 
end)  

-----------------------------------------------------
------ admin commands to control the house ----------
--- add admind perms later
-----------------------------------------------------
RegisterCommand("turnonhouse", function(source, args)    
    if Config.Commands == true then   
        TriggerEvent( "HF:turnonhouse", "ok" ) 
    else 
        print("Turn On House is disabled in script House Fire.")
    end
end)
RegisterNetEvent('HF:turnonhouse')
AddEventHandler('HF:turnonhouse', function(no_String)  
	EnableResouresIMAP() 
    Wait(800) 
end) 
  
RegisterCommand("turnoffhouse", function(source, args)  
    if Config.Commands == true then       
        TriggerEvent( "HF:turnoffhouse", "ok" ) 
    else 
        print("Turn Off House is disabled in script House Fire.")
    end
end)
RegisterNetEvent('HF:turnoffhouse')
AddEventHandler('HF:turnoffhouse', function(no_String)  
	DisableResourcesIMAPS()
    Wait(800) 
end)  

-----------------------------------------------------
---remove all on resource stop---
-----------------------------------------------------
AddEventHandler('onResourceStop', function(resource) 
    if resource == GetCurrentResourceName() then     
        -- when resource stops disable them, admin is restarting the script
        DisableResourcesIMAPS()
        DisableSmallFIREIMAPS()
        DisableBlazeFIREIMAPS()
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
        DisableSmallFIREIMAPS()
        DisableBlazeFIREIMAPS()    
        Citizen.Wait(3000)        
        -- because the character is already logged in on resource "re"start
        character_selected = true
    end
end)
 

-----------------------------------------------------
-- Telport admin to the house location
-----------------------------------------------------
RegisterCommand("takemetohousefire", function(source, args)    
    if args ~= nil then   
        local data =  source 
        local ped = PlayerPedId() 
        local coords = GetEntityCoords(ped)  
        local HouseFire_x = -2374.759
        local HouseFire_y = -1589.142
        local HouseFire_z = 155.0542
        if Config.TeleportME == true then 
            TriggerEvent( "HF:scottybeammeup", HouseFire_x, HouseFire_y, HouseFire_z )
        else 
            print("Teleport Me is disabled in script House Fire.")
        end 
    end
end)

RegisterNetEvent('HF:scottybeammeup')
AddEventHandler('HF:scottybeammeup', function(x,y,z)  
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
        interiorsActive = true
    end
end)