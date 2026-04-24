--- Hook into HardcoreAchievements to track per-player achievement points,
--- share them within the guild via addon messages, and make the guild average
--- available for the race grid broadcast.

local ADDON_PREFIX = 'RLGuildAch'
local thisAddonName = ...

local lastKnownTotalPoints = nil

local function registerPrefix()
  if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(ADDON_PREFIX)
  elseif RegisterAddonMessagePrefix then
    RegisterAddonMessagePrefix(ADDON_PREFIX)
  end
end

local function getPlayerGuildName()
  if not IsInGuild or not IsInGuild() or not GetGuildInfo then
    return nil
  end
  local guildName = GetGuildInfo('player')
  if type(guildName) ~= 'string' or guildName == '' then
    return nil
  end
  return guildName
end

local function getPlayerName()
  if not UnitName then
    return nil
  end
  local name = UnitName('player')
  if type(name) ~= 'string' or name == '' then
    return nil
  end
  return name
end

local function isSenderLocalPlayer(sender)
  if type(sender) ~= 'string' or sender == '' then
    return false
  end
  if GetUnitName then
    local full = GetUnitName('player', true)
    if full and full ~= '' and sender == full then
      return true
    end
  end
  if UnitName then
    return sender == UnitName('player')
  end
  return false
end

local function broadcastPointsToGuild(totalPoints)
  if not IsInGuild or not IsInGuild() then
    return
  end
  local send = SendAddonMessage or (C_ChatInfo and C_ChatInfo.SendAddonMessage)
  if not send then
    return
  end
  send(ADDON_PREFIX, tostring(totalPoints or 0), 'GUILD')
end

local function storeOwnPoints(totalPoints)
  local guildName = getPlayerGuildName()
  local playerName = getPlayerName()
  if not guildName or not playerName then
    return
  end
  if RaceLocked_AchievementTracking_SetPlayerPoints then
    RaceLocked_AchievementTracking_SetPlayerPoints(guildName, playerName, totalPoints)
  end
end

--- Read the player's current total points from HardcoreAchievements if available.
--- Falls back to scraping the UI frame text since the hook API (see below) is not
--- yet exposed by the current release of HardcoreAchievements. This is the primary
--- method used today -- called on each manual sync.
--- @return number|nil
local function queryHardcoreAchievementPoints()
  if HardcoreAchievementsFrame and HardcoreAchievementsFrame.TotalPoints then
    local tp = HardcoreAchievementsFrame.TotalPoints
    if tp.GetText then
      return tonumber(tp:GetText())
    end
  end
  return nil
end

--- Attempt to install a real-time hook into HardcoreAchievements so points are
--- automatically updated whenever the player earns an achievement, without needing
--- a manual sync.
---
--- STATUS: HardcoreAchievements documents an OnAchievement hook via
--- HardcoreAchievements_Hooks:HookScript, but the current release does NOT expose
--- the HardcoreAchievements_Hooks global. This function will silently return false
--- until a future HA update creates that global. When it does, this will "just work"
--- and start auto-broadcasting points on each achievement earned.
local function installHardcoreAchievementsHook()
  if not HardcoreAchievements_Hooks then
    return false
  end
  HardcoreAchievements_Hooks:HookScript('OnAchievement', function(achievementData)
    if type(achievementData) ~= 'table' then
      return
    end
    local totalPoints = tonumber(achievementData.totalPoints) or 0
    lastKnownTotalPoints = totalPoints
    storeOwnPoints(totalPoints)
    broadcastPointsToGuild(totalPoints)
  end)
  return true
end

local function onAddonMessage(prefix, message, channel, sender)
  if prefix ~= ADDON_PREFIX then
    return
  end
  if not IsInGuild or not IsInGuild() then
    return
  end
  if isSenderLocalPlayer(sender) then
    return
  end
  local totalPoints = tonumber(message)
  if not totalPoints then
    return
  end
  local guildName = getPlayerGuildName()
  if not guildName then
    return
  end
  local senderName = sender
  local dash = string.find(senderName, '-', 1, true)
  if dash and dash > 1 then
    senderName = string.sub(senderName, 1, dash - 1)
  end
  if RaceLocked_AchievementTracking_SetPlayerPoints then
    RaceLocked_AchievementTracking_SetPlayerPoints(guildName, senderName, totalPoints)
  end
end

--- Query HardcoreAchievements for current points, store locally, and broadcast to guild.
--- Called from the sync button before the roster scan so the average is up to date.
function RaceLocked_AchievementTracking_SyncOwnPoints()
  local live = queryHardcoreAchievementPoints()
  if live and live > 0 then
    lastKnownTotalPoints = live
    storeOwnPoints(live)
    broadcastPointsToGuild(live)
    return
  end
  local guildName = getPlayerGuildName()
  local playerName = getPlayerName()
  if guildName and playerName and RaceLocked_AchievementTracking_GetPlayerPoints then
    local stored = RaceLocked_AchievementTracking_GetPlayerPoints(guildName, playerName)
    if lastKnownTotalPoints then
      stored = lastKnownTotalPoints
    end
    if stored and stored > 0 then
      broadcastPointsToGuild(stored)
    end
  end
end

-- Retry the hook install on ADDON_LOADED (each addon) and PLAYER_ENTERING_WORLD
-- because HardcoreAchievements may load after us. Once the hook is installed we
-- stop trying. Until then, manual sync via queryHardcoreAchievementPoints is the
-- only way to pick up points.
local hookInstalled = false

local service = CreateFrame('Frame')
service:RegisterEvent('ADDON_LOADED')
service:RegisterEvent('PLAYER_ENTERING_WORLD')
service:RegisterEvent('CHAT_MSG_ADDON')
service:SetScript('OnEvent', function(_, event, ...)
  if event == 'ADDON_LOADED' then
    local loadedAddonName = ...
    if loadedAddonName == thisAddonName then
      registerPrefix()
    end
    if not hookInstalled then
      hookInstalled = installHardcoreAchievementsHook()
    end
    return
  end
  if event == 'PLAYER_ENTERING_WORLD' then
    if not hookInstalled then
      hookInstalled = installHardcoreAchievementsHook()
    end
    return
  end
  if event == 'CHAT_MSG_ADDON' then
    onAddonMessage(...)
    return
  end
end)
