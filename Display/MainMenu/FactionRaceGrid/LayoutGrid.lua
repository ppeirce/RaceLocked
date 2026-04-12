--- Lay out the faction race grid: 2×2 panes, refresh row, explainer, footer; updates root height and refreshes numbers.
--- @param ctx table
--- @field root Frame
--- @field parent Frame
--- @field rightInset number
--- @field titleLabel FontString
--- @field refreshRow Frame
--- @field explainer FontString
--- @field footerLabel FontString
--- @field panes Frame[] 1–4
--- @field labels FontString[] 1–4
--- @field details FontString[] 1–4
--- @field icons Texture[] 1–4
--- @field raceTokens string[] 1–4
--- @field playerRaceToken string
--- @field totalH number mutable total height (written)
function RaceLocked_GuildChampion_LayoutGrid(ctx)
  local G = RaceLocked_GuildChampion
  local root = ctx.root
  local parent = ctx.parent
  local rightInset = ctx.rightInset

  local rw = root:GetWidth()
  if (not rw or rw < 2) and parent and parent.GetWidth then
    rw = math.max(0, parent:GetWidth() - rightInset)
  end
  if rw < 80 then
    rw = 400
  end

  local rowInner = rw - G.MID_GAP
  local wLeft = math.floor(rowInner / 2)
  local wRight = rowInner - wLeft

  local gridTop = G.OUTER_PAD_Y + G.TITLE_TOP_PAD + G.TITLE_ROW_H + G.GAP_AFTER_TITLE
  ctx.titleLabel:ClearAllPoints()
  ctx.titleLabel:SetPoint('TOPLEFT', root, 'TOPLEFT', 0, -(G.OUTER_PAD_Y + G.TITLE_TOP_PAD))
  ctx.titleLabel:SetPoint('TOPRIGHT', root, 'TOPRIGHT', 0, -(G.OUTER_PAD_Y + G.TITLE_TOP_PAD))

  local panes = ctx.panes
  panes[1]:ClearAllPoints()
  panes[1]:SetPoint('TOPLEFT', root, 'TOPLEFT', 0, -gridTop)
  panes[1]:SetSize(wLeft, G.STATS_ROW_H)

  panes[2]:ClearAllPoints()
  panes[2]:SetPoint('TOPLEFT', panes[1], 'TOPRIGHT', G.MID_GAP, 0)
  panes[2]:SetSize(wRight, G.STATS_ROW_H)

  panes[3]:ClearAllPoints()
  panes[3]:SetPoint('TOPLEFT', panes[1], 'BOTTOMLEFT', 0, -G.ROW_GAP)
  panes[3]:SetSize(wLeft, G.STATS_ROW_H)

  panes[4]:ClearAllPoints()
  panes[4]:SetPoint('TOPLEFT', panes[3], 'TOPRIGHT', G.MID_GAP, 0)
  panes[4]:SetSize(wRight, G.STATS_ROW_H)

  local icons = ctx.icons
  for j = 1, 4 do
    local icon = icons[j]
    icon:ClearAllPoints()
    icon:SetSize(G.FACTION_ICON_SIZE, G.FACTION_ICON_SIZE)
    icon:SetPoint('LEFT', panes[j], 'LEFT', G.ACCENT_INSET_X + G.ACCENT_W + G.GAP_AFTER_ACCENT, 0)
    local topInset = math.max(2, (G.STATS_ROW_H - G.FACTION_ICON_SIZE) / 2)
    icon:SetPoint('TOP', panes[j], 'TOP', 0, -topInset)
  end

  local tx = RaceLocked_GuildChampion_TextLeftOffset()
  for i = 1, 4 do
    RaceLocked_GuildChampion_LayoutStatPane(ctx.labels[i], ctx.details[i], panes[i], tx)
  end

  ctx.refreshRow:ClearAllPoints()
  ctx.refreshRow:SetPoint('TOPLEFT', panes[3], 'BOTTOMLEFT', 0, -G.GAP_AFTER_GRID)
  ctx.refreshRow:SetPoint('TOPRIGHT', panes[4], 'BOTTOMRIGHT', 0, -G.GAP_AFTER_GRID)

  ctx.explainer:ClearAllPoints()
  local explainW = math.max(40, rw - G.INNER_PAD * 2)
  ctx.explainer:SetWidth(explainW)
  ctx.explainer:SetPoint('TOPLEFT', ctx.refreshRow, 'BOTTOMLEFT', G.INNER_PAD, -G.EXPLAIN_TOP_GAP)

  local explH = ctx.explainer:GetStringHeight()
  local _, fontH = ctx.explainer:GetFont()
  fontH = tonumber(fontH) or 11
  -- GetStringHeight can under-report one frame; pad by part of a line so root is not too short (avoids "…" truncation).
  explH = explH + math.ceil(fontH * 0.75)

  ctx.footerLabel:ClearAllPoints()
  ctx.footerLabel:SetPoint('TOPLEFT', ctx.explainer, 'BOTTOMLEFT', G.INNER_PAD, -G.FOOTER_TOP_GAP)
  ctx.footerLabel:SetPoint('TOPRIGHT', ctx.explainer, 'BOTTOMRIGHT', -G.INNER_PAD, -G.FOOTER_TOP_GAP)
  local footerH = ctx.footerLabel:GetStringHeight()

  local newH = gridTop
    + G.STATS_ROW_H * 2
    + G.ROW_GAP
    + G.GAP_AFTER_GRID
    + G.REFRESH_ROW_H
    + G.EXPLAIN_TOP_GAP
    + explH
    + G.FOOTER_TOP_GAP
    + footerH
    + G.OUTER_PAD_Y
  root:SetHeight(newH)
  ctx.totalH = newH

  RaceLocked_GuildChampion_RefreshRaceDetails(ctx.details, ctx.raceTokens, ctx.playerRaceToken)
end
