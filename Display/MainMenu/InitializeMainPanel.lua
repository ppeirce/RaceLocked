-- Main window content: 2×2 faction race grid only.

--- @param settingsFrame Frame
--- @param forceRefresh boolean|nil when true, rebuild the grid even if one exists
function RaceLocked_InitializeMainPanel(settingsFrame, forceRefresh)
  if not settingsFrame then
    return
  end
  local mount = RaceLocked_MainMenu_GetOrCreateMainMount(settingsFrame)
  if mount.raceRoot and not forceRefresh then
    return
  end
  RaceLocked_MainMenu_DisposeRaceRoot(mount)
  RaceLocked_MainMenu_AttachFactionRaceGrid(mount)
end
