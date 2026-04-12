function RaceLocked_GuildChampion_PrintGuildAverageAfterRefresh()
  local avg = RaceLocked_GuildChampion_GetGuildAverageLevel()
  if avg then
    local n = math.floor(avg + 0.5)
    print(string.format('|cfffcdd76[Race Locked]|r New race average: |cffffffff%d|r', n))
  else
    print('|cfff44336[Race Locked]|r No average yet (not in a guild or empty roster).')
  end
end
