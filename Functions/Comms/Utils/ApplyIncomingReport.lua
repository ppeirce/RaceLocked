RaceLocked_GuildChampion = RaceLocked_GuildChampion or {}
local G = RaceLocked_GuildChampion

G.Comms = G.Comms or {}
local Comms = G.Comms

function Comms.ApplyIncomingReport(report)
  if not report then
    return false
  end
  local minN = G.MIN_GUILD_MEMBERS_FOR_RACE_GRID
  if RaceLocked_GuildChampion_GetMinGuildMembersForRaceGrid then
    minN = RaceLocked_GuildChampion_GetMinGuildMembersForRaceGrid(report.guildName)
  end
  minN = tonumber(minN) or 500
  if (tonumber(report.guildSize) or 0) < minN then
    return false
  end
  if RaceLocked_GuildChampion_EnsureStoredGuildReportsDB then
    RaceLocked_GuildChampion_EnsureStoredGuildReportsDB()
  end
  if not RaceLocked_GuildChampion_IsGuildNameAllowedForRaceGrid then
    return false
  end
  if not RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid then
    return false
  end
  if not RaceLocked_GuildChampion_IsGuildNameAllowedForRaceGrid(report.guildName) then
    return false
  end

  local rows = G.RACE_GRID_STORED_GUILD_REPORTS_BY_RACE and G.RACE_GRID_STORED_GUILD_REPORTS_BY_RACE[report.raceToken]
  if type(rows) ~= 'table' then
    return false
  end

  local incomingNorm = RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid(report.guildName)
  if incomingNorm == '' then
    return false
  end
  if RaceLocked_GuildChampion_GetNormalizedPlayerGuildName
    and RaceLocked_GuildChampion_MeetsMinGuildMembersForRaceGrid
  then
    local ownGuildNorm = RaceLocked_GuildChampion_GetNormalizedPlayerGuildName()
    if ownGuildNorm ~= '' and incomingNorm == ownGuildNorm
      and not RaceLocked_GuildChampion_MeetsMinGuildMembersForRaceGrid()
    then
      return false
    end
  end

  local incomingTs = tonumber(report.timestamp) or 0

  for _, row in ipairs(rows) do
    if type(row) == 'table' then
      local rowNorm = RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid(row.guildName)
      if rowNorm ~= '' and rowNorm == incomingNorm then
        local storedTs = tonumber(row.timestamp) or 0
        local accept = incomingTs > storedTs
        if not accept and incomingTs == 0 and storedTs == 0 then
          accept = true
        end
        if not accept then
          return false
        end
        row.guildSize = report.guildSize
        row.averageLevel = report.averageLevel
        row.classes = report.classes or Comms.EmptyClasses()
        row.timestamp = incomingTs
        local incomingDeaths = tonumber(report.guildDeaths) or 0
        local storedDeaths = tonumber(row.guildDeaths) or 0
        if incomingDeaths > storedDeaths then
          row.guildDeaths = incomingDeaths
        end
        if RaceLocked_GuildChampion_PersistStoredGuildReportsByRace then
          RaceLocked_GuildChampion_PersistStoredGuildReportsByRace()
        end
        if RaceLocked_GuildChampion_RequestRaceGridRerender then
          RaceLocked_GuildChampion_RequestRaceGridRerender()
        end
        return true
      end
    end
  end
  return false
end

--- Apply a guild-death event coming from the RaceLockedDataBus channel.
--- @param event table { guildName: string, raceToken: string }
--- @return boolean
function Comms.ApplyIncomingGuildDeath(event)
  if type(event) ~= 'table' then
    return false
  end
  local guildName = event.guildName
  local raceToken = event.raceToken
  if type(guildName) ~= 'string' or guildName == '' or type(raceToken) ~= 'string' or raceToken == '' then
    return false
  end
  if RaceLocked_GuildChampion_EnsureStoredGuildReportsDB then
    RaceLocked_GuildChampion_EnsureStoredGuildReportsDB()
  end
  if not RaceLocked_GuildChampion_IsGuildNameAllowedForRaceGrid then
    return false
  end
  if not RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid then
    return false
  end
  if not RaceLocked_GuildChampion_IsGuildNameAllowedForRaceGrid(guildName) then
    return false
  end

  local rows = G.RACE_GRID_STORED_GUILD_REPORTS_BY_RACE and G.RACE_GRID_STORED_GUILD_REPORTS_BY_RACE[raceToken]
  if type(rows) ~= 'table' then
    return false
  end
  local incomingNorm = RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid(guildName)
  if incomingNorm == '' then
    return false
  end

  for _, row in ipairs(rows) do
    if type(row) == 'table' then
      local rowNorm = RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid(row.guildName)
      if rowNorm ~= '' and rowNorm == incomingNorm then
        row.guildDeaths = (tonumber(row.guildDeaths) or 0) + 1
        print(
          string.format(
            '|cffffffffRace Locked|r: Received bus death event for %s (%s), incrementing guild deaths.',
            tostring(guildName),
            tostring(raceToken)
          )
        )
        if RaceLocked_GuildChampion_PersistStoredGuildReportsByRace then
          RaceLocked_GuildChampion_PersistStoredGuildReportsByRace()
        end
        if RaceLocked_GuildChampion_RequestRaceGridRerender then
          RaceLocked_GuildChampion_RequestRaceGridRerender()
        end
        return true
      end
    end
  end
  return false
end
