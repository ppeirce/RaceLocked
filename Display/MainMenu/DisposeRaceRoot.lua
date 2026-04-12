--- @param mount Frame settings mount that may hold `raceRoot`
function RaceLocked_MainMenu_DisposeRaceRoot(mount)
  if mount.raceRoot then
    mount.raceRoot:Hide()
    mount.raceRoot:SetParent(nil)
    mount.raceRoot = nil
  end
end
