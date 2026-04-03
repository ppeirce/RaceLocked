addonName = ...
GuildWars = CreateFrame('Frame')

GuildWars:RegisterEvent('ADDON_LOADED')
GuildWars:SetScript('OnEvent', function(self, event, loadedAddonName)
  if event == 'ADDON_LOADED' and loadedAddonName == addonName then
    RaceWarsDB = RaceWarsDB or {}
    RaceWarsDB.minimapButton = RaceWarsDB.minimapButton or { hide = false }
  end
end)
