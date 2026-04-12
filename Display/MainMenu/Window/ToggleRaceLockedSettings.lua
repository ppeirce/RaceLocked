function ToggleRaceLockedSettings()
  local settingsFrame = _G.RaceLockedSettingsFrame
  if not settingsFrame then
    return
  end
  if settingsFrame:IsShown() then
    if _G.HideConfirmationDialog then
      _G.HideConfirmationDialog()
    end
    if RaceLocked_ResetTabState then
      RaceLocked_ResetTabState()
    end
    settingsFrame:Hide()
  else
    RaceLocked_Settings_UpdateFrameBackdrop(settingsFrame)
    if RaceLocked_InitializeTabs then
      RaceLocked_InitializeTabs(settingsFrame)
    end
    if RaceLocked_HideAllTabs and RaceLocked_SetDefaultTab then
      RaceLocked_HideAllTabs()
      RaceLocked_SetDefaultTab()
    elseif RaceLocked_SwitchToTab then
      RaceLocked_SwitchToTab(1)
    end
    if RaceLocked_InitializeMainPanel then
      RaceLocked_InitializeMainPanel(settingsFrame)
    end
    settingsFrame:Show()
  end
end
