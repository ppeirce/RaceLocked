
-- Language IDs from the client (see GetLanguageByIndex); map is keyed by RaceId / race file token.
local RACE_ID_TO_LANGUAGE_ID = {
    [1] = 7, -- Human → Common
    [2] = 1, -- Orc → Orcish
    [3] = 6, -- Dwarf → Dwarvish
    [4] = 2, -- Night Elf → Darnassian
    [5] = 33, -- Undead → Forsaken
    [6] = 3, -- Tauren → Taurahe
    [7] = 13, -- Gnome → Gnomish
    [8] = 14, -- Troll → Zandali
}

local RACE_FILE_TO_LANGUAGE_ID = {
    Human = 7,
    Orc = 1,
    Dwarf = 6,
    NightElf = 2,
    Scourge = 33,
    Tauren = 3,
    Gnome = 13,
    Troll = 14,
}

local function findKnownLanguageNameAndId(targetLanguageId)
    if not targetLanguageId or not GetNumLanguages or not GetLanguageByIndex then
        return nil, nil
    end
    for i = 1, GetNumLanguages() do
        local languageName, languageId = GetLanguageByIndex(i)
        if languageId == targetLanguageId then
            return languageName, languageId
        end
    end
    return nil, nil
end

local function applyToAllChatEditBoxes(languageName, languageId)
    if not languageName or not languageId or not NUM_CHAT_WINDOWS then
        return
    end
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        if editBox then
            editBox.language = languageName
            editBox.languageID = languageId
        end
    end
end

local function EnforceRaceLanguage()
    local _, raceFile, raceId = UnitRace("player")
    if not raceFile and not raceId then
        return
    end

    local wantedId = (raceId and RACE_ID_TO_LANGUAGE_ID[raceId]) or (raceFile and RACE_FILE_TO_LANGUAGE_ID[raceFile])
    if not wantedId then
        return
    end

    local languageName, languageId = findKnownLanguageNameAndId(wantedId)
    if not languageName or not languageId then
        return
    end

    applyToAllChatEditBoxes(languageName, languageId)
end

local function scheduleEnforceRaceLanguage()
    if C_Timer and C_Timer.After then
        C_Timer.After(0, EnforceRaceLanguage)
    else
        EnforceRaceLanguageFrame:SetScript("OnUpdate", function(self)
            self:SetScript("OnUpdate", nil)
            EnforceRaceLanguage()
        end)
    end
end

EnforceRaceLanguageFrame = CreateFrame("Frame")

EnforceRaceLanguageFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EnforceRaceLanguageFrame:RegisterEvent("LANGUAGE_LIST_CHANGED")

EnforceRaceLanguageFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "LANGUAGE_LIST_CHANGED" then
        scheduleEnforceRaceLanguage()
    end
end)
