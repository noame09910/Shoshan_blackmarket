local buyCooldown = false

local function GetGunStock()
	local result = MySQL.Sync.fetchAll("SELECT `stock` FROM `blackmarket_stock` WHERE `product` = 'guns'", {})
	if(result and result[1]) then
		return result[1].stock
	else
		return 0
	end
end

local function GetWeaponById(id)
	for key,v in pairs(Config.Weapons) do
		if(id == key) then
			return v
		end
	end
	return nil

end

ESX.RegisterServerCallback('shoshanblackmarket:buyWeapon', function(source, cb, weaponID)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if(xPlayer) then

		if(#Config.Weapons == 0) then
			xPlayer.showRGBNotification("error","מכירת הנשקים מבוטלת")
			cb(false)
			return
		end

		if buyCooldown then
			xPlayer.showRGBNotification("error","נא להמתין בין כל קניית נשק")
			cb(false)
			return
		end

		local weapon = GetWeaponById(weaponID)
		if not weapon then
			xPlayer.showRGBNotification("error",".הנשק שביקשת לקנות לא קיים במערכת")
			cb(false)
			return
		end


		local price = weapon.price
		local weaponName = weapon.weapon

		
		if xPlayer.getMoney() >= price then

			if(not xPlayer.hasWeapon(weaponName)) then
				if(not xPlayer.canCarryItem(weaponName,1)) then
					xPlayer.showHDNotification("ERROR","אין לך מקום לסחוב את זה","error")
					return
				end
				buyCooldown = true
				Wait(math.random(100,180))
				if(GetGunStock() > 0) then
					MySQL.Sync.execute("UPDATE `blackmarket_stock` SET `stock` = stock - 1 WHERE `product` = 'guns'")
					xPlayer.removeMoney(price)
					xPlayer.addWeapon(weaponName, math.random(1,70))
					sendToDiscord(" קניית נשק בשוק שחור ",  "Player: ".. GetPlayerName(src).." [ "..src.." ]\nIdentifier: "..xPlayer.identifier.."\nWeapon: ".. weaponName.."\nPrice: "..ESX.Math.GroupDigits(price),65535)
					buyCooldown = false
					cb(true,true)
				else
					buyCooldown = false
					xPlayer.showHDNotification("ERROR","נגמר המלאי בשוק",'error')
					cb(false,true)
				end
			else
				xPlayer.showHDNotification("ERROR","יש לך כבר את הנשק הזה בידיים",'error')
				cb(false)
			end	
		else
			xPlayer.showHDNotification("ERROR","אין לך מספיק כסף לקנות את הנשק הזה","error")
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('shoshanblackmarket:getVehicleInfos', function(source, cb, plate)

	local xPlayer = ESX.GetPlayerFromId(source)

	if(not xPlayer) then
		return
	end

	if(xPlayer.getMoney() >= Config.Plateprice) then
		MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = ?', {
			plate
		}, function(result)
			local retrivedInfo = {plate = plate}

			if result[1] then
				MySQL.Async.fetchAll('SELECT name, firstname, lastname FROM users WHERE identifier = ?',  {
					result[1].owner
				}, function(result2)
					if result2[1] then
						retrivedInfo.owner = ('%s %s'):format(result2[1].firstname, result2[1].lastname)

						xPlayer.removeMoney(Config.Plateprice)
						xPlayer.showHDNotification('SUCCESS','<span style="color:green;">₪'..ESX.Math.GroupDigits(Config.Plateprice)..' שילמת','success')


						cb(retrivedInfo)
					else
						cb(retrivedInfo)
					end
				end)
			else
				cb(retrivedInfo)
			end
		end)
	else
		xPlayer.showHDNotification('ERROR','You Need <span style="color:green;">₪'..ESX.Math.GroupDigits(Config.Plateprice).."</span> To Do This",'error')
		cb(false)
	end
end)


RegisterNetEvent("shoshanblackmarket:Repair",function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if(not xPlayer) then
		return
	end

	local weapon = exports.ox_inventory:GetCurrentWeapon(src)
	if weapon then
		if(weapon.metadata.durability >= 100.0) then
			xPlayer.showHDNotification("error","הנשק שלך לא דורש תיקון")
			return
		end
		local weptype = "none"
		for k,v in pairs(Config.WeaponsTypes) do
			
			if(v.weaponName == weapon.name) then
				weptype = v.WeaponType
				break
			end
		end

		if(weptype == "none") then
			xPlayer.showHDNotification("Weapon Type Unknown","סוג הנשק אינו מוגדר במערכת","error")
			return
		end

		if(not Config.RepairCost[weptype]) then
			xPlayer.showHDNotification("Weapon Type Unknown","סוג הנשק אינו מוגדר במערכת","error")
			return
		end

		local money = xPlayer.getMoney()

		if(money < Config.RepairCost[weptype]) then
			TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = ESX.Math.GroupDigits(Config.RepairCost[weptype]).." :אין לך מספיק כסף מזומן לבצע פעולה זו, הנשק שלך דורש סך הכל" })
			return
		end

		xPlayer.removeMoney(Config.RepairCost[weptype])
		xPlayer.showHDNotification("תיקון נשק","תיקנת את הנשק שלך תמורת ₪"..ESX.Math.GroupDigits(Config.RepairCost[weptype]))
		exports.ox_inventory:SetDurability(src, weapon.slot, 100)
	else
		xPlayer.showHDNotification("לא נמצא נשק","לא נמצא נשק בידיים שלך, יש לבחור אותו לפני שמבצעים פעולה זו","error")
	end
end)

RegisterNetEvent('shoshanblackmarket:copcount',function()

	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if(not xPlayer) then
		return
	end	

	local money = xPlayer.getMoney()


	if(money < Config.CPrice) then
		xPlayer.showRGBNotification('error',"אין לך מספיק מזומן לבצע פעולה זו")
		TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "אין לך מספיק כסף לבצע פעולה זו" })
		return
	end

	local count = 0


	for k,v in pairs(ESX.GetExtendedPlayers("job", "police")) do
		if(v.job.name == "police") then
			count = count + 1
		end
	end

	xPlayer.removeMoney(Config.CPrice)
	sendToDiscord("סריקת שוטרים",  "שם השחקן: "..GetPlayerName(src).." [ "..src.." ]\nidentifier: "..xPlayer.identifier,65535)
	xPlayer.triggerEvent('gi-grangescoutdone',count)
end)


local PreventLicenses = {}

RegisterNetEvent('shoshanblackmarket:DrugDealer')
AddEventHandler('shoshanblackmarket:DrugDealer',function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if(not xPlayer) then
		return
	end

	if(xPlayer.job.name == "police" or xPlayer.job.name == "offpolice") then
		xPlayer.showRGBNotification("error","?אתה רוצה להיות חשישניק כשאתה כבר שוטר אה")
		return
	end

	if(xPlayer.job.name == "drugdelivery") then
		xPlayer.showRGBNotification("error","אתה כבר עובד כשליח סמים")
		return
	end

	local license = GetPlayerIdentifierByType(xPlayer.source,"license")

	if(PreventLicenses[license]) then
		xPlayer.showRGBNotification("error","אין לך אפשרות לקחת עבודת סמים יותר")
		return
	end
	
	local jobsoccupied = MySQL.Sync.fetchAll("SELECT job FROM `users` WHERE `job` = 'drugdelivery'", {})
	local MaxDealers = 45
	if(#jobsoccupied <= MaxDealers) then
		PreventLicenses[license] = true
		xPlayer.setJob("drugdelivery",0)
		xPlayer.showHDNotification('Black Market',"התקבלת לעבודת סמים",'info')
		exports['es_extended']:SavePlayer(xPlayer.source)
	else
		xPlayer.showHDNotification('Black Market',"יש למעלה מ "..MaxDealers.." עובדי סמים לכן אי אפשר לגייס אותך",'error')
	end
end)


function sendToDiscord(tit,msg,colr)
    PerformHttpRequest("https://discord.com/api/webhooks/1239548232330383432/IQ76eqfnygG6IHdo6r4hkI-4LZtptg3IkOtGAs9S-x-5_3k2fnfIlzkQK3emWKBixM2V", function(a,b,c)end, "POST", json.encode({embeds={{title=tit,description=msg:gsub("%^%d",""),color=colr,}}}), {["Content-Type"]="application/json"})
end

local PrepareBounty = {}

RegisterNetEvent('shoshanblackmarket:SV_BountyStart')
AddEventHandler('shoshanblackmarket:SV_BountyStart',function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if(not xPlayer) then
		return
	end

	local license = GetPlayerIdentifierByType(src,"license")

	if(not license) then
		TriggerClientEvent('chatMessage',src,"^3Bounty^0: תקלה, לא מצאנו את משתמש הרוקסטר שלך")
		return
	end

	if(GetPlayerRoutingBucket(src) ~= 0) then
		xPlayer.showRGBNotification("error",".אתה נמצא בעולם אחר ולא יכול להתחיל באונטי כרגע")
		return
	end

	local cops = 0

	for k,v in pairs(ESX.GetExtendedPlayers("job", "police")) do
		if(v.job.name == "police") then
			cops +=1
		end
	end

	-- if(cops < 4) then
	-- 	xPlayer.showRGBNotification("error","אין מספיק שוטרים בשרת, חייב 4 לפחות")
	-- 	return
	-- end

	MySQL.Async.fetchAll('SELECT `lastmission` FROM `bounty` WHERE identifier = ? AND DATEDIFF(NOW(), `lastmission`) < 2', {
		license
	}, function(result)
		if(result and result[1] and result[1].lastmission) then
			TriggerClientEvent('chatMessage',src,"^1כבר ביצעת משימה ב 48 שעות האחרונות")
			xPlayer.showRGBNotification("error",'כבר ביצעת משימה ב 48 שעות האחרונות')
		else
			PrepareBounty[src] = true
			TriggerClientEvent('shoshanblackmarket:BountyStart',src)
		end
	end)
end)

local function IsModelInConfig(model)
	for i = 1, #Config.PedModels, 1 do
		if(Config.PedModels[i] == model) then return true end
	end
	return false
end

local function IsWeaponInConfig(weapon)
	for i = 1, #Config.PedWeapons, 1 do
		if(Config.PedWeapons[i] == weapon) then return true end
	end
	return false
end

lib.callback.register('shoshanblackmarket:server:CreateBounty', function(source, model, weapon, coordindex)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end
	if not PrepareBounty[xPlayer.source] then return false end
    if not IsModelInConfig(model) then return false end
    if not IsWeaponInConfig(weapon) then return false end
	local coords = Config.Bounties[coordindex]
	if not coords then return false end
	PrepareBounty[xPlayer.source] = nil
	local timer = GetGameTimer()
    local ped = CreatePed(1,joaat(model),coords.x,coords.y,coords.z + 0.3,0.0,true,true)
    while not DoesEntityExist(ped) do
        Wait(0)
		if(GetGameTimer() - timer > 7000) then return false end
    end
	Entity(ped).state:set("SetNormalBounty",weapon,true)
	SetEntityIgnoreRequestControlFilter(ped,true)
	if(GetResourceState("el_bwh") == "started") then
		exports['el_bwh']:SetKnownArmedPed(ped)
	end	
	GiveWeaponToPed(ped,joaat(weapon),255,false,true)	
    return NetworkGetNetworkIdFromEntity(ped)
end)

local PlayersInRampage = {}

local lastprize = {}

local Restarting = false


AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining <= 300 then
		lastprize = {}
        if(not lockforrestart) then
	        Restarting = true
        end
    end
end)
AddEventHandler('txAdmin:events:skippedNextScheduledRestart', function(eventData)
    if(Restarting) then
        Restarting = false
    end
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function()
	lastprize = {}
end)


local function discordLogBounty(title, message)
	PerformHttpRequest("https://discord.com/api/webhooks/1239554836496908361/zNFQpyYxg4-ckdwWpdj_Ygx5iSIOo_Hfe_hsUN4c79i_3Vbw5qZs7Skji6-inusJoupd", function(err, text, headers) end, 'POST', json.encode({username = "Gamers-Israel Public Logs", embeds = {{["color"] = 6887408, ["author"] = {["name"] = title,["icon_url"] = "https://media.discordapp.net/attachments/576114034265554945/825701886417829908/gl-text-1.png?width=676&height=676"}, ["description"] = "".. message .."",["footer"] = {["text"] = "Gamers-Israel Public- "..os.date("%x %X %p"),["icon_url"] = "https://media.discordapp.net/attachments/576114034265554945/825701886417829908/gl-text-1.png?width=676&height=676",},}}, avatar_url = "https://media.discordapp.net/attachments/576114034265554945/825701886417829908/gl-text-1.png?width=676&height=676"}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('esx:playerDropped',function(source,reason)
	local src = source
	if(PlayersInRampage[src]) then
		TriggerClientEvent('chatMessage',-1,"^3Rampage: ^1"..GetPlayerName(src).." ["..src.."]^0 Combat Logged While in a ^3Rampage^0")
		PlayersInRampage[src] = nil
	end
	if(PrepareBounty[src]) then
		PrepareBounty[src] = nil
	end
	if(lastprize[src]) then
		local tdiff = os.difftime(GetGameTimer(), lastprize[src])
		lastprize[src] = nil
		if(Restarting) then
			return
		end
		if(tdiff < 120000) then
			local reason = reason

			if(not reason) then
				reason = "Undefined"
			end
			tdiff = tdiff / 1000
			
			TriggerClientEvent('chatMessage',-1,"^3Bounty: ^1"..GetPlayerName(src).." ["..src.."]^0 Combat Logged After Completing A ^3Bounty^0")
			local license = GetPlayerIdentifierByType(src,"license")
			local steam = GetPlayerIdentifierByType(src,"steam")

			if(not steam) then
				steam = "Undefined"
			end

			if(not license) then
				license = "Undefined"
			end

			discordLogBounty("Bounty Logs | חיסולים והאנטרים", "**"..GetPlayerName(src).. " ["..src.."]\nIdentifier: "..steam.."\nCombat Logged "..math.floor(tdiff).." Seconds After Bounty\nExit Reason: "..reason.."\nScript By Gamers-Israel**")
			MySQL.Async.execute("UPDATE `bounty` SET `prize` = 0 , `lastmission` = CURRENT_TIMESTAMP WHERE identifier = ?", {license}, function(rows)

			end)
		end
		
	end
end)

function BountyAlert(coords)
	local text = 'דיווח על חיסול'
    local data = {
        code = '10-67',
        default_priority = 'high', 
        coords = coords,
        job = 'police',
        text = text,
        type = 'alerts',
        blip_time = 2,
        blip = { 
            sprite = 303,
            colour = 1,
            scale = 0.9,
            text = 'Bounty',
            flashes = false,
            radius = 0,
        }
    }
    TriggerEvent('rcore_dispatch:server:sendAlert', data)
end

RegisterNetEvent('shoshanblackmarket:SV_BountySetPrize')
AddEventHandler('shoshanblackmarket:SV_BountySetPrize',function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if(not xPlayer) then
		return
	end
	local coords = xPlayer.getCoords(true)

	local license = GetPlayerIdentifierByType(src,"license")

	if(not license) then
		TriggerClientEvent('chatMessage',src,"^3Bounty^0: תקלה, לא מצאנו את משתמש הרוקסטר שלך")
		return
	end


	if(GetPlayerRoutingBucket(src) ~= 0) then
		xPlayer.showRGBNotification("error",".אתה נמצא בעולם אחר, הפרס לא התקבל")
		return
	end

	local prize = 1

	MySQL.Async.fetchAll('SELECT `lastmission` FROM `bounty` WHERE identifier = ? AND DATEDIFF(NOW(), `lastmission`) < 2', {
		license
	}, function(result)
		if(result and result[1] and result[1].lastmission) then
			TriggerClientEvent('chatMessage',src,"כבר עשית משימה ב 48 שעות האחרונות")
		else
			lastprize[src]=GetGameTimer()
			MySQL.Async.fetchAll('SELECT `lastmission` FROM `bounty` WHERE identifier = ?', {
				license
			}, function(result2)
				if result2[1] then
					MySQL.Async.execute("UPDATE `bounty` SET `prize` = @prize , `lastmission` = CURRENT_TIMESTAMP WHERE identifier = @identifier", {["@identifier"] = license, ['@prize'] = prize}, function(rows)
						if(rows == 1) then
							BountyAlert(coords)
							xPlayer.showHDNotification('Bounty',"הפרס מחכה לך בשוק השחור",'info')
						else
							xPlayer.showHDNotification('Bounty',"תקלה, המערכת לא הצליחה לרשום את הפרס שלך",'error')
						end
					end)
				else
					local length = os.date("%Y/%m/%d %X")
					MySQL.Async.execute('INSERT INTO `bounty` (prize, identifier, lastmission, `name`) VALUES (@prize, @identifier, @lastmission, @name)', {['@prize'] = prize, ['@identifier'] = license, ['@lastmission'] = length, ['@name'] = GetPlayerName(src)},function(rows)
						if(rows == 1) then
							BountyAlert(coords)
							xPlayer.showHDNotification('Bounty',"הפרס מחכה לך בשוק השחור",'info')
						else
							xPlayer.showHDNotification('Bounty',"תקלה, המערכת לא הצליחה לרשום את הפרס שלך",'error')
						end
					end)
				end
			end)
		end
	end)


end)


RegisterNetEvent('shoshanblackmarket:SV_ClaimPrize')
AddEventHandler('shoshanblackmarket:SV_ClaimPrize',function()
	local src = source

	Wait(math.random(500,1200))

	local xPlayer = ESX.GetPlayerFromId(src)

	if(not xPlayer) then
		return
	end



	local license = GetPlayerIdentifierByType(src,"license")

	if(not license) then
		TriggerClientEvent('chatMessage',src,"^3Bounty^0: תקלה, לא מצאנו את משתמש הרוקסטר שלך")
		return
	end

	if(GetPlayerRoutingBucket(src) ~= 0) then
		xPlayer.showRGBNotification("error",".אתה נמצא בעולם אחר, הפרס לא התקבל")
		return
	end

	MySQL.Async.fetchAll('SELECT `prize` FROM `bounty` WHERE identifier = ?', {
		license
	}, function(result)
		if(result and result[1]) then
			local prize = result[1].prize
			if(prize >= 1) then
				MySQL.Async.execute("UPDATE `bounty` SET `prize` = 0 WHERE identifier = ?", {license}, function(rows)
					if(rows == 1) then
						local money = math.random(21000,36000)
						xPlayer.addMoney(money) 	
						xPlayer.showHDNotification('Bounty',"קיבלת ₪"..ESX.Math.GroupDigits(money).." בהצלחה",'info')
						TriggerClientEvent('InteractSound_CL:PlayOnOne',src, 'purchase', 1.0)
						discordLogBounty("Bounty Logs | חיסולים והאנטרים", "**"..GetPlayerName(src).. " ["..src.."]\nIdentifier: "..xPlayer.identifier.."**\nAmount: " ..ESX.Math.GroupDigits(money).."\n**Script By Gamers-Israel**")
					else
						TriggerClientEvent('chatMessage',src,"^3Bounty^0: לא נמצא שום פרס על שמך")
					end
				end)
			else
				xPlayer.showRGBNotification("error","לא רשום שמגיע לך פרס יא אוכל חינם")
			end
		else
			xPlayer.showRGBNotification("error","לא רשום שמגיע לך פרס יא אוכל חינם")
		end
	end)


end)

RegisterNetEvent("shoshanblackmarket:server:RequestRampage",function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local weapon = exports.ox_inventory:GetCurrentWeapon(xPlayer.source)
	print(weapon)
	if(not weapon) then
		xPlayer.showRGBNotification("error",".אתה חייב להחזיק נשק ביד כדי להתחיל פעולה הזו")
		return
	end
print(".הנשק הזה לא מתאים לפעולה הזו")
	if(not weapon.metadata or not weapon.metadata.ammo) then
		xPlayer.showRGBNotification('error',".הנשק הזה לא מתאים לפעולה הזו")
		return
	end

	local ammo = weapon.metadata.ammo
	if(ammo < 10) then
		xPlayer.showRGBNotification("error",".הנשק שלך צריך עוד כדורים כדי שתוכל להתחיל פעולה זו")
		return
	end

	if(PlayersInRampage[xPlayer.source]) then
		xPlayer.showRGBNotification("error",".המערכת זיהתה שאתה כבר נמצא בקרב")
		return
	end

	if(xPlayer.getBank() > Config.RampageCost) then
		xPlayer.removeBank(Config.RampageCost)
		xPlayer.showRGBNotification("success","שילמת ~g~₪"..Config.RampageCost.."~w~ מהבנק")
		PlayersInRampage[xPlayer.source] = {
			weaponname = weapon.name,
			serial = weapon.metadata.serial,
			durability = weapon.metadata.durability
		}

		SetPlayerRoutingBucket(xPlayer.source,xPlayer.source+911)
		xPlayer.triggerEvent("shoshanblackmarket:client:StartRampage")
	else
		xPlayer.showRGBNotification("error","אתה צריך ₪"..Config.RampageCost.." .בבנק כדי להתחיל את הדבר הזה")
	end
end)

local LeaderBoard = {}

local function SaveLeaderBoard()
	SaveResourceFile(GetCurrentResourceName(), "./leaderboards.json", json.encode(LeaderBoard), -1)
end

local function LoadLeaderBoard()
    LeaderBoard = json.decode(LoadResourceFile(GetCurrentResourceName(), "leaderboards.json")) or {}
end

CreateThread(function()
	LoadLeaderBoard()
end)

ESX.RegisterServerCallback('shoshanblackmarket:rampagetop10', function(source, cb)
	cb(LeaderBoard)
end)

local function SetNewTop10(playerIdentifier, icname, score)
    -- Check if player already in leaderboard
    local foundIndex = nil
    for index, entry in ipairs(LeaderBoard) do
        if entry.identifier == playerIdentifier then
            foundIndex = index
            break
        end
    end

    -- If player is in leaderboard but new score is lower, do nothing
    if foundIndex and LeaderBoard[foundIndex].score >= score then
        return
    end

    -- If player was in leaderboard, remove the old score
    if foundIndex then
        table.remove(LeaderBoard, foundIndex)
    end

    -- Insert new score
    local inserted = false
    for index, entry in ipairs(LeaderBoard) do
        if score > entry.score then
            table.insert(LeaderBoard, index, {identifier = playerIdentifier, playerName = icname, score = score})
            inserted = true
            break
        end
    end

    -- If not inserted, and leaderboard is not full, append at the end
    if not inserted and #LeaderBoard < 10 then
        table.insert(LeaderBoard, {identifier = playerIdentifier, playerName = icname, score = score})
    end

    -- Ensure leaderboard does not exceed 10 entries
    if #LeaderBoard > 10 then
        -- Find the entry with the lowest score
        local lowestScoreIndex = 1
        for index, entry in ipairs(LeaderBoard) do
            if LeaderBoard[lowestScoreIndex].score > entry.score then
                lowestScoreIndex = index
            end
        end
        -- Remove the entry with the lowest score
        table.remove(LeaderBoard, lowestScoreIndex)
    end

    -- Save updated leaderboard
    SaveLeaderBoard()
end


local function FixWeaponBySerial(src,weapon,serial,durability)
	local slot = exports.ox_inventory:GetSlotIdWithItem(src,weapon,{serial = serial})
	exports.ox_inventory:SetDurability(src,slot,durability)
end


RegisterNetEvent("shoshanblackmarket:server:EndRampage",function(score)
	local src = source
	if(not PlayersInRampage[src]) then return end
	local xPlayer = ESX.GetPlayerFromId(src)
	if(not xPlayer) then return end
	SetPlayerRoutingBucket(src,0)
	local durability = PlayersInRampage[src].durability
	if(PlayersInRampage[src].weaponname and PlayersInRampage[src].serial and durability) then
		FixWeaponBySerial(src,PlayersInRampage[src].weaponname,PlayersInRampage[src].serial,durability)
		xPlayer.showRGBNotification("success","Weapon Repaired Back To ~g~"..math.floor(durability).."~w~%")
	end
	PlayersInRampage[src] = nil
	if(score) then
		xPlayer.showRGBNotification("success","~r~Rampage~w~ Completed With a Score Of: ~r~"..score.."~w~",10000)
		SetNewTop10(xPlayer.identifier,xPlayer.getName(),score)
	end
end)

RegisterNetEvent("shoshanblackmarket:server:RequestBagDeposit", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	local playerItems = exports.ox_inventory:GetInventoryItems(src)
    local price = 0
    local count = 0
    for k,v in pairs(playerItems) do
        if(v.name == "p_moneybag") then
            if(v.metadata?.p_worth) then
                count +=1
                price += v.metadata?.p_worth
            end
        end
    end
    if price <= 0 then
        xPlayer.showRGBNotification('error',"!אין לך תיקי משא ומתן להפקיד")
        return
    end
	for k,v in pairs(playerItems) do
		if(v.name == "p_moneybag") then
			exports.ox_inventory:RemoveItem(src, "p_moneybag", v.count, v.metadata, v.slot)
		end
	end
	xPlayer.addMoney(price)
	sendToDiscord("הפקדת כסף משא ומתן",  string.format("%s [%s]\nIdentifier: %s\nTotal Bags: %s\nTotal Price: ₪%s", xPlayer.name, src, xPlayer.identifier, count, ESX.Math.GroupDigits(price)),65535)
	xPlayer.showRGBNotification("success","קיבלת ₪"..ESX.Math.GroupDigits(price).." על התיקים שלך בהצלחה")
	xPlayer.Playsound("purchase",1.0)
end)


local function ResetDealers()
	local xPlayers = ESX.GetExtendedPlayers("job","drugdelivery")
	for k,v in pairs(xPlayers) do
		if(v and v.job.name == "drugdelivery") then
			v.setJob("unemployed",0)
			v.showHDNotification("Black Market","הזמן שלך בתור שליח סמים הסתיים","info")
			exports['es_extended']:SavePlayer(v.source)
		end
	end
	Wait(1000)

	MySQL.Async.execute("UPDATE `users` SET `job` = 'unemployed', job_grade = 0 WHERE `job` = 'drugdelivery'", {}, function(rows)
		if(rows > 0) then
			print("Removed "..rows.." From Drug Dealing")
		else
			print("No Drug Dealers Found")
		end
	end)
end


local function ResetStock()
	MySQL.Async.execute("UPDATE `blackmarket_stock` SET `stock` = 25 WHERE `product` = 'guns'", {}, function(rows)
		if(rows) then
			print("Stock Reset Successfully")
		else
			print("Stock Reset Failed")
		end
	end)

end



local function CronTask(d, h, m)
	if d == 1 then
	  ResetDealers()
	end
	ResetStock()
end

CreateThread(function()
	local hour = math.random(0,24)
	while hour == 6 do
		Wait(500)
		hour = math.random(0,24)
	end
	TriggerEvent('cron:runAt', hour, 0, CronTask)
end)

