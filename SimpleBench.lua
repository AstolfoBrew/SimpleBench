------------- ABOUT
-- SimpleBench
-- A Simple Pure Lua VM Benchmarking Library
-- Version: 1.1.2-DEV.2
-- Author: Expo#3961
-- License: MIT
-- https://github.com/AstolfoBrew/SimpleBench
------------- DO NOT TOUCH
local Version = '1.2.0-DEV.1'
print('Setting up configuration for SimpleBench ' .. Version .. ' by Expo#3961')
------------- CONFIG
local Iterations = 50 --               Change to amount of total benchmark runs | Default: 50 | The higher, the longer the benchmark takes, but the more accurate/stable the result
local RBXWaitAfterRun = false --       Enable if, in roblox, an obfuscator (or horrible lua env) freezes for longer than 1s*runs
------------- CODE
local print, warn, error = print, warn, error
-- External Settings
if _G and _G.SimpleBenchSettings then
  local Settings = _G.SimpleBenchSettings
  if typeof(Settings) ~= 'table' then
    return error 'Invalid _G.SimpleBenchSettings.'
  end
  if typeof(Settings.Iterations) == 'number' then
    Iterations = Settings.Iterations
  end
  if typeof(Settings.RBXWaitAfterRun) == 'boolean' or Settings.RBXWaitAfterRun then
    RBXWaitAfterRun = Settings.RBXWaitAfterRun
  end
  if Settings.Branch and Settings.Branch ~= 'Release' then
    warn 'Branch is not release. Results may vary between commits.'
  end
  if typeof(Settings.Silent) == 'table' then
    if typeof(Settings.Silent.print) == 'function' then
      print = Settings.Silent.print
    elseif not Settings.Silent.print then
      print = function() end
    end
    if typeof(Settings.Silent.warn) == 'function' then
      warn = Settings.Silent.warn
    elseif not Settings.Silent.warn then
      warn = function() end
    end
    if typeof(Settings.Silent.error) == 'function' then
      error = Settings.Silent.error
    elseif not Settings.Silent.error then
      error = function() end
    end
  elseif Settings.Silent then
    print = function() end
  end
end
-- Check to make sure Settings are valid
if Iterations < 1 then
  return error 'Too little iterations! Must atleast have 1 iteration.'
end
-- To Hex Utility
local function tohex(num)
  local v = string.format('%02X', num)
  if #v == 1 then
    v = '0' .. v
  end
  return v
end

print '-- Opcode Test'
print '-- -> Tests if the VM is functioning as expected'
print '-- (expected: 0, 1, 2, 3)'
for i = 0, 3, 1 do
  print('loop    0x01    | ', i)
end
print '-- (expected: 1 : 1, 2: 7, 3 : 5)'
local p = { 1, '7', 5 }
for k in pairs(p) do
  print('loop    0x02    | ', k, ':', p[k])
end
print '-- (expected: 1 : 1, 2 : 7, 3 : 5)'
for k, v in ipairs(p) do
  print('loop    0x03    | ', k, ':', v)
end

print '-- (expected: 6)'
print('len     0x04    | ', #'length')

print '-- below are checked for errors'
local failed = {}
local check = (function()
  local code = 4
  local padding = 5
  local paddingRes = 23
  return function(name, res, expected)
    local pres = tostring(res)
    if #name < padding then
      name = name .. string.rep(' ', padding - #name)
    end
    if #pres < paddingRes then
      pres = pres .. string.rep(' ', paddingRes - #pres)
    end
    code = code + 1
    print(name, '0x' .. tohex(code), '|', pres, res == expected and 'Success' or 'Failed with ' .. res)
    if res ~= expected then
      table.insert(failed, { name, '0x' .. tohex(code) })
    end
  end
end)()
check('general', 1, 1)
check('general', 0, 0)
check('general', true, true)
check('general', false, false)
check('general', '', '')
check('general', 'test', 'test')
check('general', nil, nil)
check('concat', 'string1' .. 'string2', 'string1string2')
check('add', 60 + 9, 69)
check(
  'call',
  (function()
    return 'Call Return Value'
  end)(),
  'Call Return Value'
)
check('div', 690 / 10, 69)
check('eq', 5 == 5, true)
local v = 0
v = v + 1
if false then
  v = v - 2
end -- Disable Constant
check('eq', v == 5, false)
v = 0
v = v + 5
check('eq', v == 5, true)
check('ne', 5 ~= 5, false)
check('ne', 1 ~= 5, true)
v = 0
v = v + 5
check('ne', v ~= 5, false)
check('le', v <= 5, true)
check('le', v <= 6, true)
check('le', v <= 1, false)
check('not', not true, false)
check('not', not false, true)

local module = {}
function module:Yeet()
  self.a = 1
  return 2
end
check('oopcall', module:Yeet(), 2)
check('oopprop', module.a, 1)

if #failed == 0 then
  print(string.rep('-', 18))
  print '-- TEST SUCCESS --'
  print(string.rep('-', 18))
else
  local x = #('-- ' .. tostring(#failed) .. ' TEST(s) FAILED --')
  local v = string.rep('-', x)
  print(v)
  print(x)
  print(v)
  for _, o in pairs(failed) do
    print('Test', o[1], '(' .. tostring(o[2]) .. ')', 'Failed')
  end
  print(v)
end
print '\n-- Benchmarks'
local TotalScore = 0
local runBenchmark = function(n, c, cb, div)
  local div = div or 1 -- For proportionally giant scores (such as empty func)
  local padding = 20
  if #n < padding then
    n = n .. string.rep(' ', padding - #n)
  end
  local start = os.clock()
  for i = 0, c, 1 do
    cb()
  end
  local _end = os.clock()
  -- get average
  local avg = (_end - start) / c
  local ThisScore = (1 / avg / c) / div
  print(
    'Benchmark',
    n,
    'Ran ' .. tostring(c) .. ' times with an average duration of ' .. tostring(avg) .. 's/run',
    '(Score: ' .. ThisScore .. ')'
  )
  TotalScore = TotalScore + ThisScore
end

local itPerBench = 262144
local rsw = game and RBXWaitAfterRun and function()
  game:GetService('RunService').RenderStepped:Wait()
end or function() end
-- local BenchmarkStart = os.clock();
local void = function(...) end
-- runBenchmark('Empty Function', 512, function() end)
do
  local i = 679483
  local s = 'abcdefg'
  local iStr = tostring(i)
  for run = 1, Iterations, 1 do
    print('//////// RUN ' .. tostring(run) .. ' OF ' .. tostring(Iterations) .. ' ////////')
    runBenchmark('Empty Function', itPerBench, function() end, 26 / 3)
    runBenchmark('void', itPerBench, function()
      void()
    end, 22 / 3)
    runBenchmark('i+1', itPerBench, function()
      void(i + 1)
    end, 18 / 3)
    runBenchmark('i-1', itPerBench, function()
      void(i - 1)
    end, 18 / 3)
    runBenchmark('i/2', itPerBench, function()
      void(i / 2)
    end, 12 / 3)
    runBenchmark('i*2', itPerBench, function()
      void(i * 2)
    end, 12 / 3)
    runBenchmark('i%2', itPerBench, function()
      void(i % 2)
    end)
    runBenchmark('i^2', itPerBench, function()
      void(i ^ 2)
    end)
    runBenchmark('1/i', itPerBench, function()
      void(1 / i)
    end)
    runBenchmark('sqrt(i)', itPerBench, function()
      void(math.sqrt(i))
    end)
    runBenchmark('tostring(i)', itPerBench, function()
      void(tostring(i))
    end)
    runBenchmark('s..s', itPerBench, function()
      void(s .. s)
    end)
    runBenchmark(
      'index table nil',
      itPerBench,
      (function()
        local t = {}
        return function()
          void(t.a)
        end
      end)()
    )
    runBenchmark(
      'index table str',
      itPerBench,
      (function()
        local t = { ['a'] = '' }
        return function()
          void(t.a)
        end
      end)()
    )
    runBenchmark(
      'newindex table',
      itPerBench,
      (function()
        local t = {}
        return function()
          t['a'] = ''
          void(t)
        end
      end)()
    )
    runBenchmark(
      'index metamethod',
      itPerBench,
      (function()
        local t = setmetatable({}, { __newindex = function() end })
        return function()
          void(t['a'])
        end
      end)()
    )
    runBenchmark(
      'newindex metamethod',
      itPerBench,
      (function()
        local t = setmetatable({}, { __newindex = function() end })
        return function()
          t['a'] = ''
          void(t)
        end
      end)()
    )
    runBenchmark('if', itPerBench, function()
      if true then
        void(true)
      end
    end)
    runBenchmark('for loop', itPerBench, function()
      for loopIterator = 0, 1, 1 do
        void(loopIterator)
      end
    end)
    runBenchmark('for in loop', itPerBench, function()
      for loopIterator in pairs { 1 } do
        void(loopIterator)
      end
    end)
    if unpack or table.unpack then
      local un = unpack or table.unpack
      runBenchmark('unpack array', itPerBench, function()
        void(un { 1, 2, 3 })
      end)
    end
    runBenchmark('or(false,true)', itPerBench, function()
      void(false or true)
    end, 20 / 3)
    runBenchmark('or(false,false)', itPerBench, function()
      void(false or false)
    end, 20 / 3)
    runBenchmark('or(true,true)', itPerBench, function()
      void(true or true)
    end, 20 / 3)
    runBenchmark('and(false,true)', itPerBench, function()
      void(false and true)
    end, 20 / 3)
    runBenchmark('and(false,false)', itPerBench, function()
      void(false and false)
    end, 20 / 3)
    runBenchmark('and(true,true)', itPerBench, function()
      void(true and true)
    end, 20 / 3)
    runBenchmark('and(true,1+1)', itPerBench, function()
      void(true and 1 + 1)
    end, 20 / 3)
    if string and string.format then
      runBenchmark('str.format', itPerBench, function()
        void(string.format('%s %s', s, s))
      end)
    end
    runBenchmark('tonumber(i)', itPerBench, function()
      void(tonumber(iStr))
    end, 5)
    runBenchmark('tostring(i)', itPerBench, function()
      void(tostring(i))
    end)
    rsw()
  end
end
-- local BenchmarkEnd = os.clock();

-- local BenchmarkTime = BenchmarkEnd - BenchmarkStart
-- print('Final Benchmark Score', ' ', ' ', 1 / BenchmarkTime)
print('Final Benchmark Score', ' ', ' ', TotalScore / Iterations, '(Averaged across ' .. Iterations .. ' iterations)')
print('SimpleBench ' .. Version .. ' by Expo#3961')

return TotalScore / Iterations

--[[
  https://github.com/AstolfoBrew/SimpleBench/blob/main/LICENSE
  ============================================================
  MIT License

  Copyright (c) 2022 Expo#3961

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
]]
