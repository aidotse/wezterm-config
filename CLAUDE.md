# CLAUDE.md

Personal WezTerm config. The whole config is `.wezterm.lua`. It runs in WezTerm on Windows (`C:\Users\<you>\.wezterm.lua`) and opens WSL (Ubuntu) by default; this repo is checked out inside WSL.

## Working on the config

- WezTerm embeds Lua 5.4. Use the WezTerm API (`wezterm.config_builder()`, `wezterm.action`) and check option names against https://wezterm.org/config/lua/config/ before adding them.
- The config can't be run from WSL. WezTerm hot-reloads it on save and shows a warning bar on errors. `Ctrl+Shift+O` opens the debug overlay, which also shows monitor names for `dpi_by_screen`.
- Values tied to this machine (monitor names, the WSL distro name, `max_fps`) are listed in the README. Don't change them unless asked.
- Every name in `favorite_themes` must match a built-in scheme exactly or be registered in `config.color_schemes`.
- Use `deep_copy` before changing a scheme taken from another table, so the original isn't changed too.

## Comments

- Comments explain why the code is the way it is, not its history. Don't add "FIX:" or "was X, now Y" notes; that belongs in commit messages.
- `PERF:` marks settings chosen for rendering performance.

## Lint

CI runs StyLua (`stylua.toml`) and luacheck (`.luacheckrc`), and both are required checks. Run them locally if installed:

```sh
stylua --check .wezterm.lua
luacheck .wezterm.lua
```

Pass files explicitly, since directory scans may skip dotfiles. A new Lua file must also be added to the `args` in `.github/workflows/lint.yml`.

## Git

- `main` is protected: no direct pushes, no force-pushes. Work on a branch and open a PR.
- PRs are merged with merge commits only, by the owner.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `ci:`, `docs:`, `chore:`).
- The `stylua` and `luacheck` job names are the ruleset's required checks; renaming a job means updating the ruleset.
