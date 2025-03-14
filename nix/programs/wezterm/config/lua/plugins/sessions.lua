local wezterm = require('wezterm')

return function(config)
  local resurrect = wezterm.plugin.require('https://github.com/MLFlexer/resurrect.wezterm')

  resurrect.state_manager.periodic_save()

  resurrect.state_manager.set_encryption({
    enable = true,
    method = '/opt/homebrew/bin/gpg',
    public_key = '6596A3ED40F6534894332DD2ECC513C0F9798B79',
  })

  -- loads the state whenever I create a new workspace
  wezterm.on('smart_workspace_switcher.workspace_switcher.created', function(window, _, label)
    resurrect.workspace_state.restore_workspace(resurrect.state_manager.load_state(label, 'workspace'), {
      window = window,
      relative = true,
      restore_text = true,
      on_pane_restore = resurrect.tab_state.default_on_pane_restore,
    })
  end)

  -- Saves the state whenever I select a workspace
  wezterm.on('smart_workspace_switcher.workspace_switcher.selected', function()
    local workspace_state = resurrect.workspace_state
    resurrect.state_manager.save_state(workspace_state.get_workspace_state())
  end)

  table.insert(config.keys, {
    key = 'Enter',
    mods = 'SHIFT|SUPER',
    action = wezterm.action.Multiple({
      wezterm.action_callback(function(window, pane)
        resurrect.fuzzy_loader.fuzzy_load(window, pane, function(id)
          id = string.match(id, '([^/]+)$')
          id = string.match(id, '(.+)%..+$')
          resurrect.workspace_state.restore_workspace(resurrect.load_state(id, 'workspace'), {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        end, {
          fuzzy_description = nil,
          fmt_workspace = function(name)
            return wezterm.format({
              { Foreground = { Color = config.colors.ansi[3] } },
              {
                Text = wezterm.nerdfonts.cod_terminal_tmux .. ' ' .. string.match(name, '[^~+]+$'):gsub('%.json$', ''),
              },
            })
          end,
          fmt_window = function(name)
            return wezterm.format({
              { Foreground = { Color = config.colors.ansi[3] } },
              {
                Text = wezterm.nerdfonts.cod_window .. ' ' .. string.match(name, '[^~+]+$'):gsub('%.json$', ''),
              },
            })
          end,
          fmt_tab = function(name)
            return wezterm.format({
              { Foreground = { Color = config.colors.ansi[3] } },
              {
                Text = wezterm.nerdfonts.cod_chrome_restore .. ' ' .. string.match(name, '[^~+]+$'):gsub('%.json$', ''),
              },
            })
          end,
        })
      end),
    }),
  })
end
