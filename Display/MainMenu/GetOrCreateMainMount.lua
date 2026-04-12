--- @param settingsFrame Frame
--- @return Frame mount
function RaceLocked_MainMenu_GetOrCreateMainMount(settingsFrame)
  local L = RaceLocked_MainMenu
  local mainTab = RaceLocked_GetMainTabContent and RaceLocked_GetMainTabContent()
  local parent = mainTab or settingsFrame
  local mount = settingsFrame.raceLockedMainMount
  if not mount then
    mount = CreateFrame('Frame', nil, parent)
    settingsFrame.raceLockedMainMount = mount
  else
    mount:SetParent(parent)
    mount:ClearAllPoints()
  end
  if mainTab then
    mount:SetPoint('TOPLEFT', parent, 'TOPLEFT', L.MAIN_MARGIN_X, -6)
    mount:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', -L.MAIN_MARGIN_X, L.MAIN_BOTTOM_INSET)
  else
    mount:SetPoint('TOPLEFT', parent, 'TOPLEFT', L.MAIN_MARGIN_X, L.MAIN_TOP_INSET)
    mount:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', -L.MAIN_MARGIN_X, L.MAIN_BOTTOM_INSET)
  end
  return mount
end
