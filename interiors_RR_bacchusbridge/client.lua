---------- Manual definitions ---  
local interiorsActive = false
local character_selected = false 

----------- turn on the bar ------
function EnableResouresIMAP()         
    --------------------------------  Keane's Saloon 
    if Config.HayBales == true then
        RequestImap(-2083943324) --hay bales and boxes outside Keane's Saloon in valentine 
    end    
    if Config.Unknow == true then
        RequestImap(666617953) -- Something relating to BizTemplate
    end     
    if Config.Debris == true then 
        RequestImap(610256856) -- New Hanover -- Valentine -- Keane's Saloon -- Debris and Remodle next to Liqour
    end 
	-- Bacchus Bridge --
	RequestImap(1364392658)   -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Undamaged
	RequestImap(890452998)	  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Undamaged LOD
	RequestImap(-794503195) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Damaged
	RequestImap(-543171902) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Damaged LOD
	RequestImap(1492058366) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Debris Near Bacchus Station
	RequestImap(-437187151) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #01
	RequestImap(920612809)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #02
	RequestImap(1424964403) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #03
	RequestImap(820079465)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #04
	RequestImap(-200959126) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #05
	RequestImap(-724540003) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #06
	RequestImap(777001839)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #07
	RequestImap(423891836)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #08
	RequestImap(-163787010) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #09
	RequestImap(-615794465) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #10

end

function EnableResouresINTERIORS(x, y, z)  
    local interior = GetInteriorAtCoords(x, y, z)  
    --[[
        [29698] = {x=-241.58325195313,y=769.90649414063,z=117.54511260986,typeHashId=-565068911,typeHashName="val_saloon2_int",rpf="val_saloon2_int.rpf"},
        29698 	-565068911 	val_saloon2_int 	l_00260edcej   
    --]]
    ActivateInteriorEntitySet(interior, "val_saloon2_int")       
    if Config.Unknow == true then  
        ActivateInteriorEntitySet(interior, "l_00260edcej")         
    end   

end

-- currently there are two hitching posts. 

----------- turn off the bar ------
function DisableResourcesIMAPS() 
	-- Bacchus Bridge --
	RemoveImap(1364392658)   -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Undamaged
	RemoveImap(890452998)	  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Undamaged LOD
	RemoveImap(-794503195) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Damaged
	RemoveImap(-543171902) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Damaged LOD
	RemoveImap(1492058366) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Debris Near Bacchus Station
	RemoveImap(-437187151) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #01
	RemoveImap(920612809)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #02
	RemoveImap(1424964403) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #03
	RemoveImap(820079465)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #04
	RemoveImap(-200959126) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #05
	RemoveImap(-724540003) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #06
	RemoveImap(777001839)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #07
	RemoveImap(423891836)  -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #08
	RemoveImap(-163787010) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #09
	RemoveImap(-615794465) -- New Hanover -- Cumberland Forest -- Railroad -- Bacchus Bridge -- Unknown Imap #10

end

function DisableResourcesINTERIORS(x, y, z)  
    local interior = GetInteriorAtCoords(x, y, z)    
    DeactivateInteriorEntitySet(interior, "val_saloon2_int")     
    DeactivateInteriorEntitySet(interior, "l_00260edcej")         
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

 