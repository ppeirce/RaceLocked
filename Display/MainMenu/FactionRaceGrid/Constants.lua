-- Static layout, copy, and visual data for the faction race grid (settings panel).

RaceLocked_GuildChampion = RaceLocked_GuildChampion or {}

local G = RaceLocked_GuildChampion

G.MID_GAP = 6
G.OUTER_PAD_Y = 4
G.TITLE_TOP_PAD = 8
G.TITLE_ROW_H = 18
G.GAP_AFTER_TITLE = 6
G.STATS_ROW_H = 46
G.ROW_GAP = 6
G.GAP_AFTER_GRID = 6
G.REFRESH_ROW_H = 26
G.EXPLAIN_TOP_GAP = 8
G.FOOTER_TOP_GAP = 8
G.INNER_PAD = 8

G.EXPLAIN_TEXT =
  'Race Locked will automatically remove you from groups that contain players from other races to your own.\n\nThe race averages compute the average level of each race in your faction.'

G.ACCENT_W = 3
G.ACCENT_INSET_X = 3
G.ACCENT_INSET_Y = 1
G.FACTION_ICON_SIZE = 28
G.GAP_AFTER_ACCENT = 7
G.GAP_AFTER_ICON = 6

G.LABEL_GOLD = { 1, 0.92, 0.62 }
G.MUTED = { 0.62, 0.6, 0.55 }

G.AP_BG = { r = 0.08, g = 0.1, b = 0.14, a = 0.94 }
G.AP_BORDER = { r = 0.38, g = 0.45, b = 0.52, a = 0.88 }

--- Per-race crests under Interface\Icons (glue CharacterCreate assets are not usable from addons).
--- @type table<string, string>
G.RACE_ICON_TEXTURE = {
  Human = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Human',
  Dwarf = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Dwarf',
  NightElf = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Nightelf',
  Gnome = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Gnome',
  Orc = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Orc',
  Troll = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Troll',
  Tauren = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Tauren',
  Scourge = 'Interface\\Icons\\INV_Misc_Tournaments_Symbol_Scourge',
}

G.CELL_BACKDROP = {
  bgFile = 'Interface\\Buttons\\WHITE8x8',
  edgeFile = 'Interface\\Tooltips\\UI-Tooltip-Border',
  tile = false,
  edgeSize = 8,
  insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

-- Per-race accent (left bar); order matches panes 1–4 for that faction.
G.ALLIANCE_RACE_ACCENT = {
  { 0.78, 0.52, 0.28 }, -- Dwarf
  { 0.52, 0.35, 0.82 }, -- Night Elf
  { 0.72, 0.62, 0.42 }, -- Human
  { 0.88, 0.45, 0.72 }, -- Gnome
}

G.HORDE_RACE_ACCENT = {
  { 0.32, 0.72, 0.28 }, -- Orc
  { 0.18, 0.58, 0.85 }, -- Troll
  { 0.68, 0.48, 0.32 }, -- Tauren
  { 0.42, 0.68, 0.52 }, -- Undead
}
