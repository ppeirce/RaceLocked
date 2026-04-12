--- @param details FontString[] indexed 1–4
--- @param raceTokens string[] indexed 1–4
--- @param playerRaceToken string
function RaceLocked_GuildChampion_RefreshRaceDetails(details, raceTokens, playerRaceToken)
  local G = RaceLocked_GuildChampion
  local avg = RaceLocked_GuildChampion_GetGuildAverageLevel()
  local avgStr
  if avg then
    avgStr = tostring(math.floor(avg + 0.5))
  end
  for i = 1, 4 do
    if raceTokens[i] == playerRaceToken then
      if avgStr then
        details[i]:SetText(avgStr)
        details[i]:SetTextColor(0.82, 0.8, 0.74)
      else
        details[i]:SetText('—')
        details[i]:SetTextColor(G.MUTED[1], G.MUTED[2], G.MUTED[3])
      end
    else
      details[i]:SetText('coming soon')
      details[i]:SetTextColor(G.MUTED[1], G.MUTED[2], G.MUTED[3])
    end
  end
end
