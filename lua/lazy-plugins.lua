-- [[ Configure and install plugins ]]

require('lazy').setup({

  'sindrets/diffview.nvim',
  'xiyaowong/transparent.nvim',
  {
    'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
    opts = {},
  },

  { import = 'plugins' },
}, {
  ui = {
    -- enable Lazy float border, border colors set in theme file tokyonight.lua
    border = 'rounded',
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
