addonName = ...
RaceLocked = CreateFrame('Frame')

RaceLocked:RegisterEvent('ADDON_LOADED')
RaceLocked:SetScript('OnEvent', function(self, event, loadedAddonName)
  if event == 'ADDON_LOADED' and loadedAddonName == addonName then
    RaceLockedDB = RaceLockedDB or {}
    RaceLockedDB.minimapButton = RaceLockedDB.minimapButton or { hide = false }
    RaceLockedDB.raceGridGuildSnapshot = RaceLockedDB.raceGridGuildSnapshot or {}
    if type(RaceLockedDB.raceGridGuildSnapshot.byRace) ~= 'table' then
      RaceLockedDB.raceGridGuildSnapshot.byRace = {}
    end
    if type(RaceLockedDB.raceGridGuildSnapshot.normalizedGuild) ~= 'string' then
      RaceLockedDB.raceGridGuildSnapshot.normalizedGuild = ''
    end
    if RaceLocked_Options_EnsureLoaded then
      RaceLocked_Options_EnsureLoaded()
    end
  end
end)
