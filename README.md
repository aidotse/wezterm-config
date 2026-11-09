# wezterm-config

My personal [WezTerm](https://wezterm.org/) configuration, tuned for Windows with WSL (Ubuntu) as the default shell.

## Install

WezTerm reads `.wezterm.lua` from your home directory. On Windows that's `C:\Users\<you>\.wezterm.lua`.

Copy the file there:

```powershell
copy .wezterm.lua $HOME\.wezterm.lua
```

Or symlink it so edits in this repo apply right away (run from an elevated prompt):

```powershell
New-Item -ItemType SymbolicLink -Path $HOME\.wezterm.lua -Target (Resolve-Path .wezterm.lua)
```

WezTerm hot-reloads the config when you save it. If the file has a syntax error, WezTerm shows a warning and keeps the last config that loaded.

## Features

- **Rendering:** WebGpu front end on the low-power GPU, capped at 120 fps.
- **WSL:** The `WSL:Ubuntu` domain is declared explicitly and set as the default.
- **Fonts:** Consolas, with JetBrains Mono and Segoe UI Symbol/Emoji as fallbacks.
- **Color schemes:** Custom `Scotchy` and `Copilot` schemes, plus `Claude1`–`Claude3` remixes. `Claude3` is the default.
- **Launch menu:** An SSH and a Mosh entry for each host in `~/.ssh/config`.
- **Status bar:** Shows the name of the active color scheme.

## Key bindings

| Keys | Action |
| --- | --- |
| `Ctrl+Shift+L` | Open the launcher (domains, launch menu, fuzzy search) |
| `Ctrl+Shift+T` | Next theme in the favorites list |
| `Ctrl+Shift+R` | Previous theme in the favorites list |
| `Ctrl+Shift+O` | Debug overlay |
| Right click | Paste from clipboard |

## Machine-specific settings

You may need to change these on a new machine:

- `config.dpi_by_screen`: Monitor names are hardware-specific. Get the exact name from the debug overlay.
- `config.wsl_domains`: `distribution` must match the output of `wsl -l -v`.
- `config.max_fps`: Set it to your monitor's refresh rate.

## License

[MIT](LICENSE)
