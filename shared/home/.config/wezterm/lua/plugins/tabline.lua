local wezterm = require('wezterm')
local colors = require('util.colors')

return function()
  local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')

  tabline.setup({
    options = {
      theme = 'Catppuccin Mocha',
      section_separators = {
        left = wezterm.nerdfonts.ple_right_half_circle_thick,
        right = wezterm.nerdfonts.ple_left_half_circle_thick,
      },
      component_separators = {
        left = wezterm.nerdfonts.ple_right_half_circle_thin,
        right = wezterm.nerdfonts.ple_left_half_circle_thin,
      },
      tab_separators = {
        left = wezterm.nerdfonts.ple_right_half_circle_thick,
        right = wezterm.nerdfonts.ple_left_half_circle_thick,
      },
    },
    sections = {
      tabline_a = {
        { 'mode', fmt = string.lower },
      },
      tab_active = {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { Color = colors.ansi[6] } },
        'index',
        'ResetAttributes',
        { Foreground = { Color = colors.foreground } },
        { 'parent', padding = 0 },
        '/',
        { Attribute = { Intensity = 'Bold' } },
        { 'cwd', padding = { left = 0, right = 1 } },
        { 'zoomed', padding = 0 },
      },
      tab_inactive = { 'index', { 'process', icons_only = true, padding = 0 } },
      tabline_x = {},
      tabline_y = { 'ram', 'cpu' },
    },
    extensions = {
      'resurrect',
      'smart_workspace_switcher',
      'quick_domains',
      'presentation',
    },
  })
end