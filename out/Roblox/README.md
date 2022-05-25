## Per-Executor
To add a script to this list, use this script:
```lua
local Settings = {
  ['RBXWaitAfterRun'] = true; -- If roblox never unfreezes, or it crashes, change false here to true.
  ['Branch'] = 'main'; --      Change to `main` if you want to use the latest development version. Please note that it's score may be different between commits.
  ['Iterations'] = 128; --         If your results vary a lot, increase this. If, with RBXWaitAfterRun, it takes way too long, you can lower this number, however this will make the result less accurate.
};
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/AstolfoBrew/SimpleBench/main/RBXExecutorLoader.lua'))(Settings);
```

In a PR, your file MUST include the **FULL OUTPUT** combined with a first line containing the most recent commit that modified SimpleBench.lua, aswell as further info, in the following format:
```yml
Ran by DiscordUsername#0001 on Executor in Game on Date-in-DD.MM.YYYY-Format at Time-In-12h-Format Timezone on version Script-Version (Commit-Hash)
```
Example:
```yml
Ran by Yielding#3961 on Script-Ware in Lumber Tycoon 2 on 25.05.2022 at 1:55PM CEST on version 1.1.2-DEV (bcc942f784beea7f939c60729eb0686ea4987b4c)
```
