RaceLocked_GuildChampion = RaceLocked_GuildChampion or {}
local G = RaceLocked_GuildChampion

G.Comms = G.Comms or {}
local Comms = G.Comms

Comms.PREFIX = 'RLRaceGridV1'
Comms.CHANNEL_NAME = 'RaceLockedDataBus'
Comms.WIRE_FIELD_SEP = '\001'

function Comms.BytesToHex(s)
  if type(s) ~= 'string' or s == '' then
    return ''
  end
  local t = {}
  for i = 1, #s do
    t[i] = string.format('%02x', string.byte(s, i))
  end
  return table.concat(t)
end

function Comms.HexToBytes(h)
  if type(h) ~= 'string' or h == '' or #h % 2 ~= 0 then
    return nil
  end
  local t = {}
  for i = 1, #h, 2 do
    local b = tonumber(string.sub(h, i, i + 1), 16)
    if not b then
      return nil
    end
    t[#t + 1] = string.char(b)
  end
  return table.concat(t)
end

function Comms.EmptyClasses()
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

function Comms.SanitizeGuildName(name)
  local s = tostring(name or '')
  s = s:gsub('|', '/')
  s = s:gsub(Comms.WIRE_FIELD_SEP, '')
  return s
end

function Comms.BuildPayload(raceToken, row)
  if type(row) ~= 'table' then
    return nil
  end
  local c = row.classes or Comms.EmptyClasses()
  local ts = tonumber(row.timestamp) or 0
  return table.concat({
    'v2',
    tostring(raceToken or ''),
    Comms.SanitizeGuildName(row.guildName or ''),
    tostring(tonumber(row.guildSize) or 0),
    tostring(tonumber(row.averageLevel) or 0),
    tostring(tonumber(c.druids) or 0),
    tostring(tonumber(c.rogues) or 0),
    tostring(tonumber(c.hunters) or 0),
    tostring(tonumber(c.warriors) or 0),
    tostring(tonumber(c.mages) or 0),
    tostring(tonumber(c.priests) or 0),
    tostring(tonumber(c.warlocks) or 0),
    tostring(tonumber(c.paladins) or 0),
    tostring(tonumber(c.shamans) or 0),
    tostring(ts),
  }, Comms.WIRE_FIELD_SEP)
end

function Comms.ParsePayload(msg)
  if type(msg) ~= 'string' or msg == '' then
    return nil
  end

  local headHex = Comms.PREFIX .. ':'
  if string.sub(msg, 1, #headHex) ~= headHex then
    return nil
  end
  local inner = Comms.HexToBytes(string.sub(msg, #headHex + 1))
  if type(inner) ~= 'string' or inner == '' then
    return nil
  end

  local p = { strsplit(Comms.WIRE_FIELD_SEP, inner) }
  if #p < 14 then
    return nil
  end

  local wireVersion = p[1]
  local timestamp = 0
  if wireVersion == 'v2' and #p >= 15 then
    timestamp = tonumber(p[15]) or 0
  elseif wireVersion == 'v1' and #p >= 14 then
    timestamp = 0
  else
    return nil
  end

  local raceToken = p[2]
  local guildName = p[3]
  if raceToken == '' or guildName == '' then
    return nil
  end

  return {
    wireVersion = wireVersion,
    raceToken = raceToken,
    guildName = guildName,
    guildSize = tonumber(p[4]) or 0,
    averageLevel = tonumber(p[5]) or 0,
    classes = {
      druids = tonumber(p[6]) or 0,
      rogues = tonumber(p[7]) or 0,
      hunters = tonumber(p[8]) or 0,
      warriors = tonumber(p[9]) or 0,
      mages = tonumber(p[10]) or 0,
      priests = tonumber(p[11]) or 0,
      warlocks = tonumber(p[12]) or 0,
      paladins = tonumber(p[13]) or 0,
      shamans = tonumber(p[14]) or 0,
    },
    timestamp = timestamp,
  }
end
