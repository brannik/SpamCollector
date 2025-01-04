local instanceIcons = {
    -- The Burning Crusade Dungeons
    ["RAMPS"] = 647,  -- Hellfire Ramparts
    ["BF"] = 648,     -- Blood Furnace
    ["SP"] = 649,     -- Slave Pens
    ["UB"] = 650,     -- Underbog
    ["MT"] = 651,     -- Mana-Tombs
    ["AC"] = 652,     -- Auchenai Crypts
    ["SETHEKK"] = 653, -- Sethekk Halls
    ["SH"] = 654,     -- Shattered Halls
    ["SV"] = 655,     -- Steamvault
    ["BOT"] = 656,    -- Botanica
    ["MECH"] = 657,   -- Mechanar
    ["ARC"] = 658,    -- Arcatraz
    ["SL"] = 659,     -- Shadow Labyrinth
    ["BM"] = 660,     -- Black Morass
    ["OHF"] = 661,    -- Old Hillsbrad Foothills
    ["MAGT"] = 682,   -- Magisters' Terrace

    -- The Burning Crusade Raids
    ["KARA"] = 695,   -- Karazhan
    ["GRUUL"] = 692,  -- Gruul's Lair
    ["MAG"] = 693,    -- Magtheridon's Lair
    ["SSC"] = 694,    -- Serpentshrine Cavern
    ["TK"] = 696,     -- The Eye (Tempest Keep)
    ["HYJAL"] = 697,  -- Battle for Mount Hyjal
    ["BT"] = 698,     -- Black Temple
    ["SWP"] = 699,    -- Sunwell Plateau

    -- Wrath of the Lich King Dungeons
    ["UK"] = 477,     -- Utgarde Keep
    ["NEX"] = 478,    -- The Nexus
    ["AN"] = 480,     -- Azjol-Nerub
    ["OK"] = 481,     -- Ahn'kahet: The Old Kingdom
    ["DTK"] = 482,    -- Drak'Tharon Keep
    ["VH"] = 483,     -- Violet Hold
    ["GUN"] = 484,    -- Gundrak
    ["HOS"] = 485,    -- Halls of Stone
    ["HOL"] = 486,    -- Halls of Lightning
    ["COS"] = 487,    -- Culling of Stratholme
    ["OCC"] = 488,    -- The Oculus
    ["UP"] = 499,     -- Utgarde Pinnacle
    ["TOTC5"] = 3778, -- Trial of the Champion
    ["FOS"] = 4516,   -- Forge of Souls
    ["POS"] = 4517,   -- Pit of Saron
    ["HOR"] = 4518,   -- Halls of Reflection

    -- Wrath of the Lich King Raids
    ["OS"] = 1876,    -- Obsidian Sanctum
    ["EOE"] = 1877,   -- Eye of Eternity
    ["NAXX"] = 578,   -- Naxxramas (WotLK Version)
    ["ULD"] = 2957,   -- Ulduar
    ["TOTC"] = 3917,  -- Trial of the Crusader
    ["ICC"] = 4532,   -- Icecrown Citadel
    ["RS"] = 4817,    -- Ruby Sanctum
}

local defaultIcon = "Interface\\Icons\\INV_Misc_QuestionMark"

function GetInstanceIcon(message)
    for abbreviation, achievementID in pairs(instanceIcons) do
        if message:upper():find(abbreviation) then
            local _, _, _, _, _, _, _, _, _, icon = GetAchievementInfo(achievementID)
            return icon or defaultIcon
        end
    end
    return defaultIcon
end
