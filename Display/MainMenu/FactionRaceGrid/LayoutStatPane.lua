--- @param labelFs FontString
--- @param detailFs FontString
--- @param pane Frame
--- @param tx number left inset for text block
function RaceLocked_GuildChampion_LayoutStatPane(labelFs, detailFs, pane, tx)
  local G = RaceLocked_GuildChampion
  labelFs:ClearAllPoints()
  detailFs:ClearAllPoints()
  labelFs:SetPoint('LEFT', pane, 'LEFT', tx, 0)
  labelFs:SetPoint('RIGHT', pane, 'RIGHT', -G.INNER_PAD, 0)
  labelFs:SetPoint('BOTTOM', pane, 'CENTER', 0, 4)
  detailFs:SetPoint('LEFT', pane, 'LEFT', tx, 0)
  detailFs:SetPoint('RIGHT', pane, 'RIGHT', -G.INNER_PAD, 0)
  detailFs:SetPoint('TOP', pane, 'CENTER', 0, -4)
end
