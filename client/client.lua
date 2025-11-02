local Shop = {}

local Rampage = false

NPC = {}

RegisterNetEvent('grangelegal4203123')

AddEventHandler('grangelegal4203123',function(var1,var2)

    Shop = var1

    NPC = var2

end)

NPC = {
    {
        model = "a_f_m_bodybuild_01",
        x = 422.7910,
        y = -979.4257,
        z = 30.7118,
        h = 89.29,
        seller = true
    },
    {
        model = "a_f_m_bodybuild_01",
        x = 1108.0,
        y = -2002.0,
        z = 30.0,
        h = 0.0,
        seller = true
    }
}

local npcs = {}



Citizen.CreateThread(function()

    TriggerEvent('Apache4203D24')







    local targetcoord

    for _, v in pairs(NPC) do

        targetcoord = vector3(v.x,v.y,v.z)

        break

    end

    local spawnedin = false



    while true do

        Wait(1000)

        local ped = PlayerPedId()

        local coords = GetEntityCoords(ped)

        -- debug prints
        if targetcoord then
            local dist = #(targetcoord - coords)
            -- print("[blackmarket] time="..GetGameTimer().." targetcoord="..tostring(targetcoord).." player="..tostring(coords).." dist="..tostring(dist).." spawnedin="..tostring(spawnedin))
        else
            -- print("[blackmarket] time="..GetGameTimer().." targetcoord=nil player="..tostring(coords).." spawnedin="..tostring(spawnedin))
        end

        if(not spawnedin) then

            if targetcoord and #(targetcoord - coords) < 100 then

                spawnedin = true

                -- print("[blackmarket] Entering area -> spawning NPCs")
                AddBMNPCS()

            end

        else

            if (not targetcoord) or #(targetcoord - coords) >= 100 then

                spawnedin = false

                -- print("[blackmarket] Leaving area -> removing NPCs")
                RemoveBMNPCS()

            end

        end

    end

    

end)

RegisterCommand("addblackmarket", function (source, args, rawCommand)

  AddBMNPCS()
    
end, false)



function AddBMNPCS()

    for _, v in pairs(NPC) do
-- print("[blackmarket] Spawning NPC model="..tostring(v.model).." at "..tostring(v.x)..","..tostring(v.y)..","..tostring(v.z))
        RequestModel(joaat(v.model))

        while not HasModelLoaded(joaat(v.model)) do

            Wait(1)

        end

        local npc = CreatePed(4, v.model, v.x, v.y, v.z, v.h,  false, true)

        SetPedFleeAttributes(npc, 0, 0)

        SetPedDropsWeaponsWhenDead(npc, false)

        SetPedDiesWhenInjured(npc, false)

        SetEntityInvincible(npc , true)

        FreezeEntityPosition(npc, true)

        SetPedCanBeTargetted(npc,false)

        SetBlockingOfNonTemporaryEvents(npc, true)

        SetModelAsNoLongerNeeded(joaat(v.model))

        SetEntityLodDist(npc,25)

        table.insert(npcs,npc)

        if v.seller then 

            RequestAnimDict("missfbi_s4mop")

            while not HasAnimDictLoaded("missfbi_s4mop") do

                Wait(1)

            end

            TaskPlayAnim(npc, "missfbi_s4mop" ,"guard_idle_a" ,8.0, 1, -1, 49, 0, false, false, false)

            RemoveAnimDict("missfbi_s4mop")

            SetAmbientVoiceName(npc,"TREVOR_NORMAL")

            exports.ox_target:addLocalEntity(npc, 

            {

                name = 'blackmarkettarget',

                label = "שוק שחור",

                icon = "fas fa-person-rifle",

                onSelect = function()

                    TriggerEvent('InteractSound_CL:PlayOnOne', 'jerusalemahsheli', 0.10)

                    StopCurrentPlayingAmbientSpeech(npc)

                    if(ESX.PlayerData.job.name == "police") then

                        PlayAmbientSpeech1(npc, "SPOT_POLICE", "Speech_Params_Force")

                    else

                        PlayAmbientSpeech1(npc, "HOWS_IT_GOING_GENERIC", "Speech_Params_Force")

                    end

                    blackmarket()

                    -- BlackMarketMainMenu()

                end,

                distance = 3.0

            })

        else

            GiveWeaponToPed(npc, joaat("WEAPON_RPG"), 2800, true, true)

        end



        SetModelAsNoLongerNeeded(joaat(v.model))

    end

end


RegisterCommand("openblmr", function (source, args, rawCommand)

  blackmarket()
    
end, false)

    

function RemoveBMNPCS()

    for i = 1, #npcs, 1 do

        exports['ox_target']:removeLocalEntity(npcs[i])

        DeletePed(npcs[i])

    end

end



--[[RegisterNetEvent('gi-grangenpcback')

AddEventHandler('gi-grangenpcback',function()



    for _, v in pairs(NPC) do

        RequestModel(joaat(v.model))

        while not HasModelLoaded(joaat(v.model)) do

            Wait(1)

        end

        local npc = CreatePed(4, v.model, v.x, v.y, v.z, v.h,  false, true)

        SetPedFleeAttributes(npc, 0, 0)

        SetPedDropsWeaponsWhenDead(npc, false)

        SetPedDiesWhenInjured(npc, false)

        SetEntityInvincible(npc , true)

        FreezeEntityPosition(npc, true)

        SetBlockingOfNonTemporaryEvents(npc, true)

        SetModelAsNoLongerNeeded(joaat(v.model))

        if v.seller then 

            RequestAnimDict("missfbi_s4mop")

            while not HasAnimDictLoaded("missfbi_s4mop") do

                Wait(1)

            end

            TaskPlayAnim(npc, "missfbi_s4mop" ,"guard_idle_a" ,8.0, 1, -1, 49, 0, false, false, false)

            RemoveAnimDict("missfbi_s4mop")

        else

            GiveWeaponToPed(npc, joaat("WEAPON_MILITARYRIFLE"), 2800, true, true)

        end

    end



end)--]]





local lastscout





function BlackMarketMainMenu()



    ESX.UI.Menu.CloseAll()



    local elements = {}

    if(#Config.Weapons ~= 0) then

        table.insert(elements, {label = '🔫 <span style="color:red;"> חנות נשקים </span>',     value = 'IllegalsMenu', hintImage = 'https://pbs.twimg.com/media/FfCPpAtWAAA0qYz.jpg:large'})

    else

        table.insert(elements, {label = '🔫 <span style="color:red;"> .אני לא מוכר נשקים יותר, יש לחפש את ארגוני הפשע בעיר </span>',     value = 'IllegalsMenu'})

    end

    table.insert(elements, {label = '🔪 <span style="color:yellow;"> חנות כללית </span>',     value = 'IllegalPawn'})

    table.insert(elements, {label = 'תיקון מצב הנשק',     value = 'RepairWeapon'})

    table.insert(elements, {label = '👮 כמה שוטרים בעיר : <span style="color:green;">₪'..ESX.Math.GroupDigits(Config.CPrice).."</span>",     value = 'ShowCops', hintImage = "https://ynet-pic1.yit.co.il/picserver5/wcm_upload/2023/08/02/Hyw0005wsn/photo_2023_08_02_11_50_15.jpg"})

    table.insert(elements, {label = '💰 <span style="color:orange;">איך מלבינים כסף שחור</span>',     value = 'TutorialBlack', hintImage = 'https://d3m9l0v76dty0.cloudfront.net/system/photos/2941344/large/61f30d5c3e65a59f20ca29a90a911994.jpg'})

    table.insert(elements, {label = '💰 <span style="color:blue;">בדיקת לוחית</span>',     value = 'SearchPlate'})

    table.insert(elements, {label = '👔 <span style="color:red;">חיסולים</span>',     value = 'Bounty', hintImage = 'https://pic1.calcalist.co.il/picserver3/crop_images/2024/01/02/H1tLd6W006/H1tLd6W006_202_310_897_505_0_x-large.jpg'})

    table.insert(elements, {label = 'עבודת סמים',     value = 'WeedJob'})

    table.insert(elements, {label = 'שם עליך זין',     value = 'putzain', hint = "שם זין על השוק השחור", hintImage = "https://img.ice.co.il/giflib/news/rsPhoto/sz_198/rsz_615_346_dudu_faruk_oritaub870.jpg"})

    table.insert(elements, {label = 'Rampage',     value = 'rampage', hint = "הסבר בתפריט שיפתח מהאופציה הזאת"})



        

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BlackMarket', {

        title    = "תפריט שוק שחור",

        align    = 'top-left',

        elements = elements

    }, function(data, menu)



        if #(vector3(NPC[1].x,NPC[1].y,NPC[1].z) - GetEntityCoords(PlayerPedId())) > 100 then

            menu.close()

            return

        end

        

        if data.current.value == 'IllegalsMenu' then

            AddShopsIllegalMenu()

        elseif data.current.value == 'rampage' then

            menu.close()

            RampageMenu()

        elseif data.current.value == 'putzain' then

            menu.close()

            CreateThread(function()

                

                ExecuteCommand('e finger')

                ESX.ShowRGBNotification("info","שמת זין על השוק השחור")

                SetFakeWantedLevel(5)

                for i = 1, #npcs, 1 do

                    if(DoesEntityExist(npcs[i])) then

                        StopCurrentPlayingAmbientSpeech(npcs[i])

                        PlayAmbientSpeech1(npcs[i], "Generic_Insult_High", "Speech_Params_Force")

                        TaskAimGunAtEntity(npcs[i],PlayerPedId(),4000,false)

                    end

                end



                local explosiondict = 'cut_finale1'

                while not HasNamedPtfxAssetLoaded(explosiondict) do

                    RequestNamedPtfxAsset(explosiondict)

                    Wait(50)

                end



                Wait(4000)

                UseParticleFxAssetNextCall(explosiondict)

                local playerCoords = GetEntityCoords(PlayerPedId())

				StartParticleFxNonLoopedAtCoord("cs_finale1_car_explosion", playerCoords.x,playerCoords.y,playerCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false)

                PlaySoundFromCoord(-1, "External_Explosion", playerCoords.x,playerCoords.y,playerCoords.z, "Methamphetamine_Job_Sounds", 0, 1.0, 0)

                SetPedToRagdoll(PlayerPedId(),5000,5000,0,false,false,false,false)

                StartScreenEffect('DeathFailOut', 0, false)

                PlaySoundFrontend(-1, "MP_Flash", "WastedSounds", 1)

                StopCurrentPlayingAmbientSpeech(npcs[1])

                PlayAmbientSpeech1(npcs[1], "KILLED_ALL", "Speech_Params_Force")

                if(not IsPedInAnyVehicle(PlayerPedId(),false)) then

                    CreateThread(function()

                        SetTimeScale(0.2)

                        Wait(2000)

                        SetTimeScale(0.5)

                        Wait(400)

                        SetTimeScale(0.7)

                        Wait(200)

                        SetTimeScale(1.0)

                    end)

                end

                Wait(5000)

                for i = 1, #npcs, 1 do

                    if(DoesEntityExist(npcs[i])) then

                        ClearPedTasksImmediately(npcs[i])

                    end

                end

                ESX.ShowRGBNotification("job","סתםםםםםםםםםםםםםםםםםם אתה לא באמת מת יא אההבבבבבבבבלל")

                SetFakeWantedLevel(0)

                RemoveNamedPtfxAsset(explosiondict)

                StopScreenEffect('DeathFailOut')

            end)



        elseif data.current.value == 'IllegalPawn' then

            menu.close()

            TriggerEvent('OpeINVShop',"illegal")

        elseif data.current.value == 'RepairWeapon' then

            if(IsPedArmed(PlayerPedId(),4)) then

                TriggerServerEvent("gi-grangeillegal:Repair")

                StopCurrentPlayingAmbientSpeech(npcs[1])

                PlayAmbientSpeech1(npcs[1], "PURCHASE_ONLINE", "Speech_Params_Force")

            else

                ESX.ShowHDNotification("תיקון נשק","אתה חייב להחזיק את הנשק ביד","error")

            end

        elseif data.current.value == 'ShowCops' then

            if(not lastscout or (GetTimeDifference(GetGameTimer(), lastscout) > 600000)) then

                TriggerServerEvent('gi-grangeillegal:copcount')

                StopCurrentPlayingAmbientSpeech(npcs[1])

                PlayAmbientSpeech1(npcs[1], "SPOT_POLICE", "Speech_Params_Force")

            else

                ESX.ShowNotification('אפשר לבצע את הפעולה הזאת פעם אחת כל 10 דקות')

            end

        elseif data.current.value == 'TutorialBlack' then

            menu.close()

            StopCurrentPlayingAmbientSpeech(npcs[1])

            PlayAmbientSpeech1(npcs[1], "SHOP_HOLDUP", "Speech_Params_Force")

            TutorialMenu()

        elseif data.current.value == 'WeedJob' then

            StopCurrentPlayingAmbientSpeech(npcs[1])

            PlayAmbientSpeech1(npcs[1], "SNIFFED_GASOLINE", "Speech_Params_Force")

            JobQuestion()

        elseif data.current.value == "Bounty" then

            BountyMenu()

        elseif data.current.value == 'SearchPlate' then





            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {

                title = "חיפוש מאגר רכבים",

            }, function(data2, menu2)

                local length = string.len(data2.value)

                if data2.value == nil or length < 2 or length > 13 then

                    ESX.ShowNotification("לוחית רישוי לא תקינה")

                    menu2.close()

                else



                    menu2.close()

                    ESX.TriggerServerCallback('gi-grangeillegal:getVehicleInfos', function(retrivedInfo)





                        if(retrivedInfo ~= false) then

                            local elements = {{label = retrivedInfo.plate}}

                    

                            if retrivedInfo.owner == nil then

                                table.insert(elements, {label = "לא נמצא בעלים של הרכב"})

                            else

                                table.insert(elements, {label = "Name: "..retrivedInfo.owner})

                            end

                    

                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {

                                title    = "פרטי רכב",

                                align    = 'top-left',

                                elements = elements

                            }, nil, function(data3, menu3)

                                menu3.close()

                            end)

                        end

                    end, data2.value)

                end

            end, function(data2, menu2)

                menu2.close()

            end)



        end

        

    end, function(data, menu)

        menu.close()

    end)





end







function JobQuestion()



    ESX.UI.Menu.Open(

		'default', GetCurrentResourceName(), 'JobMenu',

		{

			title    = "האם תרצה להיכנס לעבודת משלוחי סמים?",

			align    = 'middle',			

			elements = {

				{label = "כן אני רוצה", value = 'StartJob'},				

				{label = 'לא, אינעל סבתא שלכם', value = 'decline'},

			}

		},

		function(data, menu)

            ESX.UI.Menu.CloseAll()

			if data.current.value == 'StartJob' then

                --TriggerServerEvent('jobsystem:Job',"drugdelivery")

                Citizen.InvokeNative(0x7FDD1128, "gi-grangeillegal:DrugDealer")

            elseif data.current.value == 'decline' then

                ESX.ShowNotification('גם שלך')

            end



		end,

	function(data, menu)

		menu.close()

	end)





end











RegisterNetEvent('gi-grangescoutdone')

AddEventHandler('gi-grangescoutdone',function(count)



    if(count ~= 1) then

		TriggerEvent('chatMessage'," התצפיתנים שלנו גילו ^1"..count.."^0 שוטרים בעיר ")

        ESX.ShowHDNotification('דוח תצפית',"התצפיתנים שלנו גילו "..count.." שוטרים בעיר",'info')

	else

		TriggerEvent('chatMessage'," התצפיתנים שלנו גילו שוטר ^1אחד^0 בעיר ")

        ESX.ShowHDNotification('דוח תצפית',"התצפיתנים שלנו גילו שוטר אחד בעיר",'info')

	end

    lastscout=GetGameTimer()





end)

local lastpurchase



function AddShopsIllegalMenu()

    local elements = {}

    for key,v in pairs(Config.Weapons) do

        local item = v



        table.insert(elements, {

            label = '<span style="color:red"> ' .. ESX.GetWeaponLabel(item.weapon) .. '</span>: ₪' .. ESX.Math.GroupDigits(item.price) .. '',

            value = item.weapon,

            price = item.price,

            weaponid = key,

            hintImage = GetConvar("inventory:imagepath","nui://ox_inventory/web/images").."/"..item.weapon..".png"

        })

    end

    ESX.UI.Menu.CloseAll()

        

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'IllegalGuns', {

        title    = "תפריט נשקים",

        align    = 'top-left',

        elements = elements

    }, function(data, menu)

        if(not lastpurchase or (GetTimeDifference(GetGameTimer(), lastpurchase) > 5000)) then

            ESX.TriggerServerCallback('gi-grangeillegal:buyWeapon', function(bought, forceclose)

                lastpurchase = GetGameTimer()

                if bought then

                    DisplayBoughtScaleform(data.current.value, data.current.price)

                else

                    if(forceclose) then

                        menu.close()

                    end

                    PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)

                    StopCurrentPlayingAmbientSpeech(npcs[1])

                    PlayAmbientSpeech1(npcs[1], "HURRY_UP", "Speech_Params_Force")

                end

            end, data.current.weaponid)

        else

            ESX.ShowHDNotification("","נא להמתין בין כל קניית נשק","error")

            ESX.UI.Menu.CloseAll()

        end

        

    end, function(data, menu)

        menu.close()

        BlackMarketMainMenu()

    end)

end



function DisplayBoughtScaleform(weaponName, price)

	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	local sec = GetGameTimer() + 4000

	BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')

	PushScaleformMovieMethodParameterString("You bought ".. ESX.GetWeaponLabel(weaponName).." for ".. price .. "$")

	PushScaleformMovieMethodParameterString(ESX.GetWeaponLabel(weaponName))

	PushScaleformMovieMethodParameterInt(joaat(weaponName))

	PushScaleformMovieMethodParameterString('')

	PushScaleformMovieMethodParameterInt(100)

	EndScaleformMovieMethod()

	PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)

	CreateThread(function()

		while sec > GetGameTimer() do

			Wait(0)

			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)

		end

	end)

    CreateThread(function()

        local blackmarketnpc = npcs[1]

        if(DoesEntityExist(blackmarketnpc)) then

            GiveWeaponToPed(blackmarketnpc,joaat(weaponName),255,false,true)

            SetCurrentPedWeapon(blackmarketnpc,joaat(weaponName),true)

            StopCurrentPlayingAmbientSpeech(blackmarketnpc)

            PlayAmbientSpeech1(blackmarketnpc, "PURCHASE_ONLINE", "Speech_Params_Force")

            RequestAnimDict('mp_common')

            while not HasAnimDictLoaded('mp_common') do

                Wait(5)

            end

            TaskPlayAnim(blackmarketnpc,'mp_common', 'givetake1_a',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)

            RemoveAnimDict("mp_common")

            Wait(3000)

            RemoveAllPedWeapons(blackmarketnpc)

            RequestAnimDict("missfbi_s4mop")

            while not HasAnimDictLoaded("missfbi_s4mop") do

                Wait(1)

            end

            TaskPlayAnim(blackmarketnpc, "missfbi_s4mop" ,"guard_idle_a" ,8.0, 1, -1, 49, 0, false, false, false)

            RemoveAnimDict("missfbi_s4mop")

        end

    end)



end





function TutorialMenu()



    local elements = {}

    table.insert(elements, {label = 'הלבנת כסף שחור מתבצעת דרך משפחות פשע בלבד',     value = 'ABA'})

    table.insert(elements, {label = 'יש ליצור קשר איתם דרך הצאט האנונימי',     value = 'SABA'})

    table.insert(elements, {label = 'שימו לב שהם עובדים עם מילות קוד לרוב ,/anon הפקודה',     value = 'SAVTA'})

    table.insert(elements, {label = 'GPS על מנת להלבין יהלומים יש ללכת ליהלום אדום ב',     value = 'RABA'})

        

    ESX.UI.Menu.CloseAll()

        

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'BlackTUT', {

        title    = "מדריך הלבנה",

        align    = 'top-left',

        elements = elements

    }, function(data, menu)

                

    end, function(data, menu)

        menu.close()

        BlackMarketMainMenu()

    end)



end



local RampageRequested = false



local function Leaderboard()

    ESX.TriggerServerCallback("gi-grangeillegal:rampagetop10",function(leader)

        local elements = {}

        elements[#elements+1] = {unselectable = true, icon = "fa-solid fa-medal", title = "Rampage - טבלת מובילים", description = "ה 10 מובילים יופיעו כאן"}

        if(#leader > 0) then

            for k,v in pairs(leader) do

                elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = k..". "..v.playerName..', Score: <span style="color:red">'..v.score..(v.identifier == ESX.GetPlayerData().identifier and "(YOU) </span>" or "</span>")}

            end

        else

            elements[#elements+1] = {unselectable = true, icon = "fa-solid fa-circle-xmark", title = "אין מובילים כרגע"}

        end

        

        elements[#elements+1] = {icon = "fa-solid fa-arrow-right", title = "חזרה", value = "back"}

        ESX.OpenContext("right", elements, function(menu,element)

            if element.value == "back" then

                ESX.CloseContext()

                RampageMenu()

            end

        end, function(menu)

            ESX.CloseContext()

        end)

    end)

end



function RampageMenu()



    local elements = {}

    elements[#elements+1] = {unselectable = true, icon = "fa-solid fa-burst", title = "Rampage תפריט", description = "אנא אשר שאתה מוכן להתחיל"}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = "כדי להתחיל חייב נשק ביד שלך עם לפחות 10 כדורים"}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = "הארמור, מיקום, חיים שלך ישמרו ברגע שתתחיל ותקבל אותם בחזרה כשתסיים"}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = "כשאתה מת או מתרחק יותר מדי אתה מקבל רבייב ושיגור בחזרה לכאן"}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = '<span style="color:red">חל איסור להשתמש במערכת זו כדי להתחמק מסיטואציות העבריין יענש באיפוס אינוונטורי ובאן</span>'}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = 'יציאה מהשרת בזמן שאתה בתוך המלחמה תוציא הודעה לכל השרת ותגרום לעונש אוטומטי'}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = 'התחמושת של הנשק שלך לא יורדת כשאתה בפנים'}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = 'המטרה היא להנות ולאמן את עצמך בירי, אין פרסים, ככל שאתה הורג יותר אויבים ככה אתה מקבל יותר נקודות'}

    elements[#elements+1] = {unselectable = true, icon = "fas fa-tags", title = 'אין התרעות ירי למשטרה, אף אחד לא רואה אותך או את האפניסיז שיורים עליך'}

    elements[#elements+1] = {icon = "fa-solid fa-person-rifle", title = "התחל", value = "start"}

    elements[#elements+1] = {icon = "fa-solid fa-medal", title = "טבלת מובילים", value = "leaderboard"}

    elements[#elements+1] = {icon = "fa-solid fa-person-running", title = "אני פחדן אמאלההה", value = "leave"}

    ESX.OpenContext("right", elements, function(menu,element)

        if element.value == "start" then

            ESX.CloseContext()

            if(not Rampage) then

                CreateThread(function()

                    if(not RampageRequested) then

                        if(not exports.ox_inventory:getCurrentWeapon()) then

                            ESX.ShowRGBNotification("error",".אין לך נשק בידיים")

                            return

                        end

                        local startcoords = GetEntityCoords(PlayerPedId())

                        RampageRequested = true

                        StopCurrentPlayingAmbientSpeech(npcs[1])

                        PlayPedAmbientSpeechWithVoiceNative(npcs[1],"FIGHT","TREVOR_ANGRY","Speech_Params_Force",false)

                        ESX.ShowRGBNotification("success",".אנחנו מכניסים אותך עכשיו, נא להמתין 10 שניות",10000)

                        Wait(10000)

                        RampageRequested = false

                        if(IsPedCuffed(PlayerPedId())) then

                            ESX.ShowRGBNotification("error",".נאזקת, המלחמה לא התחילה")

                            return

                        end



                        if(IsEntityDead(PlayerPedId()) or LocalPlayer.state.down) then

                            ESX.ShowRGBNotification("error",".נהרגת, המלחמה לא התחילה")

                            return

                        end



                        if #(startcoords - GetEntityCoords(PlayerPedId())) > 5.0 then

                            ESX.ShowRGBNotification("error",".התרחקת יותר מדי, המלחמה לא התחילה")

                            return

                        end

                        

                        TriggerServerEvent("gi-grangeillegal:server:RequestRampage")

                    end

                end)

                

            end

        elseif element.value == "leaderboard" then

            ESX.CloseContext()

            Leaderboard()

        elseif element.value == "leave" then

            ESX.CloseContext()

        end

    end, function(menu)

        ESX.CloseContext()

    end)



    

end





RegisterNetEvent("gi-grangeillegal:client:StartRampage",function()
print("Starting Rampage")
    if(GetInvokingResource()) then return end
print("Passed invoking resource")
    if(Rampage) then return end
print("Passed already in rampage")
    Rampage = true

    local RampScore = 0

    RequestAnimDict("mp_suicide")

    while not HasAnimDictLoaded("mp_suicide") do

        Wait(50)

    end



    local oldped = PlayerPedId()

    local savehealth = GetEntityHealth(oldped)

    local savearmour = GetPedArmour(oldped)

    local savecoords = GetEntityCoords(oldped)

    local savelastshot = GlobalState.lastshot

    TaskPlayAnim(oldped,"mp_suicide","pill",3.0,3.0,3000,51,0.0,false,false,false)

    Wait(3000)

    StopAnimTask(oldped,'mp_suicide','pill',3.0)

    RemoveAnimDict("mp_suicide")

    DoScreenFadeOut(1500)

    while not IsScreenFadedOut() do

        Wait(50)

    end

    AnimpostfxPlay('Rampage', 0, true)

    local explosiondict = 'scr_indep_fireworks'

    RequestNamedPtfxAsset(explosiondict)

    while not HasNamedPtfxAssetLoaded(explosiondict) do

        Wait(50)

    end

    local bombmodel = joaat("h4_prop_h4_ld_bomb_01a")

    RequestModel(bombmodel)

    while not HasModelLoaded(bombmodel) do

        Wait(50)

    end



    local terroristModel = joaat("a_m_m_beach_01")

    if not HasModelLoaded(terroristModel) then

        RequestModel(terroristModel)

        while not HasModelLoaded(terroristModel) do

            Wait(0)

        end

    end



    while not LoadStream("RAMPAGE_STREAMING_BED_MASTER") do

        Wait(50)

    end



    local remotedict = "anim@mp_player_intmenu@key_fob@"



    local targetspawns = nil

    local targetmodels = {

        joaat("g_m_m_chicold_01"),

        joaat("g_m_y_lost_01"),

        joaat("g_m_y_lost_02"),

        joaat("g_m_y_mexgang_01"),

        joaat("mp_m_freemode_01"),

        joaat("player_two"),

        joaat("s_m_y_clown_01"),

        -- joaat("g_m_m_cartelgoons_01"),

        joaat("g_m_y_ballaorig_01"),

        joaat("g_m_y_famca_01"),

        joaat("s_m_y_cop_01"),

    }



    local jugmodel = joaat("u_m_y_juggernaut_01")



    RequestModel(jugmodel)



    for i = 1, #targetmodels, 1 do

        Wait(0)

        RequestModel(targetmodels[i])

    end



    local ahelimodel = joaat("buzzard")

    RequestModel(ahelimodel)

    while not HasModelLoaded(ahelimodel) do

        Wait(0)

    end



    -- local buzzardm = joaat("polbuzz2")

    -- RequestModel(buzzardm)

    -- while not HasModelLoaded(buzzardm) do

    --     Wait(0)

    -- end

    

    Wait(1000)

    DoScreenFadeIn(1500)

    while not IsScreenFadedIn() do

        Wait(50)

    end

    





    math.randomseed(GetGameTimer())



    local randommusic = math.random(1,5)

    if(randommusic == 1) then

        TriggerMusicEvent("RAMPAGE_1_OS")

        TriggerMusicEvent("TRV1_CHASE_BIKERS_RT")

    elseif randommusic == 2 then

        TriggerMusicEvent("RAMPAGE_1_OS")

        TriggerMusicEvent("TRV2_WING_RESTART")

    elseif randommusic == 3 then

        TriggerMusicEvent("RAMPAGE_1_OS")

        TriggerMusicEvent("CHN1_AFTER_GRENADE_RT")

    elseif randommusic == 4 then

        TriggerMusicEvent("RAMPAGE_1_START")

        TriggerMusicEvent("RAMPAGE_1_OS")

    elseif randommusic == 5 then

        TriggerMusicEvent("RAMPAGE_2_START")

        TriggerMusicEvent("RAMPAGE_2_OS")

    end

    ClearPedTasks(oldped)

    CreateThread(function()

        showScaleform("~r~Rampage Started~w~", "~r~Kill~w~ As many ~b~NPCS~w~ as you can!, Each ~r~kill~w~ restores your ~r~health~w~ and ~y~stamina~w~.", 10)

    end)



    

    local function PlayTrevorLine(speech,voice,speechparam)

        CreateThread(function()

            if not HasModelLoaded(joaat("player_two")) then

                RequestModel(joaat("player_two"))

                while not HasModelLoaded(joaat("player_two")) do

                    Wait(0)

                end

            end

            local pedCoords = GetEntityCoords(PlayerPedId())

            local hiddentrevor = CreatePed(1,joaat("player_two"),pedCoords.x,pedCoords.y,pedCoords.z,0.0,false,true)

            SetPedVoiceFull(hiddentrevor)

            SetEntityInvincible(hiddentrevor, true)

            SetEntityVisible(hiddentrevor, false)

            SetEntityCollision(hiddentrevor, false, false)

            SetEntityCompletelyDisableCollision(hiddentrevor, true, true)

            AttachEntityToEntity(hiddentrevor, PlayerPedId(), 0, 0.27, 0.0, 0.0, 0.5, 0.5, 180, false, false, false, true, 2, false)

            PlayPedAmbientSpeechWithVoiceNative(hiddentrevor,speech,voice,speechparam,false)

            Wait(5000)

            DeleteEntity(hiddentrevor)

        end)

    end





    PlayStreamFrontend()



    CreateThread(function()

        local dict = "anim@deathmatch_intros@2hcombat_mgmale"

        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do

            Citizen.Wait(0)

        end

        TaskPlayAnim(oldped, dict, "intro_male_mg_c", 8.0, 8.0, -1, 0, 0, false, false, false)

        PlayTrevorLine("SHOOTOUT_SPECIAL","trevor_angry","SPEECH_PARAMS_FORCE_SHOUTED")

        Wait(GetAnimDuration(dict,"intro_male_mg_c") * 1000)

        StopAnimTask(ped, dict,anim, 2.0);

        RemoveAnimDict(dict)

    end)

    TriggerEvent("gi-base:ForceCombatMode",true)

    SetPedUsingActionMode(PlayerPedId(),true,-1,"TREVOR_ACTION")

    AddRelationshipGroup("rampnemies")

    AddRelationshipGroup("AIRSUPPORT")

    SetRelationshipBetweenGroups(0, joaat("rampnemies"), joaat("rampnemies")) 

    SetRelationshipBetweenGroups(0, joaat("AIRSUPPORT"), joaat("PLAYER")) 

    SetRelationshipBetweenGroups(0, joaat("PLAYER"), joaat("AIRSUPPORT")) 

    SetRelationshipBetweenGroups(5, joaat("rampnemies"), joaat("AIRSUPPORT")) 

    SetRelationshipBetweenGroups(5, joaat("AIRSUPPORT"), joaat("rampnemies")) 

    SetRelationshipBetweenGroups(5, joaat("rampnemies"), joaat("PLAYER"))

    RequestScriptAudioBank('SCRIPT/RAMPAGE_01', 0)

    RequestScriptAudioBank('SCRIPT/RAMPAGE_02', 0)

	SetPedInfiniteAmmoClip(PlayerPedId(),true)

    SetPlayerWeaponDefenseModifier(PlayerId(),0.5)

    local airsupport = 0

    local targetpeds = {}

    local helicrew = {}

    local allies = {}



    local function Buzzard()

        if(airsupport < 2) then return end

        if(allies[1]) then return end

        airsupport = 0

        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(),0.0,-150.0,200.0)

        local buzzard = CreateVehicle(ahelimodel,coords.x,coords.y,coords.z,GetEntityHeading(PlayerPedId()),false,true)

        local pilot = CreatePedInsideVehicle(buzzard,1,targetmodels[4],-1,false,true)

        SetEntityHealth(pilot,200)

        SetPedArmour(pilot,75)

        SetPedDiesWhenInjured(pilot,true)

        SetPedCombatAbility(pilot,2)

        SetDriverAbility(pilot,1.0)

        SetPedCombatAttributes(pilot,1,true)

        SetPedCombatAttributes(pilot,3,false)

        SetPedCombatAttributes(pilot,5,true)

        SetPedCombatAttributes(pilot,13,true)

        SetPedCombatAttributes(pilot,42,true)

        SetPedCombatAttributes(pilot,50,true)

        SetPedCombatAttributes(pilot,52,true)

        SetPedCombatAttributes(pilot,53,true)

        SetPedCombatAttributes(pilot,55,true)

        SetPedCombatAttributes(pilot,56,true)

        SetPedCombatAttributes(pilot,58,true)

        SetPedCombatAttributes(pilot,87,true)

        SetPedIdRange(pilot,500.0)

        SetPedHearingRange(pilot,500.0)

        SetPedSeeingRange(pilot,500.0)

        SetPedTargetLossResponse(pilot,1)

        SetCanAttackFriendly(pilot,false,false)

        SetPedFiringPattern(pilot,joaat("FIRING_PATTERN_BURST_FIRE_MG"))

        SetPedShootRate(pilot,500)

        SetPedAlertness(pilot,3)

        SetPedRelationshipGroupHash(pilot, joaat("AIRSUPPORT"))

        DisableVehicleWeapon(true,joaat("VEHICLE_WEAPON_SPACE_ROCKET"),buzzard,pilot)

        SetPedKeepTask(pilot,true)

        SetPedSphereDefensiveArea(pilot, savecoords.x,savecoords.y,savecoords.z, 300.0, true, true);

        TaskCombatHatedTargetsInArea(pilot,savecoords.x,savecoords.y,savecoords.z,300.0,true)

        TaskVehicleDriveToCoord(pilot, buzzard,savecoords.x,savecoords.y,savecoords.z, 150.0, 0, ahelimodel, 262144, 15.0, -1.0) 

        SetPlaneTurbulenceMultiplier(buzzard, 0.0)

        SetHeliTurbulenceScalar(buzzard,0.0)

        PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Trevor", true)

        ESX.ShowAdvancedNotification("Air Support", "", "~r~Airsupport~w~ Incoming. (For~y~ 90 ~w~Seconds)", "CHAR_MP_MERRYWEATHER")

        allies[1] = pilot

        allies[2] = buzzard

        for i = 1, #targetpeds, 1 do

            if(DoesEntityExist(targetpeds[i])) then

                RegisterTarget(pilot,targetpeds[i])

            end

        end



        Citizen.SetTimeout(70000,function()

            if(DoesEntityExist(allies[1]) and allies[1] == pilot) then

                DeleteEntity(allies[1])

                DeleteEntity(allies[2])

            end

            allies = {}

        end)

        

    end



    local function SpawnBoss()

        airsupport+=1

        if(airsupport >= 2) then

            PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_FRANKLIN", true)

            ESX.ShowAdvancedNotification("Air Support", "", "~r~Airsupport~w~ Incoming.", "CHAR_MP_MERRYWEATHER")

            ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to Call ~r~Airsupport~w~")

        end

        CreateThread(function()

            ESX.ShowHDNotification("בוס בדרך","בוס נוחת באיזור שלך","warning")

            PlaySoundFrontend(-1, "RAMPAGE_PASSED_MASTER", 0, 1)

            local coords = GetEntityCoords(PlayerPedId())

            local height = 300

            local radius = 125

            local mathradiusx = math.random(-radius, radius)

            local mathradiusy = math.random(-radius, radius)

            if(mathradiusx < 100 and mathradiusx > 0) then

                mathradiusx = 100

            end



            if(mathradiusy > -100 and mathradiusy < 0) then

                mathradiusy = -100

            end





            if(mathradiusy < 100 and mathradiusy > 0) then

                mathradiusy = 100

            end



            if(mathradiusy > -100 and mathradiusy < 0) then

                mathradiusy = -100

            end





            local x = coords.x + mathradiusx

            local y = coords.y + mathradiusy



            local foundSafeCoords, safeCoords = GetSafeCoordForPed(x, y, coords.z, false , 16)



            if not foundSafeCoords then 



                local safeZ = 0





                repeat

                    Wait(500)

                    local onGround, safeZ = GetGroundZFor_3dCoord(x, y,999.0,true)

                    if not onGround then

                        safeZ = safeZ + 0.1

                    end



                until onGround



                



                safeCoords = vector3(x, y, safeZ)

            end

            local walkset = "anim_group_move_ballistic"

            RequestAnimSet(walkset)

            while not HasAnimSetLoaded(walkset) do

                Citizen.Wait(1)

            end 

            PlayTrevorLine("KILLED_ALL","trevor_angry","SPEECH_PARAMS_FORCE_SHOUTED")

            local enemyPed = CreatePed(4 , jugmodel, safeCoords.x, safeCoords.y, safeCoords.z + height, math.random(360) , false, true)

    

            FreezeEntityPosition(enemyPed,true)

            SetPedMovementClipset(enemyPed, walkset, 0.2)

            RemoveAnimSet(walkset)

            SetPedCombatAttributes(enemyPed, 0, true)

            SetPedCombatAttributes(enemyPed, 1, true)

            SetPedCombatAttributes(enemyPed, 2, true)

            SetPedCombatAttributes(enemyPed, 3, true)

            SetPedCombatAttributes(enemyPed, 5, true) --[[ BF_CanFightArmedPedsWhenNotArmed ]]

            SetPedCombatAttributes(enemyPed, 38, true)

            SetPedCombatAttributes(enemyPed, 42, true)

            SetPedCombatAttributes(enemyPed, 46, true) --[[ BF_AlwaysFight ]]

            SetPedFleeAttributes(enemyPed, 0, true) --[[ allows/disallows the ped to flee from a threat i think]]

            SetPedPathCanUseLadders(enemyPed,true)

            SetPedDiesInWater(enemyPed, false)

            SetPedPathCanUseClimbovers(enemyPed,true)

            SetPedSeeingRange(enemyPed, 100.0)

            SetPedHearingRange(enemyPed, 100.0)

            SetPedRelationshipGroupHash(enemyPed, joaat("rampnemies")) 

            SetPedAsEnemy(enemyPed,true)

            SetPedDropsWeaponsWhenDead(enemyPed, false)

            SetBlockingOfNonTemporaryEvents(enemyPed,true)

            SetPedAccuracy(enemyPed, 85)

            SetPedArmour(enemyPed,300)

            SetPedSuffersCriticalHits(enemyPed,false)

            SetRagdollBlockingFlags(enemyPed,1)

           

            SetPedFiringPattern(enemyPed,joaat("FIRING_PATTERN_BURST_FIRE"))

    

            local weapons = {

                "WEAPON_MG",

                "WEAPON_COMBATMG",

            }

    

            local weapon = joaat(weapons[math.random(1,#weapons)])

    

            GiveWeaponToPed(enemyPed, weapon, 9999, false, true)

            SetPedAlertness(enemyPed,3)

            RegisterTarget(enemyPed,PlayerPedId())

            if(DoesEntityExist(allies[1])) then

                RegisterTarget(enemyPed,allies[1])

            end

            SetPedHighlyPerceptive(enemyPed,true)

            SetEntityProofs(enemyPed,false,false,true,true,false,false,false,false)



            

            local buzzard = CreateVehicle(buzzardm,safeCoords.x,safeCoords.y,safeCoords.z + height,math.random(360),false,true)

            local pilot = CreatePedInsideVehicle(buzzard,21,jugmodel,-1,false,true)

            SetEntityInvincible(buzzard,true)

            SetEntityInvincible(pilot,true)

            SetTaskVehicleGotoPlaneMinHeightAboveTerrain(buzzard,0.0)

            SetBlockingOfNonTemporaryEvents(pilot,true)

            FreezeEntityPosition(enemyPed,false)

            SetPedDiesWhenInjured(enemyPed,true)

            SetPedIntoVehicle(enemyPed,buzzard,1)

            TaskHeliMission(pilot, buzzard, 0, 0, safeCoords.x,safeCoords.y,safeCoords.z, 4, 20.0, -1.0, -1.0, 10, 10, 5.0, 0);    

            table.insert(targetpeds,enemyPed)

            table.insert(helicrew,buzzard)

            table.insert(helicrew,pilot)

    

            while GetEntityHeightAboveGround(buzzard) > 40.0 do

                Wait(500)

            end

            SetTaskVehicleGotoPlaneMinHeightAboveTerrain(buzzard,40.0)

            SetEntityRotation(buzzard,0.0,0.0,0.0,0.0,false)

            ClearPedTasks(pilot)

            SetBlockingOfNonTemporaryEvents(enemyPed,false)

            SetVehicleMaxSpeed(buzzard,0.1)

            TaskRappelFromHeli(enemyPed, 0.0)

            while IsPedInAnyVehicle(enemyPed) do

                Wait(500)

            end

            Wait(10000)

            SetEntityInvincible(enemyPed,false)

            ResetPedRagdollTimer(enemyPed)

            TaskCombatPed(enemyPed,PlayerPedId(),0,16)

            SetVehicleMaxSpeed(buzzard,0.0)

            TaskVehicleDriveToCoord(pilot, buzzard,0.0,0.0,0.0, 50.0, 0, buzzardm , 262144, 15.0, -1.0) 

            Wait(15000)

            for k,v in pairs(helicrew) do        

                if(DoesEntityExist(v)) then

                    DeleteEntity(v)

                end

            end

            helicrew = {}

        end)

    end



    local Terrorists = {}



    local function SpawnTerrorist()

        local coords = GetEntityCoords(PlayerPedId())

        local height = 300

        local radius = 125

        local mathradiusx = math.random(-radius, radius)

        local mathradiusy = math.random(-radius, radius)

        if(mathradiusx < 100 and mathradiusx > 0) then

            mathradiusx = 100

        end



        if(mathradiusy > -100 and mathradiusy < 0) then

            mathradiusy = -100

        end





        if(mathradiusy < 100 and mathradiusy > 0) then

            mathradiusy = 100

        end



        if(mathradiusy > -100 and mathradiusy < 0) then

            mathradiusy = -100

        end





        local x = coords.x + mathradiusx

        local y = coords.y + mathradiusy



        local foundSafeCoords, safeCoords = GetSafeCoordForPed(x, y, coords.z, false , 16)



        if not foundSafeCoords then 



            local safeZ = 0





            repeat

                Wait(500)

                local onGround, safeZ = GetGroundZFor_3dCoord(x, y,999.0,true)

                if not onGround then

                    safeZ = safeZ + 0.1

                end



            until onGround



            



            safeCoords = vector3(x, y, safeZ)

        end

        

        local enemyPed = CreatePed(4 , terroristModel, safeCoords.x, safeCoords.y, safeCoords.z + height, math.random(360) , false, true)

        SetPedCombatAttributes(enemyPed, 0, true)

        SetPedCombatAttributes(enemyPed, 1, true)

        SetPedCombatAttributes(enemyPed, 2, true)

        SetPedCombatAttributes(enemyPed, 3, true)

        SetPedCombatAttributes(enemyPed, 5, true) --[[ BF_CanFightArmedPedsWhenNotArmed ]]

        SetPedCombatAttributes(enemyPed, 38, true)

        SetPedCombatAttributes(enemyPed, 42, true)

        SetPedCombatAttributes(enemyPed, 46, true) --[[ BF_AlwaysFight ]]

        SetPedFleeAttributes(enemyPed, 0, true) --[[ allows/disallows the ped to flee from a threat i think]]

        SetPedPathCanUseLadders(enemyPed,true)

        SetPedDiesInWater(enemyPed, false)

        SetPedPathCanUseClimbovers(enemyPed,true)

        SetPedSeeingRange(enemyPed, 100.0)

        SetPedHearingRange(enemyPed, 100.0)

        SetPedRelationshipGroupHash(enemyPed, joaat("rampnemies")) 

        SetPedAsEnemy(enemyPed,true)

        SetPedDropsWeaponsWhenDead(enemyPed, false)

        SetBlockingOfNonTemporaryEvents(enemyPed,true)

        SetPedArmour(enemyPed,35)

        SetPedSuffersCriticalHits(enemyPed,false)

        SetRagdollBlockingFlags(enemyPed,1)

        SetRagdollBlockingFlags(enemyPed,2)

        SetRagdollBlockingFlags(enemyPed,4)

        Terrorists[enemyPed] = true

        SetPedAlertness(enemyPed,3)

        RegisterTarget(enemyPed,PlayerPedId())

        SetPedHighlyPerceptive(enemyPed,true)

        SetEntityProofs(enemyPed,false,false,false,true,false,false,false,false)

        TaskGoToEntity(enemyPed,PlayerPedId(),-1,99999999,4.0,1073741824,0)

        table.insert(targetpeds,enemyPed)

        local bomb = CreateObject(bombmodel,safeCoords.x, safeCoords.y, safeCoords.z + height,false,true,false)

        SetEntityLodDist(bomb,150)

        SetEntityCollision(bomb,false,false)

        SetEntityCompletelyDisableCollision(bomb,true,false)

        SetEntityMaxHealth(bomb,400)

        SetEntityHealth(bomb,GetEntityMaxHealth(bomb))

        AttachEntityToEntity(bomb,enemyPed,11816,0.0,0.3,0.3,180.0,0.0,0.0,false,false,false,true,2,true)

        

    end



    local function SuicideBomb(terrorist)

        if not Terrorists[terrorist] then return end

        Terrorists[terrorist] = nil

        CreateThread(function()

            ClearPedTasksImmediately(terrorist)

            SetBlockingOfNonTemporaryEvents(terrorist,true)

            TaskPlayAnim(terrorist, remotedict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)

            PlayPedAmbientSpeechWithVoiceNative(terrorist,"EXPLOSION_IS_IMMINENT","PACKIE","SPEECH_PARAMS_FORCE_SHOUTED",false)

            local terroristcoords = GetEntityCoords(terrorist)

            Wait(50)

            TriggerEvent('InteractSound_CL:PlayOnOne', 'selfd', 0.4)

            Wait(1500)

            

            local bomb = GetClosestObjectOfType(terroristcoords.x,terroristcoords.y,terroristcoords.z,5.0,bombmodel,true,false,false)

            if(DoesEntityExist(bomb)) then

                DeleteEntity(bomb)

            end

            if not Rampage or not DoesEntityExist(terrorist) or IsEntityDead(terrorist) then return end

            PlaySoundFromCoord(-1, "External_Explosion", terroristcoords.x,terroristcoords.y,terroristcoords.z, "Methamphetamine_Job_Sounds", 0, 1.0, 0)

            DeletePed(terrorist)

            UseParticleFxAssetNextCall(explosiondict)

			StartParticleFxNonLoopedAtCoord("cs_finale1_car_explosion", terroristcoords.x,terroristcoords.y,terroristcoords.z, 0.0, 0.0, 0.0, 5.0, false, false, false)

            local allpeds = GetGamePool("CPed")

            for i = 1,#allpeds, 1 do

                if(DoesEntityExist(allpeds[i]) and not IsEntityPositionFrozen(allpeds[i])) then

                    if #(GetEntityCoords(allpeds[i]) - terroristcoords) <= 8.0 then

                        ApplyForceToEntity(allpeds[i], 1, 4340.0, 3.0, 3330.0, 1.0, 0.0, 0.0, 1, false, true, false, false)

                        ApplyPedDamagePack(allpeds[i], "Fall", 100, 100)

                    end

                end

            end

        end)

    end



    local bombhandler = AddEventHandler('entityDamaged', function(victim, culprit, weapon, baseDamage)

        if GetEntityModel(victim) == bombmodel then

            if(GetEntityHealth(victim) <= 0) then

                SuicideBomb(GetEntityAttachedTo(victim))

            end

        end

    end)

    



    local function SpawnNpcs()

        CreateThread(function()

            if(not Rampage) then return end

            local coords = GetEntityCoords(PlayerPedId())

            local radius = 100

            

            local NPCCount = 8



            if(RampScore > 15) then

                NPCCount = 10

            end



            if(RampScore > 25) then

                NPCCount = 13

            end





            for i = 1, NPCCount, 1 do

                if(Rampage) then

                    if(#targetpeds >= Config.MaxRampagePeds) then break end

        

                    local mathradiusx = math.random(-radius, radius)

                    local mathradiusy = math.random(-radius, radius)

                    if(mathradiusx < 100 and mathradiusx > 0) then

                        mathradiusx = 100

                    end

        

                    if(mathradiusy > -100 and mathradiusy < 0) then

                        mathradiusy = -100

                    end

        

        

                    if(mathradiusy < 100 and mathradiusy > 0) then

                        mathradiusy = 100

                    end

        

                    if(mathradiusy > -100 and mathradiusy < 0) then

                        mathradiusy = -100

                    end

        

        

                    local x = coords.x + mathradiusx

                    local y = coords.y + mathradiusy

        

                    local foundSafeCoords, safeCoords = GetSafeCoordForPed(x, y, coords.z, false, 16)



                    if not foundSafeCoords then 

                        local safeZ = 999.0

                        local attempts = 0



                        repeat

                            Wait(500)  -- Wait for 500 ms before each check

                            local onGround, newZ = GetGroundZFor_3dCoord(x, y, 999.0, true)

                            if onGround then

                                safeZ = newZ

                            else

                                -- If ground is not found, try lowering the Z gradually

                                safeZ -= 10

                            end

                            attempts = attempts + 1

                        until onGround or attempts > 10  -- Avoid infinite loops



                        if onGround then

                            safeCoords = vector3(x, y, safeZ)

                        end

                    end

        

                    local model = targetmodels[math.random(1,#targetmodels)]

                    local enemyPed = CreatePed(4 , model, safeCoords.x, safeCoords.y, safeCoords.z, math.random(360) , false, true)

        

        

                    SetPedCombatAttributes(enemyPed, 0, true)

                    SetPedCombatAttributes(enemyPed, 1, true)

                    SetPedCombatAttributes(enemyPed, 2, true)

                    SetPedCombatAttributes(enemyPed, 3, true)

                    SetPedCombatAttributes(enemyPed, 5, true)

                    SetPedCombatAttributes(enemyPed, 38, true)

                    SetPedCombatAttributes(enemyPed, 42, true)

                    SetPedCombatAttributes(enemyPed, 46, true)

                    SetPedFleeAttributes(enemyPed, 0, true)

                    SetPedPathCanUseLadders(enemyPed,true)

                    SetPedDiesInWater(enemyPed, false)

                    SetPedPathPreferToAvoidWater(enemyPed,false)

                    SetPedDiesWhenInjured(enemyPed,true)

                    SetPedPathCanUseClimbovers(enemyPed,true)

                    SetPedSeeingRange(enemyPed, 70.0)

                    SetPedHearingRange(enemyPed, 70.0)

                    SetPedFiringPattern(enemyPed,joaat("FIRING_PATTERN_BURST_FIRE"))

                    SetPedRelationshipGroupHash(enemyPed, joaat("rampnemies")) 

                    SetPedAsEnemy(enemyPed,true)

                    SetPedDropsWeaponsWhenDead(enemyPed, false)

                    SetEntityProofs(enemyPed,false,false,false,true,false,false,false,false)

        

                    if(model == joaat("mp_m_freemode_01")) then

                        local face1 = 0

                        SetPedComponentVariation(enemyPed, 0, face1, 0, 0)

                        SetPedHeadBlendData(enemyPed, face1, face1, face1, 0, 0, 0, 1.0, 1.0, 1.0, true)

                        SetPedComponentVariation(enemyPed, 2, 13, 1, 2)

                        SetPedHairColor(enemyPed, 13, 10)

                        SetPedComponentVariation(enemyPed, 3, 11, 0, 0)

                        SetPedComponentVariation(enemyPed, 4, 83, 0, 0)

                        SetPedComponentVariation(enemyPed, 6, 65, 0, 0)

                        SetPedComponentVariation(enemyPed, 8, 161, 0, 0)

                        SetPedComponentVariation(enemyPed, 9, 0, 0, 0)

                        SetPedComponentVariation(enemyPed, 10, 82, 0, 0)

                        SetPedComponentVariation(enemyPed, 11, 6, 0, 0)

                        SetPedPropIndex(enemyPed,0,1,0,2)

                        SetPedPropIndex(enemyPed,1,5,1,2)

                        SetPedCanLosePropsOnDamage(enemyPed,false,0)

                    end

        

                    SetPedAccuracy(enemyPed, 55)

        

                    local weapons = {

                        "WEAPON_MACHINEPISTOL",

                        "WEAPON_ASSAULTRIFLE",

                        "WEAPON_PISTOL",

                        "WEAPON_MICROSMG",

                        "WEAPON_SAWNOFFSHOTGUN"

                    }

        

                    local weapon = joaat(weapons[math.random(1,#weapons)])

        

                    GiveWeaponToPed(enemyPed, weapon, 2000, false, true)

                    RegisterTarget(enemyPed,PlayerPedId())

                    SetPedHighlyPerceptive(enemyPed,true)

                    TaskCombatPed(enemyPed,PlayerPedId(),0,16)

                    SetPedAlertness(enemyPed,3)

        

                    table.insert(targetpeds,enemyPed)

                else

                    break

                end

            end

        end)

    end



    local function updateScore(points)

        local previousScore = RampScore

        RampScore += points



        if(RampScore % 5 == 0) then

            PlaySoundFrontend(-1, "RAMPAGE_ROAR_MASTER", 0, true);

        end

    

        -- Check if crossing the BossScore threshold

        if math.floor(previousScore / Config.BossScore) < math.floor(RampScore / Config.BossScore) then

            SpawnBoss()

        end

    end







    ClearAreaOfVehicles(savecoords.x,savecoords.y,savecoords.z,500.0,false,false,false,false,false)

    ClearAreaOfPeds(savecoords.x,savecoords.y,savecoords.z, 500.0, false)

    while Rampage do

        Wait(0)

        local ped = PlayerPedId()

        if(not targetspawns or (GetTimeDifference(GetGameTimer(), targetspawns) > 30000)) then

            targetspawns = GetGameTimer()

            SpawnNpcs()

            SpawnTerrorist()

        end



        if(IsDisabledControlJustPressed(0,51)) then

            Buzzard()

        end



        if(allies[1]) then

            if(DoesEntityExist(allies[1])) then

                if(IsEntityDead(allies[1])) then

                    local expcoords = GetEntityCoords(allies[2])

                    UseParticleFxAssetNextCall(explosiondict)

                    StartParticleFxNonLoopedAtCoord("cs_finale1_car_explosion", expcoords.x,expcoords.y,expcoords.z, 0.0, 0.0, 0.0, 5.0, false, false, false)

                    PlaySoundFromCoord(-1, "External_Explosion", expcoords.x,expcoords.y,expcoords.z, "Methamphetamine_Job_Sounds", 0, 1.0, 0)

                    DeleteEntity(allies[1])

                    DeleteEntity(allies[2])

                    allies = {}

                else

                    local helipos = GetEntityCoords(allies[1])

                    DrawMarker(34, helipos.x,helipos.y,helipos.z + 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.7, 1.7, 2.2, 0, 255, 40, 255, false, false, 2, true, false, false, false)

                end

                

            else

                DeleteEntity(allies[1])

                DeleteEntity(allies[2])

                allies = {}

            end

        end

        local keystoRemove = {}

        for k,v in pairs(targetpeds) do

            local theped = v

           

            if(not DoesEntityExist(theped)) then

                table.insert(keystoRemove,k)

                -- table.remove(targetpeds,k)

            else

                local pos = GetEntityCoords(theped)

                if(Terrorists[theped]) then

                    if #(GetEntityCoords(PlayerPedId()) - pos) <= 2.5 then

                        SuicideBomb(theped)

                    end

                end

                DrawMarker((Terrorists[theped] and 42 or 21), pos.x,pos.y,pos.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 1.2, 255, 0, 0, 170, false, false, 2, true, false, false, false)

                if(IsEntityDead(theped) or IsPedFatallyInjured(theped)) then

                    local found,bone = GetPedLastDamageBone(theped)

                    if(found and (bone == 31086 or bone == 39317)) then

                        TriggerEvent('InteractSound_CL:PlayOnOne', 'headshot', 1.0)

                        updateScore(2)

                        

                    else

                        PlaySoundFrontend(-1, "RAMPAGE_KILLED_HEAD_SHOT_MASTER", 0, true)

                        updateScore(1)

                    end

                    if(Terrorists[theped]) then

                        local bomb = GetClosestObjectOfType(pos.x,pos.y,pos.z,3.0,bombmodel,true,false,false)

                        if(DoesEntityExist(bomb)) then

                            DeleteEntity(bomb)

                        end

                        Terrorists[theped] = nil

                    end

                    DeleteEntity(theped)

                    SetEntityHealth(ped,200.0)

                    RestorePlayerStamina(PlayerId(),1.0)

                    table.insert(keystoRemove,k)

                    -- table.remove(targetpeds,k)

                end

            end

        end



        if(#keystoRemove > 0) then

            table.sort(keystoRemove, function(a, b) return a > b end)



            if(#keystoRemove > 0) then

                for _, key in ipairs(keystoRemove) do

                    table.remove(targetpeds, key)

                end

            end

        end



        SetPlayerSprint(PlayerId(),true)

        HideHudComponentThisFrame(2)

        -------------------------------

        SetRandomVehicleDensityMultiplierThisFrame(0.0)

        SetVehicleDensityMultiplierThisFrame(0.0)

        DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)

        DisableControlAction(0, 23, true) -- Also 'enter'?

        DisableControlAction(0, 51, true) -- E Keybind

        DisableControlAction(1, 56, true) -- F9 Menu

        DisableControlAction(0, 166, true) -- F5 Menu

        DisableControlAction(0, 167, true) -- F6 Menu

        DisableControlAction(0, 170, true) -- F3 Menu

        DisableControlAction(0, 288, true) -- F1 Phone

        DisableControlAction(0, 289, true) -- F2 Inventory

        DisableControlAction(0, 303, true) -- U Injured

        if(LocalPlayer.state.invOpen) then

            exports.ox_inventory:closeInventory()

        end

        

        -- if(IsPedInAnyVehicle(ped,false)) then

        --     ClearPedTasksImmediately(ped)

        -- end



        drawTxt(0.92, 1.35, 1.0,1.0,0.4, "~r~Rampage~w~ Score: "..RampScore.."\nTotal Enemies: "..#targetpeds, 255, 255, 255, 255)        

        if(LocalPlayer.state.down or IsEntityDead(PlayerPedId()) or GetPlayerInvincible_2(PlayerId())) then

            Rampage = false

            Citizen.CreateThreadNow(function()

                showScaleform("~r~Rampage Over~w~", "You Died", 10)

            end) 

            break

        end



        local pedcoords = GetEntityCoords(ped)

        if #(pedcoords - savecoords) > 200.0 then

            Rampage = false

            Citizen.CreateThreadNow(function()

                showScaleform("~r~Rampage Over~w~", "You Walked Too Far Away from the blackmarket.", 10)

            end) 

            break

        end

    end



    for k,v in pairs(targetpeds) do

        if(DoesEntityExist(v)) then

            DeleteEntity(v)

        end

    end



    for k,v in pairs(helicrew) do

        if(DoesEntityExist(v)) then

            DeleteEntity(v)

        end

    end



    if(allies[1]) then

        if(DoesEntityExist(allies[1])) then

            DeleteEntity(allies[1])

            DeleteEntity(allies[2])

            allies = {}

        end

    end

    

    SetModelAsNoLongerNeeded(jugmodel)

   -- SetModelAsNoLongerNeeded(buzzardm)

    SetModelAsNoLongerNeeded(ahelimodel)

    SetModelAsNoLongerNeeded(bombmodel)

    SetModelAsNoLongerNeeded(terroristModel)

    RemoveNamedPtfxAsset(explosiondict)



    local objs = GetGamePool("CObject")

    for i = 1,#objs, 1 do

        if(GetEntityScript(objs[i]) == GetCurrentResourceName() and GetEntityModel(objs[i]) == bombmodel) then

            DeleteEntity(objs[i])

        end

    end



    for i = 1, #targetmodels, 1 do

        Wait(0)

        SetModelAsNoLongerNeeded(targetmodels[i])

    end



    TriggerMusicEvent("GLOBAL_KILL_MUSIC")

    ReleaseNamedScriptAudioBank('SCRIPT/RAMPAGE_01')

    ReleaseNamedScriptAudioBank('SCRIPT/RAMPAGE_02')

    StopStream()

    AnimpostfxStop("Rampage")

    Wait(500)

    for k,v in pairs(targetpeds) do

        if(DoesEntityExist(v)) then

            DeleteEntity(v)

        end

    end

    for k,v in pairs(helicrew) do

        if(DoesEntityExist(v)) then

            DeleteEntity(v)

        end

    end

    TriggerEvent("esx_ambulancejob:revive")

    TriggerEvent('ox_inventory:disarm', true)

    TriggerEvent("gi-base:ForceCombatMode",false)

    RemoveEventHandler(bombhandler)

    if(savecoords) then

        SetEntityCoords(PlayerPedId(),savecoords)

    end

    RemoveRelationshipGroup(joaat("rampnemies"))

    RemoveRelationshipGroup(joaat("AIRSUPPORT"))

    GlobalState.lastshot = savelastshot

    SetPlayerWeaponDefenseModifier(PlayerId(),0.0)

    SetPedInfiniteAmmoClip(PlayerPedId(),false)

    TriggerServerEvent("gi-grangeillegal:server:EndRampage",RampScore)

    PlaySoundFrontend(-1, "RAMPAGE_PASSED_MASTER", 0, true)

    SetPedUsingActionMode(PlayerPedId(),false,-1,"TREVOR_ACTION")

    Wait(2500)

    if(savearmour and savearmour > 0) then

        SetPedArmour(PlayerPedId(),savearmour)

        ESX.ShowRGBNotification("success","קיבלת ~b~"..savearmour.."~w~ ארמור בחזרה")

    end

    if(savehealth and savehealth > 101) then

        SetEntityHealth(PlayerPedId(),savehealth)

    end

end)



exports("InRampage",function()

    return Rampage

end)





function blackmarket()

    SendNUIMessage({

        action = "showUI",

    })

    SetNuiFocus(true, true)

end



RegisterNUICallback('close', function()

    SetNuiFocus(false, false)

end)



local function HideUI()

    SendNUIMessage({

        action = "hideUI",

    })

    SetNuiFocus(false, false)

end



RegisterNUICallback('action', function(data,cb)

    cb("ok")

    -- if #(vector3(NPC[1].x,NPC[1].y,NPC[1].z) - GetEntityCoords(PlayerPedId())) > 100 then

    --     return

    -- end

    local action = data.action

    if action == 'weapons' then

        HideUI()

        AddShopsIllegalMenu()

    elseif action == 'rampage' then

        HideUI()

        RampageMenu()

    elseif action == 'money_deposit' then

        HideUI()

        MoneyDeposit()

    elseif action == 'zain' then

        HideUI()

        CreateThread(function()

            

            ExecuteCommand('e finger')

            ESX.ShowRGBNotification("info","שמת זין על השוק השחור")

            SetFakeWantedLevel(5)

            for i = 1, #npcs, 1 do

                if(DoesEntityExist(npcs[i])) then

                    StopCurrentPlayingAmbientSpeech(npcs[i])

                    PlayAmbientSpeech1(npcs[i], "Generic_Insult_High", "Speech_Params_Force")

                    TaskAimGunAtEntity(npcs[i],PlayerPedId(),4000,false)

                end

            end



            local explosiondict = 'cut_finale1'

            while not HasNamedPtfxAssetLoaded(explosiondict) do

                RequestNamedPtfxAsset(explosiondict)

                Wait(50)

            end



            Wait(4000)

            UseParticleFxAssetNextCall(explosiondict)

            local playerCoords = GetEntityCoords(PlayerPedId())

            StartParticleFxNonLoopedAtCoord("cs_finale1_car_explosion", playerCoords.x,playerCoords.y,playerCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false)

            PlaySoundFromCoord(-1, "External_Explosion", playerCoords.x,playerCoords.y,playerCoords.z, "Methamphetamine_Job_Sounds", 0, 1.0, 0)

            SetPedToRagdoll(PlayerPedId(),5000,5000,0,false,false,false,false)

            StartScreenEffect('DeathFailOut', 0, false)

           
            PlaySoundFrontend(-1, "MP_Flash", "WastedSounds", 1)

            StopCurrentPlayingAmbientSpeech(npcs[1])

            PlayAmbientSpeech1(npcs[1], "KILLED_ALL", "Speech_Params_Force")

            if(not IsPedInAnyVehicle(PlayerPedId(),false)) then

                CreateThread(function()

                    SetTimeScale(0.2)

                    Wait(2000)

                    SetTimeScale(0.5)

                    Wait(400)

                    SetTimeScale(0.7)

                    Wait(200)

                    SetTimeScale(1.0)

                end)

            end

            Wait(5000)

            for i = 1, #npcs, 1 do

                if(DoesEntityExist(npcs[i])) then

                    ClearPedTasksImmediately(npcs[i])

                end

            end

            ESX.ShowRGBNotification("job","סתםםםםםםםםםםםםםםםםםם אתה לא באמת מת יא אההבבבבבבבבלל")

            SetFakeWantedLevel(0)

            RemoveNamedPtfxAsset(explosiondict)

            StopScreenEffect('DeathFailOut')

        end)



    elseif action == 'tools' then

        HideUI()

        TriggerEvent('OpeINVShop',"illegal")

    elseif action == 'repair' then

        HideUI()

        if(IsPedArmed(PlayerPedId(),4)) then

            TriggerServerEvent("gi-grangeillegal:Repair")

            StopCurrentPlayingAmbientSpeech(npcs[1])

            PlayAmbientSpeech1(npcs[1], "PURCHASE_ONLINE", "Speech_Params_Force")

        else

            ESX.ShowHDNotification("תיקון נשק","אתה חייב להחזיק את הנשק ביד","error")

        end

    elseif action == 'cops' then

        HideUI()

        if(not lastscout or (GetTimeDifference(GetGameTimer(), lastscout) > 600000)) then

            TriggerServerEvent('gi-grangeillegal:copcount')

            StopCurrentPlayingAmbientSpeech(npcs[1])

            PlayAmbientSpeech1(npcs[1], "SPOT_POLICE", "Speech_Params_Force")

        else

            ESX.ShowNotification('אפשר לבצע את הפעולה הזאת פעם אחת כל 10 דקות')

        end

    -- elseif action == 'TutorialBlack' then

    --     HideUI()

    --     StopCurrentPlayingAmbientSpeech(npcs[1])

    --     PlayAmbientSpeech1(npcs[1], "SHOP_HOLDUP", "Speech_Params_Force")

    --     TutorialMenu()

    elseif action == 'drugs' then

        HideUI()

        StopCurrentPlayingAmbientSpeech(npcs[1])

        PlayAmbientSpeech1(npcs[1], "SNIFFED_GASOLINE", "Speech_Params_Force")

        JobQuestion()

    elseif action == "bounty" then

        HideUI()

        BountyMenu()

    elseif action == 'license' then

        HideUI()



        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {

            title = "חיפוש מאגר רכבים",

        }, function(data2, menu2)

            local length = string.len(data2.value)

            if data2.value == nil or length < 2 or length > 13 then

                ESX.ShowNotification("לוחית רישוי לא תקינה")

                menu2.close()

            else



                menu2.close()

                ESX.TriggerServerCallback('gi-grangeillegal:getVehicleInfos', function(retrivedInfo)





                    if(retrivedInfo ~= false) then

                        local elements = {{label = retrivedInfo.plate}}

                

                        if retrivedInfo.owner == nil then

                            table.insert(elements, {label = "לא נמצא בעלים של הרכב"})

                        else

                            table.insert(elements, {label = "Name: "..retrivedInfo.owner})

                        end

                

                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {

                            title    = "פרטי רכב",

                            align    = 'top-left',

                            elements = elements

                        }, nil, function(data3, menu3)

                            menu3.close()

                        end)

                    end

                end, data2.value)

            end

        end, function(data2, menu2)

            menu2.close()

        end)



    end

end)



function MoneyDeposit()

    local inventory = exports.ox_inventory:GetPlayerItems()

    local price = 0

    local count = 0

    for k,v in pairs(inventory) do

        if(v.name == "p_moneybag") then

            if(v.metadata?.p_worth) then

                count +=1

                price += v.metadata?.p_worth

            end

        end

    end

    if price <= 0 then

        ESX.ShowRGBNotification('error',"!אין לך תיקי משא ומתן להפקיד")

        return

    end



    



    local alert = lib.alertDialog({

        header = 'הפקדת תיקי משא ומתן',

        content = string.format("אתה עומד לקבל ₪%s כסף על כל התיקים שלך \n\nסך הכל תיקים: %s", ESX.Math.GroupDigits(price), count),

        centered = true,

        cancel = true,

        labels = {

            confirm = "!כן, אני רוצה להפקיד אותם ולקבל את הכסף",

            cancel = "?לא רוצה להפקיד מה תעשה",

        }

    })

    if(alert == "confirm") then

        TriggerServerEvent("gi-grangeillegal:server:RequestBagDeposit")

    end

end



exports("MoneyDeposit", MoneyDeposit)



exports.ox_inventory:displayMetadata({

    p_worth = 'שווי תיק',

})