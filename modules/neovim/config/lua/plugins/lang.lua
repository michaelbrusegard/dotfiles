return {
  { import = 'lazyvim.plugins.extras.lang.angular' },
  { import = 'lazyvim.plugins.extras.lang.cmake' },
  { import = 'lazyvim.plugins.extras.lang.docker' },
  { import = 'lazyvim.plugins.extras.lang.git' },
  { import = 'lazyvim.plugins.extras.lang.go' },
  { import = 'lazyvim.plugins.extras.lang.java' },
  { import = 'lazyvim.plugins.extras.lang.json' },
  { import = 'lazyvim.plugins.extras.lang.kotlin' },
  { import = 'lazyvim.plugins.extras.lang.markdown' },
  { import = 'lazyvim.plugins.extras.lang.nix' },
  { import = 'lazyvim.plugins.extras.lang.omnisharp' },
  { import = 'lazyvim.plugins.extras.lang.python' },
  { import = 'lazyvim.plugins.extras.lang.rust' },
  { import = 'lazyvim.plugins.extras.lang.tailwind' },
  { import = 'lazyvim.plugins.extras.lang.tex' },
  { import = 'lazyvim.plugins.extras.lang.toml' },
  { import = 'lazyvim.plugins.extras.lang.typescript' },
  {
    'benomahony/uv.nvim',
    opts = {
      picker_integration = true,
      keymaps = {
        prefix = '<leader>cu',
      },
    },
  },
}
