--- Horizontal inset for label/detail text from the left edge of a stat pane.
--- @return number
function RaceLocked_GuildChampion_TextLeftOffset()
  local G = RaceLocked_GuildChampion
  return G.ACCENT_INSET_X + G.ACCENT_W + G.GAP_AFTER_ACCENT + G.FACTION_ICON_SIZE + G.GAP_AFTER_ICON
end
