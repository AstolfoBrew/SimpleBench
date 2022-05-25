<span align="center">

# Simple ┬─┬ Bench

[![Tests](https://github.com/AstolfoBrew/SimpleBench/actions/workflows/tests.yml/badge.svg)](https://github.com/AstolfoBrew/SimpleBench/actions/workflows/tests.yml)

A Simple Lua VM Benchmarking Library

### Notice

> Scores may vary depending on the device.<br/>
> Please make sure to, when comparing scores, have all scores ran on the same device.
>
> **SimpleBench does not adjust depending on the current hardware it's being ran on.**

## Compatability

SimpleBench is compatible with Lua 5.1 and upwards.<br/>
It _should_ be compatible with LuaJIT, but thats not included in the tests.<br/>
SimpleBench _is_ compatible with Luau, and therefor _almost_ any Roblox executor.

**SimpleBench is _not_ compatible with Lua 5.0 or below**

## Pre-calculated scores

There are pre-calculated scores for [Luau](out/lua-luau.log), [Lua 5.1](out/lua-5.1.log), [Lua 5.2](out/lua-5.2.log) and [Lua 5.3](out/lua-5.3.log).

## Setting Up

### Regular Lua Envs

In a regular lua environment, simply follow these steps:

1. Get a Lua Enironment
2. Download SimpleBench ([Stable](https://github.com/AstolfoBrew/SimpleBench/releases/latest/download/SimpleBench.lua) (Recommended), or [Dev Build](https://github.com/AstolfoBrew/SimpleBench/blob/main/SimpleBench.lua))
3. Run SimpleBench in Lua (ie `lua SimpleBench.lua`)
4. Look for the [Final Benchmark Score](https://github.com/AstolfoBrew/SimpleBench/blob/75f4e659bd86e26bfa5a32d3bbc1de5793161442/out/lua-5.3.log#L999) at the end of the output

### Roblox Studio

Soon:tm:

### Roblox Executors

1. Run this in your executor of choice:

</span>

```lua
local Settings = {
  ['RBXWaitAfterRun'] = false; -- If roblox never unfreezes, or it crashes, change false here to true.
  ['Branch'] = 'Release'; --      Change to `main` if you want to use the latest development version. Please note that it's score may be different between commits.
  ['Iterations'] = 50; --         If your results vary a lot, increase this. If, with RBXWaitAfterRun, it takes way too long, you can lower this number, however this will make the result less accurate.
};
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/AstolfoBrew/SimpleBench/main/RBXExecutorLoader.lua'))(Settings);
```

<span align="center">

2. Roblox will freeze for a bit. This is normal.

---

If your executor **does** support `writefile()`:

1. Open `workspace/SimpleBench.log` (using Notepad, VS Code, or anything else that can open text files)
2. At the top, you should see

```yml
Final Score:
<Some Score>
```

3. `<Some Score>` is the final score.

---

If your executor does **not** support `writefile()` however (ie it doesn't have a workspace folder, or its a SS exec), or for some reason the above didn't work:

1. Press F9
2. At the bottom, you should see `Final Benchmark Score <Some Score> (Averaged across <Some Number> iterations)`
3. The final score is `<Some Score>`

</span>
