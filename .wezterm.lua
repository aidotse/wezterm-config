-- ~/.wezterm.lua
-- Windows path: C:\Users\<you>\.wezterm.lua
--
-- WezTerm watches this file and hot-reloads on save (no restart needed).
-- On a syntax error it shows a warning bar and keeps the last good config,
-- so you can't lock yourself out.
--
-- Performance-related settings are marked with "PERF:".

-- Helper function to safely clone nested tables
local function deep_copy(orig)
  if type(orig) ~= 'table' then
    return orig
  end
  local copy = {}
  for k, v in pairs(orig) do
    copy[deep_copy(k)] = deep_copy(v)
  end
  return copy
end

-- ── Top level config  ──────────────────────────────────────────────────
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ── Rendering ──────────────────────────────────────────────────────────
-- PERF: WebGpu uses DirectX 12 on Windows and is usually the smoothest
-- option. If you see glitches or it feels worse, swap the two front_end
-- lines; prefer_egl routes OpenGL through ANGLE/Direct3D, which is often
-- faster than the native Windows OpenGL driver.
-- 'LowPower' : always use te integrated GPU, avoids copying over to the
-- dedicated GPU.
--config.front_end = 'OpenGL'
--config.prefer_egl = true
config.front_end = 'WebGpu'
--config.webgpu_power_preference = 'HighPerformance'
config.webgpu_power_preference = 'LowPower'

-- PERF: Default is 60. Set this to your monitor's refresh rate
-- (120, 144, 165...). This is the single biggest "feels snappy" knob.
config.max_fps = 120
-- PERF: No cursor/visual-bell animations to drive, so don't wake up for them.
config.animation_fps = 1
-- No bells please
config.audible_bell = 'Disabled'

config.dpi_by_screen = {
  -- Replace the monitor name with the exact name found in debug overlay
  ['DISPLAY6: DELL U2412M on NVIDIA GeForce RTX 4070 Laptop GPU'] = 96.0,
}

-- ── WSL ────────────────────────────────────────────────────────────────
-- PERF: Declaring the domain explicitly means WezTerm doesn't have to run
-- `wsl.exe -l -v` to discover distros every time this config is evaluated.
-- Run `wsl -l -v` once yourself and make sure 'Ubuntu' matches exactly.
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_cwd = '~',
  },
}
config.default_domain = 'WSL:Ubuntu'

-- ── Font ───────────────────────────────────────────────────────────────
-- Fonts must be installed on THIS machine (Windows). WezTerm renders
-- locally even when you're SSH'd into the VM, so the font lives client-side.
-- PERF: Consolas lacks many of the symbols Claude Code draws in its UI.
-- Listing fallbacks explicitly stops WezTerm from scanning every system
-- font the first time it meets a missing glyph (a visible hitch).

config.font = wezterm.font_with_fallback {
  --'Hack',
  'Consolas',
  'JetBrains Mono',
  'Segoe UI Symbol',
  'Segoe UI Emoji',
}
config.font_size = 11
config.line_height = 1.1
config.cell_width = 0.85

-- ── Cursor (Warp uses a block) ─────────────────────────────────────────
config.default_cursor_style = 'SteadyBlock' -- 'SteadyBlock' for no blink
config.cursor_blink_rate = 500

-- ── HiDPI rendering: grayscale AA, light hinting for shape fidelity ────

--config.freetype_load_target = 'Light'
-- config.freetype_render_target = 'VerticalLcd'

-- ── Color scheme  ──────────────────────────────────────────────────────

config.color_schemes = {}

-- Scotchy — converted from the Sublime Text theme
-- "10% Too Dull for My Tastes" (scotch-io). Cyan borrowed from its
-- parent theme, Behave (fnky/behave-theme), which scotchy was forked from.
local scotchy = {
  foreground = '#ffffff',
  background = '#272d35',

  cursor_bg = '#ffffff',
  cursor_fg = '#272d35',
  cursor_border = '#ffffff',

  selection_fg = '#ffffff',
  selection_bg = '#434d5b',

  scrollbar_thumb = '#535e6f',
  split = '#535e6f',

  -- normal:  black      red        green      yellow     blue       magenta    cyan       white
  ansi = {
    '#434d5b', -- black
    '#ff8a8a', -- red     (keyword / tag)
    '#a6e22e', -- green   (diff inserted)
    '#facb68', -- yellow  (linter warning)
    '#9ccdff', -- blue    (function)
    '#967efb', -- magenta (diff changed)
    '#7dcbc4', -- cyan    (from Behave, scotchy's parent theme)
    '#ced1cf', -- white   (foreground / misc)
  },

  -- bright:  black      red        green      yellow     blue       magenta    cyan       white
  brights = {
    '#535e6f', -- br black   (comment)
    '#ffb5a0', -- br red     (operator / salmon)
    '#c3f06a', -- br green   (lightened)
    '#fffbd4', -- br yellow  (variable)
    '#bfe0ff', -- br blue    (lightened)
    '#e5d4ff', -- br magenta (number / constant)
    '#a3ded8', -- br cyan    (lightened from Behave's #7dcbc4)
    '#fefffd', -- br white   (class / near-white)
  },

  tab_bar = {
    background = '#1f242b',
    active_tab = { bg_color = '#272d35', fg_color = '#ffffff' },
    inactive_tab = { bg_color = '#343c48', fg_color = '#bdc1c7' },
    inactive_tab_hover = { bg_color = '#434d5b', fg_color = '#ffffff' },
    new_tab = { bg_color = '#272d35', fg_color = '#535e6f' },
    new_tab_hover = { bg_color = '#434d5b', fg_color = '#ffffff' },
  },
}
config.color_schemes['Scotchy'] = deep_copy(scotchy)

-- Copilot theme from https://github.com/benjaminbenais/copilot-theme/blob/main/themes/Copilot%20Theme-color-theme.json
local copilot = {
  foreground = '#939da5',
  background = '#232a2f',

  cursor_bg = '#939da5',
  cursor_fg = '#232a2f',
  cursor_border = '#939da5',

  selection_fg = '#d4dce4',
  selection_bg = '#204062',

  scrollbar_thumb = '#707a84',
  split = '#1a2023',

  -- normal
  ansi = {
    '#1a2023', -- black
    '#ff6a80', -- red
    '#5bec95', -- green
    '#ffea6b', -- yellow
    '#204062', -- blue (Changed from #89ddff to a dark blue for Mosh backgrounds)
    '#ba8ef7', -- magenta
    '#56adb7', -- cyan
    '#939da5', -- white
  },
  -- bright
  brights = {
    '#707a84', -- bright black (comments)
    '#ff8ad1', -- bright red / pink
    '#c3e88d', -- bright green
    '#ffa763', -- bright yellow / orange
    '#89ddff', -- bright blue
    '#ba8ef7', -- bright magenta
    '#89ddff', -- bright cyan
    '#d4dce4', -- bright white
  },

  tab_bar = {
    background = '#1a2023',
    active_tab = { bg_color = '#232a2f', fg_color = '#d4dce4' },
    inactive_tab = { bg_color = '#1a2023', fg_color = '#939da5' },
    inactive_tab_hover = { bg_color = '#232a2f', fg_color = '#d4dce4' },
    new_tab = { bg_color = '#1a2023', fg_color = '#939da5' },
    new_tab_hover = { bg_color = '#232a2f', fg_color = '#d4dce4' },
  },
}
config.color_schemes['Copilot'] = deep_copy(copilot)

-- Mix&match custom themes.
-- PERF: get_builtin_schemes() builds a Lua table of ~1000 schemes, and it
-- was being called three times on every config load. Call it once, then
-- deep_copy the individual entries you modify so they don't share a table.
local builtin = wezterm.color.get_builtin_schemes()
local helios = builtin['Helios (base16)']
local claude1 = deep_copy(builtin['Atom'])
local claude2 = deep_copy(builtin['Atom'])
local claude3 = deep_copy(copilot) -- copy, so changing it doesn't alter `copilot`
claude1.background = scotchy.background
claude2.background = helios.background
claude3.background = helios.background
config.color_schemes['Claude1'] = claude1
config.color_schemes['Claude2'] = claude2
config.color_schemes['Claude3'] = claude3

-- Cycle through these themes
local favorite_themes = {
  'Afterglow',
  'Andromeda',
  'Apprentice (Gogh)',
  'Atelier Plateau (base16)',
  'Atelierforest (dark) (terminal.sexy)',
  'Atom',
  'Aura (Gogh)',
  'Ayu Dark (Gogh)',
  'Ayu Mirage',
  'Bamboo',
  'Batman',
  'Bespin (dark) (terminal.sexy)',
  'Black Metal (Bathory) (base16)',
  'Blazer',
  'BlulocoDark',
  'Breath Silverfox (Gogh)',
  'Breeze (Gogh)',
  'Brewer (base16)',
  'Bright Lights',
  'Broadcast',
  'Brogrammer',
  'Builtin Pastel Dark',
  'Cai (Gogh)',
  'Campbell (Gogh)',
  'Catppuccin Mocha',
  'Chalk',
  'Chalk (dark) (terminal.sexy)',
  'Chameleon (Gogh)',
  'Circus (base16)',
  'Claude1',
  'Claude2',
  'Claude3',
  'Cobalt 2 (Gogh)',
  'Codeschool (base16)',
  'Copilot',
  'Dark+', --mark
  'Darkside',
  'Dracula',
  'Dracula (Gogh)',
  'Default',
  'Everblush',
  'GitHub Dark',
  'Google Dark (Gogh)',
  'Helios (base16)',
  'Hybrid',
  'Japanesque',
  'JetBrains Darcula',
  'MaterialDark',
  'MaterialDesignColors',
  'Neutron',
  'Porple (base16)',
  'Ryuuko',
  'Scotchy',
  'Snazzy',
  'Tartan (terminal.sexy)',
  'Tomorrow (dark) (terminal.sexy)',
}
-- Set default theme on startup
config.color_scheme = 'Claude3'

-- Start theme cycling from the startup theme's position in the list
local current_theme_index = 1
for i, name in ipairs(favorite_themes) do
  if name == config.color_scheme then
    current_theme_index = i
    break
  end
end

-- ── Launch menu ──────────────────────────────────────
config.launch_menu = {}
for host, _ in pairs(wezterm.enumerate_ssh_hosts()) do
  if not host:find('[*?]') then
    table.insert(config.launch_menu, {
      label = 'SSH: ' .. host,
      args = { 'ssh.exe', host },
      domain = { DomainName = 'local' },
    })
    table.insert(config.launch_menu, {
      label = 'Mosh: ' .. host,
      args = { 'wsl.exe', '-e', 'mosh', host },
      domain = { DomainName = 'local' },
    })
  end
end

-- Kept for A/B testing against the WSL:Ubuntu domain; see notes.
table.insert(config.launch_menu, {
  label = 'FastWSL (Ubuntu)',
  args = { 'wsl.exe', '--cd', '~', '-d', 'Ubuntu' },
  domain = { DomainName = 'local' },
})

-- ── Window  ────────────────────────────────────────────────────────────
config.window_padding = { left = 10, right = 10, top = 8, bottom = 8 }
config.window_decorations = 'TITLE | RESIZE'
config.window_background_opacity = 1 -- opaque = cheapest to composite
config.win32_system_backdrop = 'Disable'
config.enable_tab_bar = true -- show the tab bar (with the + button)
config.hide_tab_bar_if_only_one_tab = false -- keep it visible even with one tab
config.show_new_tab_button_in_tab_bar = true -- the "+" new-tab button
config.use_fancy_tab_bar = true -- false = lighter "retro" bar (optional)
config.adjust_window_size_when_changing_font_size = false
config.exit_behavior = 'Hold'

-- ── Keys ───────────────────────────────────────────────────────────────
local function set_theme(window, index)
  current_theme_index = index
  local overrides = window:get_config_overrides() or {}
  overrides.color_scheme = favorite_themes[index]
  window:set_config_overrides(overrides)
end

config.keys = {

  -- Debug overlay
  {
    key = 'O',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowDebugOverlay,
  },

  -- Opens Launcher
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = act.ShowLauncherArgs { flags = 'FUZZY|DOMAINS|LAUNCH_MENU_ITEMS' },
  },

  -- Cycle FORWARD through color themes
  {
    key = 'T',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, _)
      set_theme(window, current_theme_index % #favorite_themes + 1)
    end),
  },

  -- Cycle BACKWARD through color themes
  {
    key = 'R',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, _)
      set_theme(window, (current_theme_index - 2) % #favorite_themes + 1)
    end),
  },
}

-- ── Mouse Bindings ─────────────────────────────────────────────────────
config.mouse_bindings = {
  -- Right-click to paste from clipboard
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
}

wezterm.on('update-status', function(window, _)
  local overrides = window:get_config_overrides() or {}
  local current_theme = overrides.color_scheme or config.color_scheme
  window:set_right_status(' 🎨 Theme: ' .. current_theme .. ' ')
end)

return config
