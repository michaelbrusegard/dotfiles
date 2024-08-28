local wezterm = require('wezterm')

return function(config)
  local workspace_switcher = wezterm.plugin.require('https://github.com/MLFlexer/smart_workspace_switcher.wezterm')
  workspace_switcher.apply_to_config(config)
  workspace_switcher.zoxide_path = '/opt/homebrew/bin/zoxide'

  workspace_switcher.workspace_formatter = function(label)
    return wezterm.format({
      { Foreground = { Color = require('util.colors')['compose_cursor'] } },
      { Text = wezterm.nerdfonts.md_dock_window .. ' : ' .. label },
    })
  end

  table.insert(config.keys, {
    key = 'Enter',
    mods = 'SUPER',
    action = workspace_switcher.switch_workspace({
      extra_args = " | grep -E \"^($(echo ~/Developer | sed 's:/*$::')/|$(echo ~/dotfiles | sed 's:/*$::')$|$(echo ~/dotfiles-private | sed 's:/*$::')$)\" | grep -v \"^$(echo ~/test | sed 's:/*$::')$\" | awk -F'/' 'NF<=5'",
    }),
  })
end
