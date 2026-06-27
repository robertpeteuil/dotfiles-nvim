return {
  'chrishrb/gx.nvim',
  keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
  cmd = { 'Browse' },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  dependencies = { 'nvim-lua/plenary.nvim' }, -- Required for Neovim < 0.10.0
  submodules = false, -- not needed, submodules are required only for tests

  -- you can specify also another config if you want
  config = function()
    require('gx').setup {
      handler_options = {
        search_engine = 'https://kagi.com/search?q=',
      },
    }
  end,
}
