------------- ABOUT
-- SimpleBench Roblox Loader
-- Loads the Simple Pure Lua VM Benchmarking Library, with some extra features
-- Version: 1.1.2-DEV
-- Author: Expo#3961
-- License: MIT
-- https://github.com/AstolfoBrew/SimpleBench
------------- DEFAULTS
local Settings = { ['RBXWaitAfterRun'] = false, ['Iterations'] = 50, ['Branch'] = 'Release', ['Silent'] = false }
------------- CODE
if not string or not string.split then
  error '{SimpleBench-Loader} ~ Missing string?.split - Please use the regular SimpleBench.'
end
if not string or not string.lower then
  error '{SimpleBench-Loader} ~ Missing string?.lower - Please use the regular SimpleBench.'
end
if not loadstring then
  error '{SimpleBench-Loader} ~ Missing loadstring - Please use the regular SimpleBench.'
end
if not game then
  error '{SimpleBench-Loader} ~ Missing game - Please run this in a Roblox Executor Environment'
end

local Args = { ... }
if Args[1] then
  for k, v in pairs(Args[1]) do
    if typeof(Settings[k]) == typeof(v) or typeof(Settings[k]) == 'nil' then
      Settings[k] = v
    else
      error(string.format('Invalid Settings Type: Expected %s, got %s for setting', typeof(Settings[k]), typeof(v), k))
    end
  end
end
_G.SimpleBenchSettings = Settings

local Repo = Args[2] or 'AstolfoBrew/SimpleBench'
local RepoSplit = { 'AstolfoBrew', 'SimpleBench' }
if string.split then
  RepoSplit = string.split(Repo, '/')
end

local RepoOwner = RepoSplit[1] or 'AstolfoBrew'
local RepoName = RepoSplit[2] or 'SimpleBench'
local ExecInfoUrl = string.format(
  'https://raw.githubusercontent.com/%s/%s/%s/RBXExecutorInfo.lua',
  RepoOwner,
  RepoName,
  (Settings.Branch == 'Release' or string.sub(Settings.Branch, 1, 1) == 'v') and 'main' or Settings.Branch
)
local ExecInfoSrc = game:HttpGetAsync(ExecInfoUrl)
local ScriptUrl = Settings.Branch == 'Release'
    and string.format('https://github.com/%s/%s/releases/latest/download/SimpleBench.lua', RepoOwner, RepoName)
  or string.sub(Settings.Branch, 1, 1) == 'v' and string.format(
    'https://github.com/%s/%s/releases/download/%s/SimpleBench.lua',
    RepoOwner,
    RepoName,
    string.sub(Settings.Branch, 2, #Settings.Branch)
  )
  or string.format('https://raw.githubusercontent.com/%s/%s/%s/SimpleBench.lua', RepoOwner, RepoName, Settings.Branch)
local ScriptSrc = game:HttpGetAsync(ScriptUrl)

local ExecInfoSrcChunk, Err = loadstring(ExecInfoSrc, 'RBXExecutorInfo.lua')
local ExecInfo
if typeof(ExecInfoSrcChunk) ~= 'function' then
  warn('Error getting Executor Information Chunkname: ', Err or ExecInfoSrcChunk)
  ExecInfo = { ['name'] = 'Unknown' }
else
  ExecInfo = ExecInfoSrcChunk()
end

if _ENV then
  getgenv = function()
    return _ENV
  end
end
if getfenv and not getgenv then
  getgenv = function()
    return getfenv(0)
  end
end

local oldPrint = print
local oldWarn = warn
local oldError = error
local log = ''
if getgenv and writefile then
  pcall(function()
    getgenv().print = function(...)
      log = log .. (table.concat({ ... }, '\t')) .. '\n'
      return oldPrint(...)
    end
    getgenv().warn = function(...)
      log = log .. (table.concat({ 'WARN:', ... }, '\t')) .. '\n'
      return oldWarn(...)
    end
    getgenv().error = function(...)
      log = log .. (table.concat({ 'ERROR:', ... }, '\t')) .. '\n'
      return oldError(...)
    end
  end)
end

print('Running SimpleBench from ' .. Repo)
local FinalScore = loadstring(ScriptSrc, 'SimpleBench.lua')()

if writefile then
  writefile(
    'SimpleBench.log',
    string.format(
      'Final Score:\n%s\n(Lua Version: %s - Executor: %s - Script from %s)\n\n------ LOGS ------\n\n%s',
      tostring(FinalScore),
      _VERSION or 'UNKNOWN',
      ExecInfo.name,
      ScriptUrl,
      log
    )
  )
end

if getgenv and writefile then
  pcall(function()
    getgenv().print = oldPrint
    getgenv().warn = oldWarn
    getgenv().error = oldError
  end)
end

_G.SimpleBenchSettings = nil

return FinalScore
