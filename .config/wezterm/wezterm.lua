local wezterm = require("wezterm")

-- Rotate between these:
local IMAGES = {
  "/Users/orenhollander/Pictures/bg.jpg",
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
  enable_tab_bar = false,
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",
  default_cursor_style = "BlinkingBar",
  color_scheme = "Nord (Gogh)",
  font = wezterm.font("JetBrains Mono", { weight = "DemiBold", stretch = "Normal", style = "Italic" }),
  font_size = 12.5,

  -- Use the current image
  background = make_background(IMAGES[wezterm.GLOBAL.bg_idx]),
  text_background_opacity = 0.0,

  window_padding = {
    left = 3,
    right = 3,
    top = 0,
    bottom = 0,
  },
}

return config
