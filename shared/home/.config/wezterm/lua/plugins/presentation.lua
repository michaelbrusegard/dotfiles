local keybinds = require('util.keybinds')

return function(config)
  require('wezterm').plugin.require('https://github.com/Xarvex/presentation.wez').apply_to_config(config, {
    font_size_multiplier = 1.8,
    presentation = {
      disabled = true,
    },
    presentation_full = {
      keybind = { key = 'p', mods = keybinds.SUPER },
    },
  })
end
