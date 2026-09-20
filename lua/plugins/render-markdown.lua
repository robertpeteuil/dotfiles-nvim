return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  opts = {},
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.nvim',
  },
  config = function()
    require('render-markdown').setup {
      -- Whether markdown should be rendered by default.
      enabled = false,
      -- Vim modes that will show a rendered view of the markdown file, :h mode(), for all enabled
      -- components. Individual components can be enabled for other modes. Remaining modes will be
      -- unaffected by this plugin.
      -- render_modes = { 'n', 'c' },
      completions = { lsp = { enabled = true } },
      pipe_table = {
        -- disable wrapping individual table cells 20260914
        --   feature: fit wide tables to the current window - rendering slowness unpredictability
        --   https://github.com/MeanderingProgrammer/render-markdown.nvim/commit/a778444a73080301a50c4a6f58c90d7e094dd59e
        wrap = false,
      },
    }
  end,
}
