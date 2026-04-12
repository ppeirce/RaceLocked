--- Creates and wires the settings frame hierarchy (runs once at addon load).
function RaceLocked_Settings_BuildWindow()
  local f = RaceLocked_Settings_CreateRootFrame()
  RaceLocked_Settings.settingsFrame = f
  RaceLocked_Settings_RegisterResetMenuPosition(f)
  RaceLocked_Settings_AttachBackgroundTexture(f)
  RaceLocked_Settings_CreateTitleChrome(f)
  if RaceLocked_InitializeTabs then
    RaceLocked_InitializeTabs(f)
  end
end

RaceLocked_Settings_BuildWindow()
