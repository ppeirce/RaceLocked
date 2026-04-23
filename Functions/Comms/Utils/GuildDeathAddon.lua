-- Guild-death events over RaceLockedDataBus so all listeners can increment matching guild rows.

RaceLocked_GuildChampion = RaceLocked_GuildChampion or {}

RaceLocked_GuildChampion.GUILD_DEATH_ADDON_PREFIX = 'RLGuildDeath'

local function sendGuildDeathPing()
  if not IsInGuild or not IsInGuild() then
    return
  end
  if not RaceLocked_GuildChampion_GetNormalizedPlayerGuildName then
    return
  end
  local ownGuildName = GetGuildInfo and GetGuildInfo('player') or ''
  if type(ownGuildName) ~= 'string' or ownGuildName == '' then
    return
  end
  local raceToken = ''
  if UnitRace then
    local _, token = UnitRace('player')
    raceToken = tostring(token or '')
  end
  if raceToken == '' then
    return
  end
  local channelId = RaceLocked_GuildChampion.Comms and RaceLocked_GuildChampion.Comms.EnsureDataChannelJoined
    and RaceLocked_GuildChampion.Comms.EnsureDataChannelJoined()
    or 0
  if channelId <= 0 then
    return
  end
  local payload = RaceLocked_GuildChampion.Comms.BuildGuildDeathPayload
    and RaceLocked_GuildChampion.Comms.BuildGuildDeathPayload(ownGuildName, raceToken)
    or nil
  if not payload or payload == '' then
    return
  end
  print('|cffffffffRace Locked|r: Sending guild death event on RaceLockedDataBus.')
  RaceLocked_GuildChampion.Comms.SendRaceGridChannelLine(channelId, payload)
end

--- Call on local `PLAYER_DEAD` while in a guild (after incrementing stored counts).
function RaceLocked_GuildChampion_BroadcastGuildDeathPing()
  sendGuildDeathPing()
end

function RaceLocked_GuildChampion_EnsureGuildDeathAddonPrefixRegistered()
  -- Legacy no-op: death events now use the RaceLockedDataBus channel payload.
end
