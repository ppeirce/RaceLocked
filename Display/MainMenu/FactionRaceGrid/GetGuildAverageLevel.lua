--- Mean level across current guild roster rows (nil if not in a guild or roster empty).
--- @return number|nil
function RaceLocked_GuildChampion_GetGuildAverageLevel()
  if not IsInGuild or not IsInGuild() then
    return nil
  end
  local total = select(1, GetNumGuildMembers(true))
  if not total or total < 1 then
    total = select(1, GetNumGuildMembers())
  end
  total = tonumber(total) or 0
  if total < 1 then
    return nil
  end
  local sum = 0
  local n = 0
  for i = 1, total do
    local _, _, _, level = GetGuildRosterInfo(i)
    local lv = tonumber(level)
    if lv and lv >= 1 then
      sum = sum + lv
      n = n + 1
    end
  end
  if n < 1 then
    return nil
  end
  return sum / n
end
