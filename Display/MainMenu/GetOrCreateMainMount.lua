--- @param settingsFrame Frame
--- @return Frame mount
function RaceLocked_MainMenu_GetOrCreateMainMount(settingsFrame)
  local L = RaceLocked_MainMenu
  local mount = settingsFrame.raceLockedMainMount
  if not mount then
    mount = CreateFrame('Frame', nil, settingsFrame)
    settingsFrame.raceLockedMainMount = mount
    mount:SetPoint('TOPLEFT', settingsFrame, 'TOPLEFT', L.MAIN_MARGIN_X, L.MAIN_TOP_INSET)
    mount:SetPoint('BOTTOMRIGHT', settingsFrame, 'BOTTOMRIGHT', -L.MAIN_MARGIN_X, L.MAIN_BOTTOM_INSET)
  end
  return mount
end
