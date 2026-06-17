-- [[ Configure and install plugins ]]

require('lazy').setup({

  {
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
    opts = {},
  },

  require 'original.plugins.blink-cmp',
  require 'original.plugins.conform',
  require 'original.plugins.gitsigns',
  require 'original.plugins.lspconfig',
  require 'original.plugins.todo-comments',

  -- Moved to custom/plugins dir for Customization
  -- require 'original.plugins.indent_line',
  -- require 'original.plugins.neo-tree',
  -- require 'original.plugins.which-key',
  -- require 'original.plugins.telescope',
  -- require 'original.plugins.mini',
  -- require 'original.plugins.tokyonight',
  -- require 'original.plugins.treesitter',

  -- Stopped using - moved to reference dir
  -- require 'original.plugins.autopairs',
  -- require 'original.plugins.debug',
  -- require 'original.plugins.lint',

  { import = 'custom.plugins' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
