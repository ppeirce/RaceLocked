RaceLocked_GuildChampion = RaceLocked_GuildChampion or {}
local G = RaceLocked_GuildChampion
local thisAddonName = ...

G.Comms = G.Comms or {}
local Comms = G.Comms

function RaceLocked_GuildChampion_BroadcastOwnGuildRaceGridReports()
  if not RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid then
    return
  end
  local channelId = Comms.EnsureDataChannelJoined()
  if channelId <= 0 then
    return
  end
  local ownGuildNorm = ''
  if RaceLocked_GuildChampion_GetNormalizedPlayerGuildName then
    ownGuildNorm = RaceLocked_GuildChampion_GetNormalizedPlayerGuildName() or ''
  end
  local canStampOwnGuild = ownGuildNorm ~= ''
    and (not RaceLocked_GuildChampion_MeetsMinGuildMembersForRaceGrid or RaceLocked_GuildChampion_MeetsMinGuildMembersForRaceGrid())
  local now = (GetServerTime and GetServerTime()) or time()
  local stampedOwn = false

  for raceToken, rows in pairs(G.RACE_GRID_STORED_GUILD_REPORTS_BY_RACE or {}) do
    if type(rows) == 'table' then
      for _, row in ipairs(rows) do
        if type(row) == 'table' then
          local rowNorm = RaceLocked_GuildChampion_NormalizeGuildNameForRaceGrid(row.guildName)
          if canStampOwnGuild and rowNorm ~= '' and rowNorm == ownGuildNorm then
            row.timestamp = now
            stampedOwn = true
          end
          local payload = Comms.BuildPayload(raceToken, row)
          if payload and payload ~= '' then
            Comms.SendRaceGridChannelLine(channelId, payload)
          end
        end
      end
    end
  end

  if stampedOwn and RaceLocked_GuildChampion_PersistStoredGuildReportsByRace then
    RaceLocked_GuildChampion_PersistStoredGuildReportsByRace()
  end
end

local service = CreateFrame('Frame')
local hasEnteredWorld = false

service:RegisterEvent('ADDON_LOADED')
service:RegisterEvent('PLAYER_ENTERING_WORLD')
service:RegisterEvent('CHAT_MSG_CHANNEL')
service:RegisterEvent('CHANNEL_UI_UPDATE')
service:SetScript('OnEvent', function(_, event, ...)
  if event == 'ADDON_LOADED' then
    local loadedAddonName = ...
    if loadedAddonName == thisAddonName then
      if RaceLocked_GuildChampion_EnsureStoredGuildReportsDB then
        RaceLocked_GuildChampion_EnsureStoredGuildReportsDB()
      end
      Comms.InstallChannelNoticeFilters()
      -- Drop any client-restored persistent bus before normal channels claim their slots.
      Comms.LeaveDataChannel()
    end
    return
  end
  if event == 'PLAYER_ENTERING_WORLD' then
    hasEnteredWorld = true
    Comms.ScheduleDelayedDataChannelJoin()
    return
  end
  if event == 'CHANNEL_UI_UPDATE' then
    if not hasEnteredWorld then
      -- Pre-world: any restored data bus is stale, regardless of channel-list state.
      Comms.LeaveDataChannel()
      return
    end
    if Comms.GetDataChannelId() > 0 then
      if Comms.LeaveDataChannelIfAlone() then
        return
      end
      Comms.HideDataChannelFromChatWindows()
      return
    end
    Comms.ScheduleDelayedDataChannelJoin()
    return
  end
  if event == 'CHAT_MSG_CHANNEL' then
    if not Comms.IsOurDataChannelMessage(...) then
      return
    end
    local msg = select(1, ...)
    local report = Comms.ParsePayload(msg)
    if not report then
      return
    end
    -- Keep incoming reports persisted, but do not force live UI rerenders;
    -- the race grid redraw is user-driven from Apply Update.
    Comms.ApplyIncomingReport(report)
  end
end)
