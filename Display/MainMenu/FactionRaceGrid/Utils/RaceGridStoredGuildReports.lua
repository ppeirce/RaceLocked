-- Per-race guild slots for the race grid: hardcoded guild names, numeric fields start at 0.
-- Update `RaceLocked_GuildChampion.RACE_GRID_STORED_GUILD_REPORTS_BY_RACE` from addon messages or other code;
-- the whitelist is derived from these names (see AllowedRaceGridGuildNames.lua).

RaceLocked_GuildChampion = RaceLocked_GuildChampion or {}
local G = RaceLocked_GuildChampion

local function zeroClasses()
  return {
    druids = 0,
    rogues = 0,
    hunters = 0,
    warriors = 0,
    mages = 0,
    priests = 0,
    warlocks = 0,
    paladins = 0,
    shamans = 0,
  }
end

local function guildRow(guildName)
  return {
    guildName = guildName,
    guildSize = 0,
    averageLevel = 0,
    classes = zeroClasses(),
  }
end

--- @type table<string, table[]>
local DEFAULT_RACE_GRID_STORED_GUILD_REPORTS_BY_RACE = {
  Human = {
    guildRow('Human Error'),
    guildRow('Honorcore'),
  },
  NightElf = {
    guildRow('ELFCORE'),
  },
  Dwarf = {
    guildRow('STONECORE'),
    guildRow('ROCKCORE'),
  },
  Gnome = {
    guildRow('FOR GNOMEREGAN'),
  },
  Orc = {
    guildRow('ZUGCORE'),
  },
  Troll = {
    guildRow('Hardingo'),
  },
  Tauren = {
    guildRow('HERDCORE'),
  },
  Scourge = {
    guildRow('DEADCORE'),
  },
}

local function copyClasses(classes)
  local src = type(classes) == 'table' and classes or {}
  local c = zeroClasses()
  for k, _ in pairs(c) do
    c[k] = tonumber(src[k]) or 0
  end
  return c
end

local function coerceGuildRow(row, defaultRow)
  local src = type(row) == 'table' and row or {}
  return {
    guildName = defaultRow.guildName,
    guildSize = tonumber(src.guildSize) or 0,
    averageLevel = tonumber(src.averageLevel) or 0,
    classes = copyClasses(src.classes),
  }
end

local function buildStoredGuildReportsByRace(savedByRace)
  local out = {}
  local saved = type(savedByRace) == 'table' and savedByRace or {}
  for raceToken, defaults in pairs(DEFAULT_RACE_GRID_STORED_GUILD_REPORTS_BY_RACE) do
    out[raceToken] = {}
    local savedRows = type(saved[raceToken]) == 'table' and saved[raceToken] or {}
    for i = 1, #defaults do
      local defaultRow = defaults[i]
      out[raceToken][i] = coerceGuildRow(savedRows[i], defaultRow)
    end
  end
  return out
end

local function ensureStoredGuildReportsDB()
  RaceLockedDB = RaceLockedDB or {}
  RaceLockedDB.raceGridStoredGuildReportsByRace =
    buildStoredGuildReportsByRace(RaceLockedDB.raceGridStoredGuildReportsByRace)
  G.RACE_GRID_STORED_GUILD_REPORTS_BY_RACE = RaceLockedDB.raceGridStoredGuildReportsByRace
end

ensureStoredGuildReportsDB()
