return {
  'smart-splits-nvim/smart-splits.nvim',
  version = '^3.0.0',
  dependencies = {
    {
      'rawnly/smart-splits-nvim--backend-rex',
      opts = {
        -- bin = 'rex',     -- name or path of the rex executable
        -- timeout = 2000,  -- ms to wait for a rex command
      },
    },
  },
  opts = {
    mux = {
      backend = 'smart-splits-backend-rex',
    },
  },
  keys = function()
    local ss = require('smart-splits')
    return {
      { '<C-h>', ss.move_cursor_left },
      { '<C-j>', ss.move_cursor_down },
      { '<C-k>', ss.move_cursor_up },
      { '<C-l>', ss.move_cursor_right },
      { '<A-h>', ss.resize_left },
      { '<A-j>', ss.resize_down },
      { '<A-k>', ss.resize_up },
      { '<A-l>', ss.resize_right },
    }
  end,
}
