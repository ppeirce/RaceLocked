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
    druids = { count = 0, averageLevel = 0 },
    rogues = { count = 0, averageLevel = 0 },
    hunters = { count = 0, averageLevel = 0 },
    warriors = { count = 0, averageLevel = 0 },
    mages = { count = 0, averageLevel = 0 },
    priests = { count = 0, averageLevel = 0 },
    warlocks = { count = 0, averageLevel = 0 },
    paladins = { count = 0, averageLevel = 0 },
    shamans = { count = 0, averageLevel = 0 },
  }
end

local function classWireCount(classEntry)
  if type(classEntry) == 'table' then
    return tonumber(classEntry.count) or 0
  end
  return tonumber(classEntry) or 0
end

local function classWireAverage(classEntry)
  if type(classEntry) == 'table' then
    return tonumber(classEntry.averageLevel) or 0
  end
  return 0
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
  local deaths = tonumber(row.guildDeaths) or 0
  return table.concat({
    'v4',
    tostring(raceToken or ''),
    Comms.SanitizeGuildName(row.guildName or ''),
    tostring(tonumber(row.guildSize) or 0),
    tostring(tonumber(row.averageLevel) or 0),
    tostring(classWireCount(c.druids)),
    tostring(classWireAverage(c.druids)),
    tostring(classWireCount(c.rogues)),
    tostring(classWireAverage(c.rogues)),
    tostring(classWireCount(c.hunters)),
    tostring(classWireAverage(c.hunters)),
    tostring(classWireCount(c.warriors)),
    tostring(classWireAverage(c.warriors)),
    tostring(classWireCount(c.mages)),
    tostring(classWireAverage(c.mages)),
    tostring(classWireCount(c.priests)),
    tostring(classWireAverage(c.priests)),
    tostring(classWireCount(c.warlocks)),
    tostring(classWireAverage(c.warlocks)),
    tostring(classWireCount(c.paladins)),
    tostring(classWireAverage(c.paladins)),
    tostring(classWireCount(c.shamans)),
    tostring(classWireAverage(c.shamans)),
    tostring(ts),
    tostring(deaths),
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
  local guildDeaths = 0
  if wireVersion == 'v4' and #p >= 25 then
    timestamp = tonumber(p[24]) or 0
    guildDeaths = tonumber(p[25]) or 0
  elseif wireVersion == 'v3' and #p >= 24 then
    timestamp = tonumber(p[24]) or 0
  elseif wireVersion == 'v2' and #p >= 15 then
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
    classes = (wireVersion == 'v3' or wireVersion == 'v4') and {
      druids = { count = tonumber(p[6]) or 0, averageLevel = tonumber(p[7]) or 0 },
      rogues = { count = tonumber(p[8]) or 0, averageLevel = tonumber(p[9]) or 0 },
      hunters = { count = tonumber(p[10]) or 0, averageLevel = tonumber(p[11]) or 0 },
      warriors = { count = tonumber(p[12]) or 0, averageLevel = tonumber(p[13]) or 0 },
      mages = { count = tonumber(p[14]) or 0, averageLevel = tonumber(p[15]) or 0 },
      priests = { count = tonumber(p[16]) or 0, averageLevel = tonumber(p[17]) or 0 },
      warlocks = { count = tonumber(p[18]) or 0, averageLevel = tonumber(p[19]) or 0 },
      paladins = { count = tonumber(p[20]) or 0, averageLevel = tonumber(p[21]) or 0 },
      shamans = { count = tonumber(p[22]) or 0, averageLevel = tonumber(p[23]) or 0 },
    } or {
      druids = { count = tonumber(p[6]) or 0, averageLevel = 0 },
      rogues = { count = tonumber(p[7]) or 0, averageLevel = 0 },
      hunters = { count = tonumber(p[8]) or 0, averageLevel = 0 },
      warriors = { count = tonumber(p[9]) or 0, averageLevel = 0 },
      mages = { count = tonumber(p[10]) or 0, averageLevel = 0 },
      priests = { count = tonumber(p[11]) or 0, averageLevel = 0 },
      warlocks = { count = tonumber(p[12]) or 0, averageLevel = 0 },
      paladins = { count = tonumber(p[13]) or 0, averageLevel = 0 },
      shamans = { count = tonumber(p[14]) or 0, averageLevel = 0 },
    },
    timestamp = timestamp,
    guildDeaths = guildDeaths,
  }
end
