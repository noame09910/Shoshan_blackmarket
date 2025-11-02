
local bountyhunting = 0

local BountyTarget

Config.BountyDebug = false





if(Config.BountyDebug) then
    CreateThread(function()
        for i = 1, #Config.Bounties, 1 do
            local blippoint = Config.Bounties[i]

            local blip = AddBlipForCoord(blippoint)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Bounty Point - "..i)
            EndTextCommandSetBlipName(blip)

        end
    end)
end

local handler

RegisterNetEvent('gi-grangeillegal:BountyStart',function()
    if(GetInvokingResource()) then return end

    if(bountyhunting ~= 0) then
        ESX.ShowHDNotification("ERROR","אתה כבר במשימת חיסול",'error')
        return
    end

    -- local highbounty = exports['gi-ui2']:GetHighBounty()
    -- if(highbounty ~= 0) then
    --     ESX.ShowRGBNotification("error","אתה כבר נמצא בבאונטי")
    --     return
    -- end
    bountyhunting = 1
    Citizen.CreateThreadNow(function()
        PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
        showScaleform("~b~Black Market - Bounty", "~y~Kill The Target Marked On Your Map - Guns Only~w~", 10)
        ESX.ShowHDNotification("Bounty","אתה חייב לחסל את המטרה עם רובה בלבד",'info')
    end)

    

    


    local randomIndex = math.random(1,#Config.Bounties)
    local randombounty = Config.Bounties[randomIndex]
    local randomspot = vector3(randombounty.x + math.random(-40.0, 40.0), randombounty.y + math.random(-40.0, 40.0), randombounty.z)
    local bountyBlip = AddBlipForRadius(randomspot.x, randomspot.y, randomspot.z, 80.0)

    SetBlipHighDetail(bountyBlip, true)
    SetBlipColour(bountyBlip, 44)
    SetBlipAsShortRange(bountyBlip, true)
    SetBlipAlpha(bountyBlip, 200)

    local bBlip2 = AddBlipForCoord(randomspot.x, randomspot.y, randomspot.z)
    SetBlipSprite(bBlip2,303)
    SetBlipAsShortRange(bBlip2, true)
    SetBlipColour(bBlip2, 44)
    SetBlipScale(bBlip2, 1.2)
    SetBlipHighDetail(bBlip2, true)
    SetBlipAsShortRange(bBlip2,false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bounty Area")
    EndTextCommandSetBlipName(bBlip2)
    SetNewWaypoint(randomspot.x, randomspot.y)


    local lastsecond = GetGameTimer()
    local SecsLeft = 1200
    Citizen.CreateThread(function()
        while SecsLeft > 0 do
            Citizen.Wait(0)


            if((GetTimeDifference(GetGameTimer(), lastsecond) > 1000)) then
                lastsecond = GetGameTimer()

                if(bountyhunting == 0) then
                    break
                end

                SecsLeft = SecsLeft - 1
                if(SecsLeft <= 0) then
                    Citizen.CreateThreadNow(function()
                        bountyhunting = 0
                        RemoveBlip(bountyBlip)
                        RemoveBlip(bBlip2)
                        if(DoesEntityExist(BountyTarget)) then
                            DeleteEntity(BountyTarget)
                        end
                        BountyTarget = nil
                        PlaySoundFrontend(-1,"MP_Flash","WastedSounds",0)
                        showScaleform("~r~Bounty Failed~w~", "~r~You Ran Out Of Time~w~", 10)
                        ESX.ShowNotification('המשימה נכשלה, נגמר לך הזמן')
                        SetPedRelationshipGroupHash(PlayerPedId(),joaat("PLAYER"))
                    end)
                    return
                end
            end
            drawTxt(0.92, 1.35, 1.0,1.0,0.4, "Bounty - Time Left:~r~ " .. SecsLeft.. "~w~ Seconds", 255, 255, 255, 255)
        end
    
    end)



    while bountyhunting == 1 do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if #(coords - randomspot) < 160 then
            bountyhunting = 2
            PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
            RemoveBlip(bountyBlip)
            RemoveBlip(bBlip2)
            DeleteWaypoint()
        end
    end

   

    local randommodel = Config.PedModels[math.random(1,#Config.PedModels)]
    local pedModel = joaat(randommodel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(50)
    end
    local weapon = Config.PedWeapons[math.random(1,#Config.PedWeapons)]
    local netid = lib.callback.await("gi-grangeillegal:server:CreateBounty",false,randommodel,weapon,randomIndex)
    BountyTarget = ESX.Game.VerifyEnt(netid,true)
    SetModelAsNoLongerNeeded(pedModel)
    if(not DoesEntityExist(BountyTarget)) then
        bountyhunting = 0
        BountyTarget = nil
        PlaySoundFrontend(-1,"MP_Flash","WastedSounds",0)
        showScaleform("~r~Bounty Failed~w~", "~r~Target Couldn't Be Created~w~", 10)
        ESX.ShowNotification('.לא הצלחנו לשגר את המטרה','error')
        return
    end
    local foundsafecoord, newpos = GetSafeCoordForPed(randomspot.x, randomspot.y, randomspot.z, false, 16)
    if(foundsafecoord) then
        SetEntityCoords(BountyTarget,newpos.x, newpos.y, newpos.z - 1.0)
    else
        SetEntityCoords(BountyTarget,randomspot.x, randomspot.y, randomspot.z - 1.0)
    end
    AddRelationshipGroup("bounty")
    AddRelationshipGroup("hunter")
    SetPedRelationshipGroupHash(PlayerPedId(),joaat("hunter"))
    SetRelationshipBetweenGroups(5, joaat("bounty"), joaat("hunter"))
    SetRelationshipBetweenGroups(1, joaat("hunter"), joaat("PLAYER"))
    SetRelationshipBetweenGroups(1, joaat("hunter"), joaat("hunter"))
    SetRelationshipBetweenGroups(1, joaat("PLAYER"), joaat("hunter"))
    SetRelationshipBetweenGroups(4, joaat("bounty"), joaat("PLAYER"))
    CreateEventHandler(true)
    -- if(foundsafecoord) then
    --     BountyTarget = CreatePed(4 , pedModel, newpos.x, newpos.y, newpos.z - 1.0 , math.random(1.0,360.0) , true, true)
    -- else
    --     BountyTarget = CreatePed(4 , pedModel, randomspot.x, randomspot.y, randomspot.z - 1.0 , math.random(1.0,360.0) , true, true)
    -- end
    -- weapon = joaat(weapon)
    -- GiveWeaponToPed(BountyTarget, weapon, 2000, true, false)
    -- TargetSettings(BountyTarget)
    -- TaskWanderStandard(BountyTarget,10.0,10)
    SetPedRelationshipGroupHash(BountyTarget, joaat("bounty")) 

    local enemyblip = AddBlipForEntity(BountyTarget)
    SetBlipSprite(enemyblip,84)
    SetBlipAsShortRange(enemyblip, true)
    SetBlipColour(enemyblip, 1)
    SetBlipHighDetail(enemyblip, true)
    SetBlipShowCone(enemyblip, true)
    ShowHeadingIndicatorOnBlip(enemyblip, true)
    SetBlipRotation(enemyblip, math.ceil(GetEntityHeading(BountyTarget)))



    ESX.ShowNotification("הגעת לאיזור המטרה, יש לחסל אותו עם רובים/סכינים בלבד")


    local attacking = false

    local ResetRagdoll = false

    while bountyhunting == 2 do
        Wait(0)

        if(not DoesEntityExist(BountyTarget)) then
            Citizen.CreateThreadNow(function()
                RemoveBlip(enemyblip)
                bountyhunting = 0
                BountyTarget = nil
                SetPedRelationshipGroupHash(PlayerPedId(),joaat("PLAYER"))
                PlaySoundFrontend(-1,"MP_Flash","WastedSounds",0)
                showScaleform("~r~Bounty Failed~w~", "~r~Target Has Been Lost~w~", 10)
                ESX.ShowNotification('המשימה נכשלה, איבדת את המטרה')
            end)
            CreateEventHandler(false)
            return
        end

        local ped = PlayerPedId()


        if(IsEntityDead(ped)) then
            Citizen.CreateThreadNow(function()
                bountyhunting = 0
                PlaySoundFrontend(-1,"MP_Flash","WastedSounds",0)
                ESX.ShowNotification('המשימה נכשלה כי מתת')
                SetPedRelationshipGroupHash(PlayerPedId(),joaat("PLAYER"))
                --TaskWanderStandard(BountyTarget,10.0,10)
                if(NetworkHasControlOfEntity(BountyTarget)) then
                    if(HasPedGotWeapon(BountyTarget,weapon,false)) then
                        RemoveWeaponFromPed(BountyTarget,weapon,255,false,true)
                    end
                end
                RemoveBlip(enemyblip)
                ClearPedTasks(BountyTarget)
                SetBlockingOfNonTemporaryEvents(BountyTarget,true)
                TaskReactAndFleePed(BountyTarget,PlayerPedId())
                SetPedKeepTask(BountyTarget,true)
                showScaleform("~r~Bounty Failed~w~", "~r~You Died~w~", 10)
                Citizen.Wait(12000)
                if(DoesEntityExist(BountyTarget)) then
                    DeleteEntity(BountyTarget)
                end
                BountyTarget = nil
            end)
            CreateEventHandler(false)
            return
        end

        -- if(IsPedRagdoll(BountyTarget) and not ResetRagdoll and NetworkHasControlOfEntity(BountyTarget)) then
        --     if not IsEntityDead(BountyTarget) then
        --         CreateThread(function()
        --             ResetRagdoll = true
        --             --ResetPedRagdollTimer(BountyTarget)
        --             ClearPedTasksImmediately(BountyTarget)
        --             TaskCombatPed(BountyTarget,ped,16)
        --             Wait(2000)
        --             ResetRagdoll = false
        --         end)
        --     end
        -- else
        --     NetworkRequestControlOfEntity(BountyTarget)
        -- end

        local coords = GetEntityCoords(ped)

        if(not attacking) then
            if(Vdist(coords,GetEntityCoords(BountyTarget)) < 6.0 or IsPedShooting(ped)) then
                ClearPedTasks(BountyTarget)
                SetRelationshipBetweenGroups(5, joaat("bounty"), joaat("hunter"))
                TaskCombatPed(BountyTarget,ped,16)
                attacking = true
            end

        end

        local tcoords = GetEntityCoords(BountyTarget)

        DrawMarker(20, tcoords.x,tcoords.y,tcoords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.5, 255, 0, 0, 170, false, false, 2, true, false, false, false)
    end

    RemoveBlip(enemyblip)

    bountyhunting = 0
    BountyTarget = nil
    SetPedRelationshipGroupHash(PlayerPedId(),joaat("PLAYER"))
    CreateEventHandler(false)
    --BountyTarget = nil

end)

AddStateBagChangeHandler("SetNormalBounty",nil,function(bagName,key,value,_,rep)
	if not value then return end
	local entity = ESX.Game.GetEntityFromStateBag(bagName)

    if not entity then return end
	local timer = GetGameTimer()
	while NetworkGetEntityOwner(entity) ~= cache.playerId do 
		Wait(0)
		if((GetGameTimer() - timer) > 15000) then
			return
		end
	end
	if(not IsPedAPlayer(entity)) then
        local weapon = joaat(value)
        GiveWeaponToPed(entity, weapon, 2000, true, false)
        TargetSettings(entity)
        TaskWanderStandard(entity,10.0,10)
	end
	Entity(entity).state:set(key, nil, true)
end)

local AllowedWeaponTypes = {
    416676503, -- אקדחים
    -957766203, -- SMG
    970310034, -- Rifles
    1159398588, -- MGS/Heavy Weapons Unused
}

function CreateEventHandler(state)
    if(state) then
        if(handler) then
            return
        end
        handler = AddEventHandler('gameEventTriggered',function(name,data)
            if(bountyhunting ~= 0) then
                if name == "CEventNetworkEntityDamage" then
                    local victim = tonumber(data[1])
                    local attacker = tonumber(data[2])
                    local victimDied = tonumber(data[6]) == 1 and true or false 
                    local weaponHash = tonumber(data[7])


                    if(victimDied and BountyTarget == victim and (not attacker or attacker == -1)) then
                        Citizen.CreateThreadNow(function()
                            PlaySoundFrontend(-1,"MP_Flash","WastedSounds",0)
                            showScaleform("~r~Bounty Failed~w~", "~r~Target Died By Something Else~w~", 10)
                        end) 
                        bountyhunting = 0
                        BountyTarget = nil
                        return
                    end

                    if  not IsPedAPlayer(victim) then 
                        if victim and attacker then
                            if victimDied then
                                if IsEntityAPed(victim) then
                                    if IsEntityAPed(attacker)  then
                                        if IsPedAPlayer(attacker) then
                                            if not IsPedAPlayer(victim) then 
                                                if(BountyTarget == victim) then
                                                    if(attacker == PlayerPedId()) then
                                                        local weptype = GetWeapontypeGroup(weaponHash)
                                                        local allowed = false
                                                    
                                                        for k,v in pairs(AllowedWeaponTypes) do
                                                            if(weptype == v) then
                                                                allowed = true
                                                                break
                                                            end
                                                        end
        
                                                        if(allowed == true) then
                                                            bountyhunting = 0

                                                            Citizen.CreateThreadNow(function()
                                                                PlaySoundFrontend(-1,"Mission_Pass_Notify","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS",0)
                                                                showScaleform("~p~Black Market - Bounty~w~", "~r~Target Assasinated~w~", 10, true)
                                                                ESX.ShowNotification('המטרה חוסלה, עבודה טובה')
                                                            end)
                                                            AnimpostfxPlay("CamPushInTrevor",2000,false)
                                                            
                                                            Wait(50)
                                                            --GiveWeaponToPed(PlayerPedId(),joaat("WEAPON_UNARMED"),255,false,true)
                                                            SetGameplayPedHint(victim, 0.0, 0.0, 0.0, 0,2000, 1000, 1000)
                                                            SetTimeScale(0.2)
                                                            SetFakeWantedLevel(3)
                                                            Citizen.SetTimeout(120000,function()
                                                                SetFakeWantedLevel(0)
                                                            end)
                                                            TriggerEvent('dispatch:bounty')
                                                            Citizen.Wait(2000)
                                                            SetTimeScale(1.0)
                                                            bountyhunting = 0
                                                            ClearPedTasks(BountyTarget)
                                                            BountyTarget = nil
                                                            Citizen.InvokeNative(0x7FDD1128, "gi-grangeillegal:SV_BountySetPrize")
                                                        else
                                                            Citizen.CreateThreadNow(function()
                                                                PlaySoundFrontend(-1,"MP_Flash","WastedSounds",0)
                                                                showScaleform("~r~Bounty Failed~w~", "~r~Target Died By An UnAuthorized Weapon~w~", 10)
                                                                ESX.ShowNotification('המשימה נכשלה, הרגת את המטרה עם נשק אסור')
                                                            end)
                                                            Wait(50)
                                                            SetGameplayPedHint(victim, 0.0, 0.0, 0.0, 0,2000, 1000, 1000)
                                                            SetTimeScale(0.2)
                                                            Citizen.Wait(4000)
                                                            SetTimeScale(1.0)
                                                            bountyhunting = 0
                                                            BountyTarget = nil
                                                        end
                                                    else
                                                        Citizen.CreateThreadNow(function()
                                                            PlaySoundFrontend(-1,"MP_Flash","WastedSounds",0)
                                                            showScaleform("~r~Bounty Failed~w~", "~r~Target Died By Someone Else~w~", 10)
                                                        end) 
                                                        bountyhunting = 0
                                                        BountyTarget = nil
                                                    end
                                                    -- Server Event לקבל כסף
                                                end
                                            end 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        if(handler) then
            RemoveEventHandler(handler)
            handler = nil
        end
    end


end

local lastclaim = GetGameTimer()

function BountyMenu()
    local elements = {}
    table.insert(elements, {label = '<span style="color:red;"> משימת חיסולים </span>',     value = 'none'})
    table.insert(elements, {label = 'אתה מקבל מטרה ואיזור שבו היא נמצאת ואתה מחסל אותה',     value = 'none'})
    table.insert(elements, {label = 'כשאתה מחסל את המטרה תוכל לחזור לכאן לקבל תשלום על העבודה',     value = 'none'})
    table.insert(elements, {label = 'אתה חייב להרוג את המטרה בכוחות עצמך על ידי רובים בלבד',     value = 'none'})
    table.insert(elements, {label = 'דריסה או מכות לא מתקבלים',     value = 'none'})
    -- table.insert(elements, {label = 'במידה ותחסל את המטרה עם נשק קר ( סכין / גרזן וכו ) תקבל בונוס',     value = 'none'})
    table.insert(elements, {label = 'אפשר לבצע עבודה כזאת כל 48 שעות',     value = 'none'})
    table.insert(elements, {label = '👔 <span style="color:red;">התחל</span>',     value = 'BountyAC'})
    table.insert(elements, {label = '🏆 <span style="color:yellow;">אני כאן בשביל הפרס</span>',     value = 'Claim'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BlackMarketBounty', {
        title    = "Bounty תפריט",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        -- if #(vector3(NPC[1].x,NPC[1].y,NPC[1].z) - GetEntityCoords(PlayerPedId())) > 100 then
        --     menu.close()
        --     return
        -- end

        menu.close()
        if data.current.value == "BountyAC" then
            print("Bounty Accept")
            BountyAccept()
        elseif data.current.value == "Claim" then
            if((GetTimeDifference(GetGameTimer(), lastclaim) > 120000)) then
                lastclaim = GetGameTimer()
                Citizen.InvokeNative(0x7FDD1128, "gi-grangeillegal:SV_ClaimPrize")
            else
                ESX.ShowNotification("אפשר לבקש פרס כל 2 דקות")
            end
        end
        
    end, function(data, menu)
        menu.close()
    end)


end

function BountyAccept()
print("Bounty Accept 2")
    local elements = {}
    table.insert(elements, {label = '<span style="color:white;">?האם אתה מעוניין לבצע חיסול בשביל דוס כמוני',     value = 'none'})
    table.insert(elements, {label = '<span style="color:red;"> כן, יא מניאק </span>',     value = 'yes'})
    table.insert(elements, {label = '<span style="color:green;"> !!!לא, אני אזרח שומר חוק תתביישו לכם אני קורא למשטרה' ,     value = 'no'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BlackMarketBounty', {
        title    = "Bounty תפריט",
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        
        --menu.close()
        ESX.UI.Menu.CloseAll()
        if data.current.value == "yes" then
            Citizen.InvokeNative(0x7FDD1128, "gi-grangeillegal:SV_BountyStart")
        elseif data.current.value == "no" then
            ESX.ShowNotification("פחדן אפס")
        end
        
    end, function(data, menu)
        menu.close()
    end)

end

function showScaleform(title, desc, sec, nofire)
	function Initialize(scaleform)
		local scaleform = RequestScaleformMovie(scaleform)

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		PushScaleformMovieFunctionParameterString(title)
		PushScaleformMovieFunctionParameterString(desc)
		PopScaleformMovieFunctionVoid()
		return scaleform
	end
	scaleform = Initialize("mp_big_message_freemode")
	while sec > 0 do
		sec = sec - 0.02
		Citizen.Wait(0)
        if(nofire) then
            DisablePlayerFiring(PlayerId(),true)
            DisableControlAction(0,24,true) -- Shoot
            DisableControlAction(0,25,true) -- Aim
        end
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
	end
	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(fontId)
    --SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
      SetTextOutline()
  end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
  

function TargetSettings(BountyTarget)
    if not DoesRelationshipGroupExist(joaat("bounty")) then
        AddRelationshipGroup("bounty")
    end

    if not DoesRelationshipGroupExist(joaat("hunter")) then
        AddRelationshipGroup("hunter")
    end

    SetPedCombatAttributes(BountyTarget, 0, true)
    SetPedCombatAttributes(BountyTarget, 1, true)
    SetPedCombatAttributes(BountyTarget, 2, true)
    SetPedCombatAttributes(BountyTarget, 3, true)
    SetPedCombatAttributes(BountyTarget, 5, true)
    SetPedCombatAbility(BountyTarget, 100)
    SetPedCombatMovement(BountyTarget, 2)
    SetPedCombatRange(BountyTarget, 2)
    SetPedFleeAttributes(BountyTarget, 0, false)
    SetPedAsEnemy(BountyTarget,true)
    SetPedSuffersCriticalHits(BountyTarget,false)
    SetPedHighlyPerceptive(BountyTarget, true)
    SetPedDropsWeaponsWhenDead(BountyTarget, false)
    SetPedArmour(BountyTarget, 80)
    SetPedMaxHealth(BountyTarget, 200)
    SetPedAlertness(BountyTarget,3)
    SetRagdollBlockingFlags(BountyTarget,1)
    --SetRagdollBlockingFlags(BountyTarget,2)
    SetPedConfigFlag(BountyTarget,108,true)
    SetRagdollBlockingFlags(BountyTarget,4)
    --SetPedInfiniteAmmoClip(BountyTarget,true)
    --SetPedCanRagdoll(BountyTarget,false)
    SetPedCanRagdollFromPlayerImpact(BountyTarget,false)
    SetPedSweat(BountyTarget,math.random(20,80))
    SetPedFiringPattern(BountyTarget,joaat("FIRING_PATTERN_FULL_AUTO"))
    SetPedRelationshipGroupHash(BountyTarget, joaat("bounty")) 
    SetRelationshipBetweenGroups(0, joaat("bounty"), joaat("bounty")) 
    SetRelationshipBetweenGroups(4, joaat("bounty"), joaat("hunter"))
    SetRelationshipBetweenGroups(0, joaat("bounty"), joaat("PLAYER"))
    local id = NetworkGetNetworkIdFromEntity(BountyTarget)
    SetNetworkIdCanMigrate(id,false)
end


exports("GetBounty",function()
    return bountyhunting
end)



---- My Discord - https://discord.gg/RBJqveM7

---- CutScene List - https://pastebin.com/DmCkxuQE
---- Simple CutScene Player

RegisterCommand("cutscene", function(source, args)
    local cutscene = args[1]
    TriggerEvent('Cutsceneplayer:Play', cutscene)
end)

TriggerEvent('chat:addSuggestion', '/cutscene', 'Play Cut Scene', {{name="cut scene name"}})

RegisterNetEvent("Cutsceneplayer:Play")
AddEventHandler("Cutsceneplayer:Play", function(cutscene)
    local playerId = PlayerPedId()
    
	if IsPedMale(playerId) then RequestCutsceneWithPlaybackList(cutscene, 31, 8)
    	else RequestCutsceneWithPlaybackList(cutscene, 103, 8) end

    	while not HasCutsceneLoaded() do Wait(10)  
    end
    StartCutscene(4)
end)


RegisterCommand("stopcutscene", function(source, args)
    StopCutsceneImmediately()
end)