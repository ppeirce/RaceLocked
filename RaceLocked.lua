addonName = ...
RaceLocked = CreateFrame('Frame')

RaceLocked:RegisterEvent('ADDON_LOADED')
RaceLocked:SetScript('OnEvent', function(self, event, loadedAddonName)
  if event == 'ADDON_LOADED' and loadedAddonName == addonName then
    RaceLockedDB = RaceLockedDB or {}
    RaceLockedDB.minimapButton = RaceLockedDB.minimapButton or { hide = false }
    if RaceLocked_Options_EnsureLoaded then
      RaceLocked_Options_EnsureLoaded()
    end
  end
end)
