-- Guild Champion summary above the settings leaderboard table.

local PAD_X = 10
local PAD_Y = 7
local CHAMPION_ROW_H = 24
local AP_ROW_H = 18
local ROW_GAP = 3

local LABEL_GOLD = { 1, 0.92, 0.62 }
local NAME_COLOR = { 0.95, 0.93, 0.88 }
local MUTED = { 0.62, 0.6, 0.55 }

--- @param parent Frame
--- @param sortedRows table[]|nil same sort as leaderboard (#1 = top rank)
--- @param rightInset number align with leaderboard panel (e.g. PANEL_RIGHT_INSET)
--- @return number total height including internal padding
function RaceLocked_CreateGuildChampionSection(parent, sortedRows, rightInset)
  rightInset = rightInset or 0

  local topRank = sortedRows and sortedRows[1] or nil
  local topAp = nil
  if RaceLocked_GetTopAchievementPointsLeaderboardRowFromRows then
    topAp = RaceLocked_GetTopAchievementPointsLeaderboardRowFromRows(sortedRows)
  end

  local root = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
  root:SetPoint('TOPLEFT', parent, 'TOPLEFT', 0, 0)
  root:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', -rightInset, 0)
  root:SetBackdrop({
    bgFile = 'Interface\\Buttons\\WHITE8x8',
    edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
    tile = false,
    edgeSize = 10,
    insets = { left = 2, right = 2, top = 2, bottom = 2 },
  })
  root:SetBackdropColor(0.06, 0.055, 0.05, 0.95)
  root:SetBackdropBorderColor(0.45, 0.4, 0.3, 0.85)

  local totalH = PAD_Y * 2 + CHAMPION_ROW_H + ROW_GAP + AP_ROW_H
  root:SetHeight(totalH)

  local row1 = CreateFrame('Frame', nil, root)
  row1:SetHeight(CHAMPION_ROW_H)
  row1:SetPoint('TOPLEFT', root, 'TOPLEFT', PAD_X, -PAD_Y)
  row1:SetPoint('TOPRIGHT', root, 'TOPRIGHT', -PAD_X, -PAD_Y)

  local labelChampion = row1:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
  labelChampion:SetPoint('LEFT', row1, 'LEFT', 0, 0)
  labelChampion:SetText('Guild Champion')
  labelChampion:SetTextColor(LABEL_GOLD[1], LABEL_GOLD[2], LABEL_GOLD[3])

  local nameChampion = row1:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
  nameChampion:SetPoint('LEFT', labelChampion, 'RIGHT', 10, 0)
  nameChampion:SetPoint('RIGHT', row1, 'RIGHT', 0, 0)
  nameChampion:SetJustifyH('RIGHT')
  if topRank and topRank.name and topRank.name ~= '' then
    nameChampion:SetText(tostring(topRank.name))
    nameChampion:SetTextColor(NAME_COLOR[1], NAME_COLOR[2], NAME_COLOR[3])
  else
    nameChampion:SetText('—')
    nameChampion:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
  end

  local row2 = CreateFrame('Frame', nil, root)
  row2:SetHeight(AP_ROW_H)
  row2:SetPoint('TOPLEFT', row1, 'BOTTOMLEFT', 0, -ROW_GAP)
  row2:SetPoint('TOPRIGHT', row1, 'BOTTOMRIGHT', 0, -ROW_GAP)

  local labelAp = row2:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
  labelAp:SetPoint('LEFT', row2, 'LEFT', 0, 1)
  labelAp:SetJustifyH('LEFT')
  labelAp:SetText('Highest achievement points')
  labelAp:SetTextColor(LABEL_GOLD[1] * 0.9, LABEL_GOLD[2] * 0.9, LABEL_GOLD[3] * 0.9)

  local detailAp = row2:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
  detailAp:SetPoint('LEFT', labelAp, 'RIGHT', 8, 0)
  detailAp:SetPoint('RIGHT', row2, 'RIGHT', 0, 1)
  detailAp:SetJustifyH('RIGHT')
  if topAp and topAp.name and topAp.name ~= '' then
    detailAp:SetText(string.format('%s  ·  %s', tostring(topAp.name), tostring(topAp.achievementPoints or 0)))
    detailAp:SetTextColor(0.86, 0.84, 0.78)
  else
    detailAp:SetText('—')
    detailAp:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
  end

  return totalH
end
