local wezterm = require("wezterm")

local function tmux_default_prog()
  local shell = os.getenv("SHELL") or "/bin/zsh"
  local tmux_cmd = "PATH=\"/opt/homebrew/bin:/usr/local/bin:$PATH\"; " ..
    "if [ -n \"$TMUX_BIN\" ] && [ -x \"$TMUX_BIN\" ]; then " ..
    "exec \"$TMUX_BIN\" new-session -A -s main; " ..
    "elif command -v tmux >/dev/null 2>&1; then " ..
    "exec tmux new-session -A -s main; " ..
    "else exec " .. shell .. " -l; fi"

  return { shell, "-lc", tmux_cmd }
end

local function cwd_from_uri(cwd_uri)
  if not cwd_uri then
    return nil
  end

  if type(cwd_uri) == "table" and cwd_uri.file_path then
    return cwd_uri.file_path
  end

  if type(cwd_uri) == "userdata" and cwd_uri.file_path then
    return cwd_uri.file_path
  end

  if type(cwd_uri) == "string" then
    return cwd_uri:gsub("^file://[^/]*", "")
  end

  return nil
end

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  local cwd = cwd_from_uri(pane:get_current_working_dir())
  if cwd then
    local home = wezterm.home_dir
    if home and cwd:sub(1, #home) == home then
      cwd = "~" .. cwd:sub(#home + 1)
    end
    return cwd
  end

  return pane:get_title()
end)

-- Rotate between these:
local IMAGES = {
  wezterm.config_dir .. "/assets/bg.jpg",
}

local ROTATE_SECONDS = 5 * 60 -- <-- set to 60 to test; change to 5*60 for 5 minutes

-- Persist across config reloads
wezterm.GLOBAL.bg_idx = wezterm.GLOBAL.bg_idx or 1

local function make_background(image_path)
  return {
    {
      source = { File = image_path },
      hsb = {
        hue = 1.0,
        brightness = 0.22,
        saturation = 0.7,
      },
    },
    {
      source = { Color = "#1a1b26" },
      opacity = 0.65,
    },
  }
end

-- Schedule the next rotation; the callback triggers a config reload safely
wezterm.time.call_after(ROTATE_SECONDS, function()
  local next_idx = (wezterm.GLOBAL.bg_idx % #IMAGES) + 1
  wezterm.GLOBAL.bg_idx = next_idx
  wezterm.reload_configuration()
end)

local config = {
  automatically_reload_config = true,
  -- Enable CSI u key encoding for modifier+key combinations
  enable_csi_u_key_encoding = true,
  -- Treat Option as Alt/Meta so it doesn't trigger macOS shortcuts
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = false,
  keys = {
    -- Shift+Enter sends CSI u sequence for newline insertion
    {
      key = "Return",
      mods = "SHIFT",
      action = wezterm.action { SendString = string.char(27) .. "[13;2u" },
    },
    -- Option+Enter sends CSI u sequence (overrides default fullscreen toggle)
    {
      key = "Return",
      mods = "ALT",
      action = wezterm.action { SendString = string.char(27) .. "[13;3u" },
    },
  },
  enable_tab_bar = false,
  window_close_confirmation = "NeverPrompt",
  -- Padding doesn't create a draggable region; enable a minimal title bar.
  window_decorations = "TITLE | RESIZE|TITLE",
  default_cursor_style = "BlinkingBar",
  color_scheme = "Nord (Gogh)",
  font = wezterm.font("JetBrains Mono", { weight = "DemiBold", stretch = "Normal", style = "Italic" }),
  font_size = 12.5,

  -- Use the current image
  background = make_background(IMAGES[wezterm.GLOBAL.bg_idx]),
  text_background_opacity = 1.0,

  window_padding = {
    left = 3,
    right = 3,
    top = 10,
    bottom = 0,
  },
}

config.default_prog = tmux_default_prog()

return config
