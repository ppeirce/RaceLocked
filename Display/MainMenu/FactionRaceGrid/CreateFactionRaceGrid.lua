-- Faction race grid: four playable races for your faction in a 2×2 layout (no champion / average panel).

--- @param parent Frame
--- @param rightInset number|nil optional right inset (legacy; kept for call compatibility)
--- @return Frame root
--- @return number total height
function RaceLocked_CreateFactionRaceGrid(parent, rightInset)
  rightInset = rightInset or 0
  local G = RaceLocked_GuildChampion

  -- Final height set in LayoutGrid (includes explainer wrap height); seed for first frame.
  local totalH = G.OUTER_PAD_Y
    + G.TITLE_TOP_PAD
    + G.TITLE_ROW_H
    + G.GAP_AFTER_TITLE
    + G.STATS_ROW_H * 2
    + G.ROW_GAP
    + G.GAP_AFTER_GRID
    + G.REFRESH_ROW_H
    + G.EXPLAIN_TOP_GAP
    + 72
    + G.FOOTER_TOP_GAP
    + 20
    + G.OUTER_PAD_Y

  local root = CreateFrame('Frame', nil, parent)
  root:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, 0)
  root:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', -rightInset, 0)
  root:SetHeight(totalH)

  local titleLabel = root:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
  titleLabel:SetJustifyH('CENTER')
  titleLabel:SetText('Average Levels')
  titleLabel:SetTextColor(G.LABEL_GOLD[1], G.LABEL_GOLD[2], G.LABEL_GOLD[3])

  local refreshRow = CreateFrame('Frame', nil, root)
  refreshRow:SetHeight(G.REFRESH_ROW_H)
  local refreshBtn = CreateFrame('Button', nil, refreshRow, 'UIPanelButtonTemplate')
  refreshBtn:SetText('Refresh')
  refreshBtn:SetSize(120, G.REFRESH_ROW_H - 2)
  refreshBtn:SetPoint('CENTER', refreshRow, 'CENTER', 0, 0)

  local explainer = root:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
  explainer:SetJustifyH('LEFT')
  explainer:SetJustifyV('TOP')
  explainer:SetWordWrap(true)
  explainer:SetTextColor(G.MUTED[1], G.MUTED[2], G.MUTED[3])
  explainer:SetText(G.EXPLAIN_TEXT)
  if explainer.SetMaxLines then
    explainer:SetMaxLines(99)
  end

  local footerLabel = root:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
  footerLabel:SetJustifyH('CENTER')
  footerLabel:SetJustifyV('TOP')
  footerLabel:SetText('More to come!')
  footerLabel:SetTextColor(G.LABEL_GOLD[1], G.LABEL_GOLD[2], G.LABEL_GOLD[3])

  local playerFaction = UnitFactionGroup and UnitFactionGroup('player') or 'Alliance'
  local isHorde = playerFaction == 'Horde'
  local raceAccents = isHorde and G.HORDE_RACE_ACCENT or G.ALLIANCE_RACE_ACCENT
  local raceTokens = isHorde and { 'Orc', 'Troll', 'Tauren', 'Scourge' }
    or { 'Dwarf', 'NightElf', 'Human', 'Gnome' }

  local playerRaceToken = ''
  if UnitRace then
    local _, token = UnitRace('player')
    if token and token ~= '' then
      playerRaceToken = token
    end
  end

  local panes = {}
  local labels = {}
  local details = {}
  local icons = {}

  for i = 1, 4 do
    local f = CreateFrame('Frame', nil, root, 'BackdropTemplate')
    f:SetBackdrop(G.CELL_BACKDROP)
    f:SetBackdropColor(G.AP_BG.r, G.AP_BG.g, G.AP_BG.b, G.AP_BG.a)
    f:SetBackdropBorderColor(G.AP_BORDER.r, G.AP_BORDER.g, G.AP_BORDER.b, G.AP_BORDER.a)
    f:SetHeight(G.STATS_ROW_H)
    panes[i] = f

    local ac = raceAccents[i]
    local accent = f:CreateTexture(nil, 'BORDER')
    accent:SetColorTexture(ac[1], ac[2], ac[3], 1)
    accent:SetWidth(G.ACCENT_W)
    accent:SetPoint('TOPLEFT', f, 'TOPLEFT', G.ACCENT_INSET_X, -G.ACCENT_INSET_Y)
    accent:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', G.ACCENT_INSET_X, G.ACCENT_INSET_Y)

    local icon = f:CreateTexture(nil, 'OVERLAY')
    local token = raceTokens[i]
    icon:SetTexture(RaceLocked_GuildChampion_RaceIconTexture(token))
    icon:SetTexCoord(0, 1, 0, 1)
    icon:SetSize(G.FACTION_ICON_SIZE, G.FACTION_ICON_SIZE)
    icon:Show()
    icons[i] = icon
  end

  for i = 1, 4 do
    local lbl = panes[i]:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
    lbl:SetJustifyH('LEFT')
    lbl:SetTextColor(G.LABEL_GOLD[1] * 0.9, G.LABEL_GOLD[2] * 0.9, G.LABEL_GOLD[3] * 0.9)
    labels[i] = lbl
    local det = panes[i]:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
    det:SetJustifyH('LEFT')
    det:SetWordWrap(true)
    det:SetText('coming soon')
    det:SetTextColor(G.MUTED[1], G.MUTED[2], G.MUTED[3])
    details[i] = det
  end

  if isHorde then
    labels[1]:SetText('Orc')
    labels[2]:SetText('Troll')
    labels[3]:SetText('Tauren')
    labels[4]:SetText('Undead')
  else
    labels[1]:SetText('Dwarf')
    labels[2]:SetText('Night Elf')
    labels[3]:SetText('Human')
    labels[4]:SetText('Gnome')
  end

  local layoutCtx = {
    root = root,
    parent = parent,
    rightInset = rightInset,
    titleLabel = titleLabel,
    refreshRow = refreshRow,
    explainer = explainer,
    footerLabel = footerLabel,
    panes = panes,
    labels = labels,
    details = details,
    icons = icons,
    raceTokens = raceTokens,
    playerRaceToken = playerRaceToken,
    totalH = totalH,
  }

  local function runLayout()
    RaceLocked_GuildChampion_LayoutGrid(layoutCtx)
  end

  refreshBtn:SetScript('OnClick', function()
    if GuildRoster then
      GuildRoster()
    end
    RaceLocked_GuildChampion_RefreshRaceDetails(details, raceTokens, playerRaceToken)
    if C_Timer and C_Timer.After then
      C_Timer.After(0, function()
        RaceLocked_GuildChampion_RefreshRaceDetails(details, raceTokens, playerRaceToken)
        RaceLocked_GuildChampion_PrintGuildAverageAfterRefresh()
      end)
    else
      RaceLocked_GuildChampion_PrintGuildAverageAfterRefresh()
    end
  end)

  if GuildRoster then
    GuildRoster()
  end

  root:RegisterEvent('GUILD_ROSTER_UPDATE')
  root:RegisterEvent('PLAYER_GUILD_UPDATE')
  root:SetScript('OnEvent', function(_, event)
    if event == 'PLAYER_GUILD_UPDATE' or event == 'GUILD_ROSTER_UPDATE' then
      RaceLocked_GuildChampion_RefreshRaceDetails(details, raceTokens, playerRaceToken)
    end
  end)

  root:SetScript('OnSizeChanged', runLayout)
  root:SetScript('OnShow', function()
    runLayout()
    if C_Timer and C_Timer.After then
      C_Timer.After(0, runLayout)
    end
  end)
  runLayout()

  return root, layoutCtx.totalH
end
