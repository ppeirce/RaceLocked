--- @param mount Frame parent for `RaceLocked_CreateFactionRaceGrid`
function RaceLocked_MainMenu_AttachFactionRaceGrid(mount)
  if RaceLocked_CreateFactionRaceGrid then
    mount.raceRoot = select(1, RaceLocked_CreateFactionRaceGrid(mount, 0))
  end
end
