Config = {}
Config.Weapons = {
    -- {weapon = "WEAPON_MICROSMG", price = 70000},
    {weapon = "WEAPON_MACHINEPISTOL", price = 65000},
    {weapon = "WEAPON_MINISMG", price = 60000},
    {weapon = "WEAPON_PISTOL", price = 35000},
    {weapon = "WEAPON_COMBATPISTOL", price = 40000},
    {weapon = "WEAPON_KNIFE", price = 15000},
    {weapon = "WEAPON_BAT", price = 11000},
    {weapon = "WEAPON_SLEDGEHAMMER", price = 18000},
    --{weapon = "WEAPON_POOLCUE", price = 12000},
    {weapon = "WEAPON_KNUCKLE", price = 17000},
    {weapon = "WEAPON_BOTTLE", price = 10000},
    {weapon = "WEAPON_SWITCHBLADE", price = 12000},
}


Config.CPrice = 8000

Config.Plateprice = 10000

Config.RepairCost = {
    ["Melee"] = 5000,
    ["Flare"] = 10000,
    ["Pistols"] = 10000,
    ["Shotgun"] = 15000,
    ["SMG"] = 25000,
    ["Rifle"] = 50000,
    ["MG"] = 75000,
    ["Sniper"] = 75000,
}


Config.WeaponsTypes = {
    {weaponName = 'WEAPON_PISTOL', weaponHash = GetHashKey('WEAPON_PISTOL'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_PISTOL_MK2', weaponHash = GetHashKey('WEAPON_PISTOL_MK2'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_PISTOLXM3', weaponHash = GetHashKey('WEAPON_PISTOLXM3'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_FNX45', weaponHash = GetHashKey('WEAPON_FNX45'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_GLOCK18C', weaponHash = GetHashKey('WEAPON_GLOCK18C'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_COMBATPISTOL', weaponHash = GetHashKey('WEAPON_COMBATPISTOL'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_APPISTOL', weaponHash = GetHashKey('WEAPON_APPISTOL'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_PISTOL50', weaponHash = GetHashKey('WEAPON_PISTOL50'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_SNSPISTOL', weaponHash = GetHashKey('WEAPON_SNSPISTOL'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_HEAVYPISTOL', weaponHash = GetHashKey('WEAPON_HEAVYPISTOL'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_VINTAGEPISTOL', weaponHash = GetHashKey('WEAPON_VINTAGEPISTOL'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_REVOLVER', weaponHash = GetHashKey('WEAPON_REVOLVER'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_MARKSMANPISTOL', weaponHash = GetHashKey('WEAPON_MARKSMANPISTOL'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_DOUBLEACTION', weaponHash = GetHashKey('WEAPON_DOUBLEACTION'), WeaponType = "Pistols"},
    {weaponName = 'WEAPON_SMG', weaponHash = GetHashKey('WEAPON_SMG'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_MACHINEPISTOL', weaponHash = GetHashKey('WEAPON_MACHINEPISTOL'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_ASSAULTSMG', weaponHash = GetHashKey('WEAPON_ASSAULTSMG'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_MICROSMG', weaponHash = GetHashKey('WEAPON_MICROSMG'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_MINISMG', weaponHash = GetHashKey('WEAPON_MINISMG'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_MAC10', weaponHash = GetHashKey('WEAPON_MAC10'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_MP9', weaponHash = GetHashKey('WEAPON_MP9'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_COMBATPDW', weaponHash = GetHashKey('WEAPON_COMBATPDW'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_SMG_MK2', weaponHash = GetHashKey('WEAPON_SMG_MK2'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_GUSENBERG', weaponHash = GetHashKey('WEAPON_GUSENBERG'), WeaponType = "SMG"},
    {weaponName = 'WEAPON_PUMPSHOTGUN', weaponHash = GetHashKey('WEAPON_PUMPSHOTGUN'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_SAWNOFFSHOTGUN', weaponHash = GetHashKey('WEAPON_SAWNOFFSHOTGUN'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_ASSAULTSHOTGUN', weaponHash = GetHashKey('WEAPON_ASSAULTSHOTGUN'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_BULLPUPSHOTGUN', weaponHash = GetHashKey('WEAPON_BULLPUPSHOTGUN'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_HEAVYSHOTGUN', weaponHash = GetHashKey('WEAPON_HEAVYSHOTGUN'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_DBSHOTGUN', weaponHash = GetHashKey('WEAPON_DBSHOTGUN'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_AUTOSHOTGUN', weaponHash = GetHashKey('WEAPON_AUTOSHOTGUN'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_PUMPSHOTGUN_MK2', weaponHash = GetHashKey('WEAPON_PUMPSHOTGUN_MK2'), WeaponType = "Shotgun"},
    {weaponName = 'WEAPON_MUSKET', weaponHash = GetHashKey('WEAPON_MUSKET'), WeaponType = "Shotgun"},

    {weaponName = 'WEAPON_ASSAULTRIFLE', weaponHash = GetHashKey('WEAPON_ASSAULTRIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_M70', weaponHash = GetHashKey('WEAPON_M70'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_AK74', weaponHash = GetHashKey('WEAPON_AK74'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_AKS74', weaponHash = GetHashKey('WEAPON_AKS74'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_CARBINERIFLE', weaponHash = GetHashKey('WEAPON_CARBINERIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_ADVANCEDRIFLE', weaponHash = GetHashKey('WEAPON_ADVANCEDRIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_SPECIALCARBINE', weaponHash = GetHashKey('WEAPON_SPECIALCARBINE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_HEAVYRIFLE', weaponHash = GetHashKey('WEAPON_HEAVYRIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_BULLPUPRIFLE', weaponHash = GetHashKey('WEAPON_BULLPUPRIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_COMPACTRIFLE', weaponHash = GetHashKey('WEAPON_COMPACTRIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_CARBINERIFLE_MK2', weaponHash = GetHashKey('WEAPON_CARBINERIFLE_MK2'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_TACTICALRIFLE', weaponHash = GetHashKey('WEAPON_TACTICALRIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_SPECIALCARBINE_MK2', weaponHash = GetHashKey('WEAPON_SPECIALCARBINE_MK2'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_MILITARYRIFLE', weaponHash = GetHashKey('WEAPON_MILITARYRIFLE'), WeaponType = "Rifle"},
    {weaponName = 'WEAPON_BULLPUPRIFLE_MK2', weaponHash = GetHashKey('WEAPON_BULLPUPRIFLE_MK2'), WeaponType = "Rifle"},


    {weaponName = 'WEAPON_MG', weaponHash = GetHashKey('WEAPON_MG'), WeaponType = "MG"},
    {weaponName = 'WEAPON_COMBATMG', weaponHash = GetHashKey('WEAPON_COMBATMG'), WeaponType = "MG"},
    {weaponName = 'WEAPON_GUSENBERG', weaponHash = GetHashKey('WEAPON_GUSENBERG'), WeaponType = "MG"},
    {weaponName = 'WEAPON_COMBATMG_MK2', weaponHash = GetHashKey('WEAPON_COMBATMG_MK2'), WeaponType = "MG"},

    {weaponName = 'WEAPON_PRECISIONRIFLE', weaponHash = GetHashKey('WEAPON_PRECISIONRIFLE'), WeaponType = "Sniper"},
    {weaponName = 'WEAPON_SNIPERRIFLE', weaponHash = GetHashKey('WEAPON_SNIPERRIFLE'), WeaponType = "Sniper"},
    {weaponName = 'WEAPON_HEAVYSNIPER', weaponHash = GetHashKey('WEAPON_HEAVYSNIPER'), WeaponType = "Sniper"},
    {weaponName = 'WEAPON_MARKSMANRIFLE', weaponHash = GetHashKey('WEAPON_MARKSMANRIFLE'), WeaponType = "Sniper"},
    {weaponName = 'WEAPON_MARKSMANRIFLE_MK2', weaponHash = GetHashKey('WEAPON_MARKSMANRIFLE_MK2'), WeaponType = "Sniper"},
    {weaponName = 'WEAPON_HEAVYSNIPER_MK2', weaponHash = GetHashKey('WEAPON_HEAVYSNIPER_MK2'), WeaponType = "Sniper"},
    {weaponName = 'WEAPON_MK14', weaponHash = GetHashKey('WEAPON_MK14'), WeaponType = "Sniper"},
	{weaponName = 'WEAPON_FLAREGUN', weaponHash = GetHashKey('WEAPON_FLAREGUN'), WeaponType = "Flare"},
}

Config.RampageCost = 500
Config.MaxRampagePeds = 50
Config.BossScore = 50


-- Bounty

Config.Bounties = {
    vector3(91.33, -1409.19, 29.42),
    vector3(-297.06, -1478.92, 30.76),
    vector3(-750.91, -1278.83, 5.36),
    vector3(943.0, -620.0, 57.38),
    vector3(-394.0, 48.0, 51.93),
    vector3(1261.01, -1745.99, 49.13),
    vector3(-968.47, -2141.09, 8.94),
    vector3(-1146.92, -1493.17, 4.42),
    vector3(1725.52, 3739.67, 33.86),
    vector3(3686.09, 4461.83, 24.29),
    vector3(-430.99, 6056.0, 31.4),
    vector3(-623.0, 498.0, 107.61),
    vector3(-1636.27, -226.65, 54.73),
    vector3(2692.7, 1629.3, 24.56),
    vector3(632.54, 2711.49, 41.22),
    vector3(-3140.5, 1082.4, 20.68),
    -- vector3(532.99, 140.01, 98.15),
    vector3(783.62, -3041.99, 5.8),
    vector3(67.0, -1897.99, 21.62),
    vector3(1213.0, -365.0, 68.89),
    vector3(263.0, 1173.0, 224.98),
    vector3(-777.01, 5638.0, 25.2),
    vector3(2639.64, 4320.37, 44.37),
    vector3(-1315.0, -855.99, 16.13),
    vector3(1356.0, 3571.0, 35.0),
    vector3(-233.0, -2625.0, 6.03),
    vector3(926.0, -2209.0, 30.24),
    vector3(37.0, -290.0, 47.73),
    vector3(-853.0, -289.0, 39.84),
    vector3(900.0, -1085.99, 31.62),
    vector3(-2342.16, 268.07, 169.47),
    vector3(-622.93, -908.18, 24.25),
    vector3(-1058.43, -1042.49, 2.12),
    vector3(901.37, -51.35, 78.76),

}

Config.PedModels = {
    "ig_ballasog",
    "ig_claypain",
    "ig_clay",
    "ig_hao",
    "player_zero",
    "ig_tomcasino",
    "cs_chengsr",
    "cs_martinmadrazo",
    "cs_stretch",
    "csb_undercover",
    "g_m_y_mexgang_01",
    "mp_g_m_pros_01",
    "a_m_y_gay_01",
    "mp_m_freemode_01",
    "g_m_y_ballaorig_01",
    "g_m_y_famdnf_01",
    "s_m_y_xmech_02",
    "ig_lamardavis",
    "ig_lestercrest_2",
    "ig_roccopelosi",
    "ig_brucie2",
    "u_m_m_partytarget",
    "u_m_m_rivalpap",
    "u_m_y_proldriver_01",
}

Config.PedWeapons = {
    "WEAPON_MACHINEPISTOL",
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_MICROSMG",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_MINISMG",
    "WEAPON_HEAVYPISTOL",
}