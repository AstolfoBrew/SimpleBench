# Contributing to SimpleBench

First and foremost, thank you! We appreciate that you want to contribute to SimpleBench, your time is valuable, and your contributions mean a lot to me/us.

<!-- yes, the above text is from https://github.com/generate/generate-contributing/blob/e9becbfd164ede91246446200039cf6661d8ae1e/templates/contributing.md -->

## Important!

By contributing, you agree that:
- The code you provide will be licensed under the [MIT License](LICENSE)
- You have authored the entirety of the content, unless otherwise specified by any necessary licenses or attribution.
- You have the necessary rights to the content.

## Commits

Commits here *should* follow the [Conventional Commits Standard](https://www.conventionalcommits.org/en/v1.0.0/).

PRs which do not follow this standard have a lower chance of getting merged.

###### Scores

> For submitting scores, simply do something like `feat: Add new <EXECUTOR> result`, with an optional 2nd line containing the score

## Submitting Scores

Roblox Executor Scores must follow [these guidelines](out/Roblox/).

They should follow [the score-specific commit message guideline](#scores) aswell, if possible.

## Formatter/Linter

You should use one of the following linters/formatters on/for all submitted code:
- [Stylua](https://marketplace.visualstudio.com/items?itemName=JohnnyMorganz.stylua) ([Repo](https://github.com/johnnymorganz/stylua)) or;
- [LuaFormatter](https://marketplace.visualstudio.com/items?itemName=Koihik.vscode-lua-format) ([Repo](https://github.com/Koihik/LuaFormatter)) using the configs specified in this repository.

We use Stylua in Github Actions, so using it will cause the least errors, however LuaFormatter should work just fine too.