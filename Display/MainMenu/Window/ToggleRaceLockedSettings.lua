function ToggleRaceLockedSettings()
  local settingsFrame = _G.RaceLockedSettingsFrame
  if not settingsFrame then
    return
  end
  if settingsFrame:IsShown() then
    if _G.HideConfirmationDialog then
      _G.HideConfirmationDialog()
    end
    settingsFrame:Hide()
  else
    RaceLocked_Settings_UpdateFrameBackdrop(settingsFrame)
    if RaceLocked_InitializeMainPanel then
      RaceLocked_InitializeMainPanel(settingsFrame)
    end
    settingsFrame:Show()
  end
end
